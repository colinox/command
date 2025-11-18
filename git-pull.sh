#!/bin/bash

# 输入参数为要切换到的分支的名称，如：sh pull_branch.sh release
branchName=$1

# 拉取远程仓库最新变化
git fetch

# 检查是否有未暂存的更改
if ! git diff --quiet; then
    echo "当前有未暂存的更改，自动暂存并提交。"
    git add .
    git commit -m "自动提交未暂存的更改"
fi

# 检查本地是否存在指定分支
if ! git rev-parse --verify $branchName >/dev/null 2>&1; then
    # 如果不存在，则从远程创建分支并切换到该分支
    echo "本地分支不存在，创建并切换到 $branchName"
    git checkout -b $branchName origin/$branchName || { echo "创建分支失败"; exit 1; }
else
    # 如果存在，则切换到该分支
    echo "切换到分支 $branchName"
    git checkout $branchName || { echo "切换分支失败"; exit 1; }
fi

# 拉取远程分支并自动合并
echo "开始拉取远程更新并自动合并..."
git pull origin $branchName --no-edit || { echo "拉取更新失败"; exit 1; }

# 检查是否发生了合并冲突
if [ -f .git/MERGE_HEAD ]; then
    echo "发生了合并冲突，请手动解决冲突并完成合并。"
    exit 1
fi

# 如果没有冲突，自动推送到远程仓库
git push origin $branchName || { echo "推送失败"; exit 1; }
echo "更新已成功合并并推送到远程仓库。"
