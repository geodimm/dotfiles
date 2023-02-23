MAGNIFYING_GLASS_ICON="\uf848"

from kittens.tui.handler import result_handler


def toggle_tab_title_icon(tab, icon):
    if icon:
        tab.set_title(f"{tab.title} {icon}")
    else:
        tab.set_title(tab.title.strip(icon))


def main(args):
      pass


@result_handler(no_ui=True)
def handle_result(args, answer, target_window_id, boss):
  tab = boss.active_tab
  if tab is not None:
     off = len(args) > 1 and args[1] == 'off'
     if tab.current_layout.name == 'stack':
        tab.last_used_layout()
        toggle_tab_title_icon(tab, None)
     elif not off:
        tab.goto_layout('stack')
        toggle_tab_title_icon(tab, MAGNIFYING_GLASS_ICON)
