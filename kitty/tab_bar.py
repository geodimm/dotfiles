import os
from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, TabAccessor
from kitty.utils import color_as_int


MAGNIFYING_GLASS_ICON = '󰍉'
LEFT_SEP, RIGHT_SEP = ('', '')

HOME = os.path.expanduser('~')


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData
) -> int:
    orig_fg = screen.cursor.fg
    orig_bg = screen.cursor.bg

    def draw_sep(which: str) -> None:
        screen.cursor.bg = as_rgb(color_as_int(draw_data.default_bg))
        screen.cursor.fg = orig_bg
        screen.draw(which)
        screen.cursor.bg = orig_bg
        screen.cursor.fg = orig_fg

    if max_title_length <= 1:
        screen.draw('…')
    elif max_title_length == 2:
        screen.draw('…|')
    elif max_title_length < 6:
        draw_sep(LEFT_SEP)
        screen.draw((' ' if max_title_length == 5 else '') + '…' + (' ' if max_title_length >= 4 else ''))
        draw_sep(RIGHT_SEP)
    else:
        draw_sep(LEFT_SEP)
        screen.draw(' ')
        # draw_title(draw_data, screen, tab, index)
        ta = TabAccessor(tab.tab_id)
        screen.draw(os.path.basename(ta.active_wd))
        if tab.layout_name == 'stack':
            screen.draw(' ' + MAGNIFYING_GLASS_ICON)

        extra = screen.cursor.x - before - max_title_length
        if extra >= 0:
            screen.cursor.x -= extra + 3
            screen.draw('…')
        elif extra == -1:
            screen.cursor.x -= 2
            screen.draw('…')
        screen.draw(' ')
        draw_sep(RIGHT_SEP)
        draw_sep(' ')

    return screen.cursor.x


def as_rgb(x: int) -> int:
    return (x << 8) | 2
