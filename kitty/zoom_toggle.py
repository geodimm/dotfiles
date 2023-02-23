from kittens.tui.handler import result_handler


MAGNIFYING_GLASS_ICON="\uf848"


def toggle_tab_title_icon(tab, icon):
    title = tab.active_window.title
    if " " in title:
        title = title.split()[0]

    if icon:
        tab.active_window.set_title(f"{title} {icon}")
    else:
        tab.active_window.set_title(title.strip(icon))


def main(args):
      pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    tab = boss.active_tab
    if not tab:
        return

    if tab.current_layout.name == 'stack':
        tab.last_used_layout()
        toggle_tab_title_icon(tab, None)
    else:
        tab.goto_layout('stack')
        toggle_tab_title_icon(tab, MAGNIFYING_GLASS_ICON)
