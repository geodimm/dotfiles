// Pixel Scatter for Ghostty 1.3.1+.
// Analytic springs and particles; no feedback texture or persistent particle state.
// Each cursor movement starts a new burst. Coordinates use cursor-height units.

// Catppuccin Macchiato accent palette.
// RGB channels (0-255) divided by 255 for GLSL's 0-1 range.
const vec3 ROSEWATER = vec3(244.0, 219.0, 214.0) / 255.0; // #f4dbd6 // 0
const vec3 FLAMINGO  = vec3(240.0, 198.0, 198.0) / 255.0; // #f0c6c6 // 1
const vec3 PINK      = vec3(245.0, 189.0, 230.0) / 255.0; // #f5bde6 // 2
const vec3 MAUVE     = vec3(198.0, 160.0, 246.0) / 255.0; // #c6a0f6 // 3
const vec3 RED       = vec3(237.0, 135.0, 150.0) / 255.0; // #ed8796 // 4
const vec3 MAROON    = vec3(238.0, 153.0, 160.0) / 255.0; // #ee99a0 // 5
const vec3 PEACH     = vec3(245.0, 169.0, 127.0) / 255.0; // #f5a97f // 6
const vec3 YELLOW    = vec3(238.0, 212.0, 159.0) / 255.0; // #eed49f // 7
const vec3 GREEN     = vec3(166.0, 218.0, 149.0) / 255.0; // #a6da95 // 8
const vec3 TEAL      = vec3(139.0, 213.0, 202.0) / 255.0; // #8bd5ca // 9
const vec3 SKY       = vec3(145.0, 215.0, 227.0) / 255.0; // #91d7e3 // 10
const vec3 SAPPHIRE  = vec3(125.0, 196.0, 228.0) / 255.0; // #7dc4e4 // 11
const vec3 BLUE      = vec3(138.0, 173.0, 244.0) / 255.0; // #8aadf4 // 12
const vec3 LAVENDER  = vec3(183.0, 189.0, 248.0) / 255.0; // #b7bdf8 // 13

// First palette color. Use an index from the palette order above:
const int START_COLOR_INDEX = 12;

// true = choose a new palette color for each cursor movement or focus burst.
// false = start every burst with START_COLOR_INDEX.
const bool CYCLE_COLOR_PER_BURST = false;

// true = give consecutive particles different palette colors.
// false = use one color for every particle in a burst.
const bool DIFFERENT_COLOR_PER_PARTICLE = true;

// Number of particles per burst (positive integer).
// Higher = denser scatter and more GPU work. A new movement replaces the burst.
const int PARTICLE_COUNT = 50;

// Seconds over which particles are released after movement or focus.
// Lower = a quick pop; higher = a longer release along the moving emitter.
// Keep above 0. This spreads the same particle count over time.
const float EMISSION_TIME = 0.30;

// Maximum particle lifetime in seconds (keep above 0).
// Individual lifetimes vary from 45% to 100% of this value.
// Higher = particles linger and travel farther before fading.
const float PARTICLE_LIFETIME = 1.0;

// Maximum distance from the new cursor to the burst's starting point,
// measured in cursor heights. Higher = longer trails on large cursor jumps.
// This caps the emission path, not how far particles can scatter from it.
const float MAX_TRAIL_HEIGHTS = 10.0;

// Maximum particle opacity: 0 = invisible, 1 = fully opaque.
// Particles fade during their lifetime; overlapping particles share this cap.
const float OPACITY = 0.90;

// Base square size as a fraction of cursor height: 0.080 = 8.0%.
// Rounded to whole framebuffer pixels, with a minimum of 2 pixels.
// Also sets the movement grid size; 20% of particles have twice this side length.
// Higher = larger blocks and chunkier movement.
const float PIXEL_SIZE_IN_CURSOR_HEIGHTS = 0.080;

// true = scatter pixels when a Ghostty pane gains focus, even without movement.
// false = emit only after the cursor moves.
const bool BURST_ON_FOCUS = true;

float hash(float n) {
    return fract(sin(n * 127.1 + 311.7) * 43758.5453);
}

vec3 paletteColor(float index) {
    float i = mod(floor(index), 14.0);
    if (i < 1.0) return ROSEWATER;
    if (i < 2.0) return FLAMINGO;
    if (i < 3.0) return PINK;
    if (i < 4.0) return MAUVE;
    if (i < 5.0) return RED;
    if (i < 6.0) return MAROON;
    if (i < 7.0) return PEACH;
    if (i < 8.0) return YELLOW;
    if (i < 9.0) return GREEN;
    if (i < 10.0) return TEAL;
    if (i < 11.0) return SKY;
    if (i < 12.0) return SAPPHIRE;
    if (i < 13.0) return BLUE;
    return LAVENDER;
}

vec2 cursorCenter(vec4 cursor) {
    return cursor.xy + vec2(cursor.z, -cursor.w) * 0.5;
}

float rectangleDistance(vec2 p, vec2 halfSize) {
    vec2 q = abs(p) - halfSize;
    return length(max(q, 0.0)) + min(max(q.x, q.y), 0.0);
}

// Underdamped step response: starts at rest, overshoots, then settles.
float spring(float t, float decay, float frequency) {
    return 1.0 - exp(-decay * t)
        * (cos(frequency * t) + decay / frequency * sin(frequency * t));
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    fragColor = texture(iChannel0, fragCoord / iResolution.xy);
    if (iFocus == 0 || iCursorVisible == 0 || iCurrentCursor.w <= 0.0) {
        return;
    }

    bool focusBurst = iTimeFocus >= iTimeCursorChange;
    if (focusBurst && !BURST_ON_FOCUS) {
        return;
    }
    float eventTime = focusBurst ? iTimeFocus : iTimeCursorChange;
    float age = max(iTime - eventTime, 0.0);
    if (age >= EMISSION_TIME + PARTICLE_LIFETIME) {
        return;
    }

    float height = iCurrentCursor.w;
    float aa = 1.0 / height;
    vec2 current = cursorCenter(iCurrentCursor);
    vec2 p = (fragCoord - current) / height;
    vec2 origin = (cursorCenter(iPreviousCursor) - current) / height;
    if (focusBurst) {
        origin = vec2(0.0);
    }
    float jump = length(origin);
    if (!focusBurst && jump < 0.01) {
        return;
    }
    origin *= min(1.0, MAX_TRAIL_HEIGHTS / max(jump, 0.001));

    // Skip the particle loop outside the swept cursor and outward scatter.
    vec2 lower = min(origin, vec2(0.0)) - vec2(5.0);
    vec2 upper = max(origin, vec2(0.0)) + vec2(5.0);
    if (any(lessThan(p, lower)) || any(greaterThan(p, upper))) {
        return;
    }

    // Preserve the actual terminal cursor and the character underneath it.
    float cursorSdf = rectangleDistance(p, iCurrentCursor.zw / height * 0.5);
    float outsideCursor = smoothstep(0.0, aa, cursorSdf);
    if (outsideCursor <= 0.0) {
        return;
    }

    vec3 particleColor = vec3(0.0);
    float coverage = 0.0;
    float pixelSize = max(2.0, floor(height * PIXEL_SIZE_IN_CURSOR_HEIGHTS + 0.5));

    // Stable seeds for this movement; pixel positions snap to a framebuffer grid.
    float seed = mod(eventTime, 1024.0) * 17.0;
    for (int i = 0; i < PARTICLE_COUNT; ++i) {
        float id = float(i);
        float r0 = hash(seed + id * 7.0);
        float r1 = hash(seed + id * 7.0 + 1.0);
        float r2 = hash(seed + id * 7.0 + 2.0);
        float r3 = hash(seed + id * 7.0 + 3.0);
        float birth = (id + r0) / float(PARTICLE_COUNT) * EMISSION_TIME;
        float t = age - birth;
        float lifetime = PARTICLE_LIFETIME * mix(0.45, 1.0, r2);
        if (t < 0.0 || t >= lifetime) {
            continue;
        }

        vec2 emitter = mix(origin, vec2(0.0), spring(birth, 18.0, 24.0));
        emitter += vec2(r0 - 0.5, r1 - 0.5) * vec2(0.45, 0.75);
        float angle = r1 * 6.283185;
        vec2 velocity = vec2(cos(angle), sin(angle)) * mix(3.0, 7.0, r2);
        // Inherit a bounded amount of cursor momentum, then damp it.
        velocity -= origin * 0.30;
        float drift = (1.0 - exp(-3.0 * t)) / 3.0;
        vec2 position = emitter + velocity * drift;

        float life = t / lifetime;
        // Whole-pixel square edges, no halo, stretch, rotation, or gravity.
        float side = pixelSize * (r3 > 0.8 ? 2.0 : 1.0);
        vec2 corner = floor((current + position * height - side * 0.5) / pixelSize) * pixelSize;
        vec2 inside = step(corner, fragCoord) * (1.0 - step(corner + vec2(side), fragCoord));
        float square = inside.x * inside.y;
        float fade = (1.0 - smoothstep(0.30, 1.0, life)) * smoothstep(0.0, 0.018, t);
        float alpha = square * fade;
        float colorIndex = float(START_COLOR_INDEX);
        if (CYCLE_COLOR_PER_BURST) {
            colorIndex += floor(seed);
        }
        if (DIFFERENT_COLOR_PER_PARTICLE) {
            colorIndex += id;
        }
        vec3 color = paletteColor(colorIndex);
        particleColor += color * alpha;
        coverage += alpha;
    }

    // Alpha blending preserves the palette instead of adding a white-hot glow.
    vec3 color = particleColor / max(coverage, 0.0001);
    fragColor.rgb = mix(fragColor.rgb, color, min(coverage, 1.0) * OPACITY * outsideCursor);
}
