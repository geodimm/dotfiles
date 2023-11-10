import os
from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, TabAccessor
from kitty.utils import color_as_int


MAGNIFYING_GLASS_ICON = '󰍉'
LEFT_SEP, RIGHT_SEP = ('', '')


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
    active_wd = ''
    while active_wd == '':
        active_wd = os.path.basename(TabAccessor(tab.tab_id).active_wd)

    draw_separator(draw_data, screen, LEFT_SEP)
    screen.draw(' ')
    screen.draw(active_wd)
    if tab.layout_name == 'stack':
        screen.draw(' ')
        screen.draw(MAGNIFYING_GLASS_ICON)

    screen.draw(' ')
    draw_separator(draw_data, screen, RIGHT_SEP + ' ')
    return screen.cursor.x


def as_rgb(x: int) -> int:
    return (x << 8) | 2


def draw_separator(draw_data: DrawData, screen: Screen, separator: str) -> None:
    orig_bg = screen.cursor.bg
    orig_fg = screen.cursor.fg
    screen.cursor.bg = as_rgb(color_as_int(draw_data.default_bg))
    screen.cursor.fg = orig_bg
    screen.draw(separator)
    screen.cursor.bg = orig_bg
    screen.cursor.fg = orig_fg
