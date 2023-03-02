import tempfile
import os

from shutil import which
from typing import List
from kitty.boss import Boss


ENABLED_LAYOUTS = [
    'fat',
    'grid',
    'horizontal',
    'splits',
    'stack',
    'tall',
    'vertical',
]


def fzf(choices: List[str], delimiter='\n'):
    exe = which("fzf")
    if not exe:
        raise SystemError(f"Cannot find 'fzf' installed on $PATH.")

    shell = which("zsh") or os.environ.get("SHELL")
    if not shell:
        raise SystemError(f"Cannot find a $SHELL to use.")

    selection = []
    with tempfile.NamedTemporaryFile(delete=True) as input_file:
        with tempfile.NamedTemporaryFile(delete=True) as output_file:
            input_file.write(delimiter.join(map(str, choices)).encode('utf-8'))
            input_file.flush()
            os.system(f"{shell} -c '{exe} --reverse < \"{input_file.name}\" > \"{output_file.name}\"'")
            for line in output_file:
                selection.append(line.strip().decode("utf-8"))

    return selection


def main(args: List[str]) -> str:
    fzf_path = os.path.join(os.environ["HOME"], ".fzf/bin")
    os.environ["PATH"] += f":{fzf_path}"

    result = fzf(ENABLED_LAYOUTS)
    if len(result) > 0:
        return result[0]

    return ""


def handle_result(args: List[str], answer: str, target_window_id: int, boss: Boss) -> None:
    try:
        window = boss.window_id_map.get(target_window_id)
        tab = boss.tab_for_window(window)
        tab.goto_layout(answer)

    except Exception:
        pass
