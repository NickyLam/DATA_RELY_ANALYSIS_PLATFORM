#!/usr/bin/env python3
"""
静态资源版本号更新工具
自动计算 JS/CSS 文件的 MD5 hash，更新 index.html 中的 ?v= 版本号

用法: python3 scripts/update_static_versions.py
"""
import hashlib
import os
import re
import sys

# 项目根目录
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
STATIC_DIR = os.path.join(PROJECT_ROOT, 'static')
INDEX_HTML = os.path.join(STATIC_DIR, 'index.html')

# 需要版本化的文件列表
VERSIONED_FILES = [
    'css/style.css',
    'js/app.js',
    'js/parse-tab.js',
    'js/caliber-tab.js',
    'js/detail-panel.js',
    'js/search-panel.js',
    'js/lineage-graph.js',
    'js/indicator-tab.js',
]


def compute_hash(filepath):
    """计算文件的 MD5 前8位作为版本号"""
    with open(filepath, 'rb') as f:
        return hashlib.md5(f.read()).hexdigest()[:8]


def update_versions():
    """更新 index.html 中所有版本化文件的 ?v= 参数"""
    if not os.path.exists(INDEX_HTML):
        print(f"错误: 找不到 {INDEX_HTML}")
        sys.exit(1)

    with open(INDEX_HTML, 'r', encoding='utf-8') as f:
        content = f.read()

    updated = 0
    for rel_path in VERSIONED_FILES:
        filepath = os.path.join(STATIC_DIR, rel_path)
        if not os.path.exists(filepath):
            print(f"  跳过: {rel_path} (文件不存在)")
            continue

        new_hash = compute_hash(filepath)
        # 匹配 ?v=旧版本号 的模式
        pattern = rf'({re.escape(rel_path)}\?v=)[a-f0-9]{{8}}'
        match = re.search(pattern, content)
        if match:
            old_version = match.group(0).split('=')[1]
            if old_version != new_hash:
                content = re.sub(pattern, rf'\g<1>{new_hash}', content)
                print(f"  更新: {rel_path}  {old_version} → {new_hash}")
                updated += 1
            else:
                print(f"  无变化: {rel_path}  {new_hash}")
        else:
            print(f"  警告: {rel_path} 在 index.html 中未找到 ?v= 版本号")

    if updated > 0:
        with open(INDEX_HTML, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"\n共更新 {updated} 个文件版本号")
    else:
        print("\n所有版本号均为最新，无需更新")


if __name__ == '__main__':
    print("更新静态资源版本号...")
    update_versions()
