#!/bin/bash

# 检查是否输入了分支名称
if [ -z "$1" ]; then
    echo "请输入分支名称！"
    exit 1
fi

branchName=$1

# 检查本地是否存在指定分支
if git rev-parse --verify "$branchName" >/dev/null 2>&1; then
    # 本地分支已存在，切换并推送
    git checkout "$branchName" || { echo "切换分支失败"; exit 1; }
    # 判断是否有更改需要推送
    if ! git diff --quiet; then
        git push origin "$branchName"
        echo "更改已推送到远程 $branchName"
    else
        echo "没有需要推送的更改。"
    fi
else
    # 本地分支不存在，检查远程分支
    if git ls-remote --exit-code --heads origin "$branchName" >/dev/null; then
        # 远程分支存在，从远程创建并切换到该分支
        git checkout -b "$branchName" origin/"$branchName" || { echo "切换分支失败"; exit 1; }
        echo "已从远程仓库创建并切换到新分支 $branchName"
    else
        # 远程分支不存在，创建新分支并推送到远程
        git checkout -b "$branchName" || { echo "创建分支失败"; exit 1; }
        git push --set-upstream origin "$branchName"
        echo "已创建并推送新分支 $branchName 到远程仓库"
    fi
fi
