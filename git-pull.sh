#!/bin/bash

# 输入参数为要切换到的分支的名称，如：sh pull_branch.sh release
branchName=$1

# 拉取远程仓库最新变化
git fetch

# 检查本地是否存在指定分支
if ! git rev-parse --verify $branchName >/dev/null 2>&1; then
    # 如果不存在，则从远程创建分支并切换到该分支
    echo "本地分支不存在，创建并切换到 $branchName"
    git checkout -b $branchName origin/$branchName || { echo "创建分支失败"; exit 1; }
else
    # 如果存在，则切换到该分支并从远程更新分支
    echo "切换到分支 $branchName"
    git checkout $branchName || { echo "切换分支失败"; exit 1; }
    git pull origin $branchName || { echo "拉取更新失败"; exit 1; }
fi