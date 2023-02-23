from kittens.tui.handler import result_handler


MAGNIFYING_GLASS_ICON="\uf848"


def toggle_tab_title_icon(tab, icon):
    window = tab.active_window
    if icon in window.title:
        window.set_title(window.title.strip(icon))
    else:
        window.set_title(f"{window.title} {icon}")


def main(args):
      pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
    tab = boss.active_tab
    if not tab:
        return

    if tab.current_layout.name == 'stack':
        tab.last_used_layout()
    else:
        tab.goto_layout('stack')

    toggle_tab_title_icon(tab, MAGNIFYING_GLASS_ICON)
