#!/usr/bin/env python3
"""
校验 radical_lookup.dict.yaml 对康熙 214 部首的覆盖情况。

关键流程说明：
1) 读取 Rime 词库文件，跳过 YAML 头，仅解析词条区（... 之后）。
2) 提取每条词条的 text 字段，建立已覆盖字符集合。
3) 与内置的康熙 214 部首标准集做差集，输出缺失项与覆盖率。
"""

from pathlib import Path
import sys


KANGXI_214 = list(
    "一丨丶丿乙亅二亠人儿入八冂冖冫几凵刀力勹匕匚匸十卜卩厂厶又口囗土士夂夊夕大女子宀寸小尢尸屮山巛工己巾干幺广廴廾弋弓彐彡彳心戈戶手支攴文斗斤方无日曰月木欠止歹殳毋比毛氏气水火爪父爻爿片牙牛犬玄玉瓜瓦甘生用田疋疒癶白皮皿目矛矢石示禸禾穴立竹米糸缶网羊羽老而耒耳聿肉臣自至臼舌舛舟艮色艸虍虫血行衣襾見角言谷豆豕豸貝赤走足身車辛辰辵邑酉釆里金長門阜隶隹雨青非面革韋韭音頁風飛食首香馬骨高髟鬥鬯鬲鬼魚鳥鹵鹿麥麻黃黍黑黹黽鼎鼓鼠鼻齊齒龍龜龠"
)


def parse_text_entries(dict_path: Path) -> set[str]:
    lines = dict_path.read_text(encoding="utf-8").splitlines()
    in_body = False
    covered = set()

    for raw in lines:
        if raw.strip() == "...":
            in_body = True
            continue
        if not in_body:
            continue

        line = raw.strip()
        if not line or line.startswith("#"):
            continue

        parts = raw.split("\t")
        if len(parts) < 2:
            continue

        text = parts[0].strip()
        if text:
            covered.add(text)

    return covered


def main() -> int:
    # 支持命令行传参，默认检查当前目录下词库文件
    dict_path = (
        Path(sys.argv[1]).expanduser().resolve()
        if len(sys.argv) > 1
        else Path(__file__).resolve().parent / "radical_lookup.dict.yaml"
    )

    if not dict_path.exists():
        print(f"错误：文件不存在 -> {dict_path}")
        return 2

    covered = parse_text_entries(dict_path)
    missing = [r for r in KANGXI_214 if r not in covered]

    total = len(KANGXI_214)
    hit = total - len(missing)
    ratio = hit / total * 100

    print(f"词库文件: {dict_path}")
    print(f"康熙214覆盖: {hit}/{total} ({ratio:.2f}%)")

    if missing:
        print("缺失部首:")
        print(" ".join(missing))
        return 1

    print("结果: 已完整覆盖康熙 214 部首。")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
