#!/bin/bash

# 获取当前分支的名称
current_branch=$(git rev-parse --abbrev-ref HEAD)

# 获取远程分支的名称
remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null)

# 判断当前分支和远程分支是否相同
if [ $? -eq 0 ]; then
    if [ "$current_branch" != "${remote_branch#refs/remotes/}" ]; then
        # 拉取远程分支的更新
        if ! git pull; then
            echo "拉取时发生冲突，请解决冲突后继续"
            exit 1
        fi
    fi
else
    echo "当前分支没有设置远程追踪分支，跳过拉取操作。"
fi

# 查看修改文件并确认
git status
echo "确认要提交这些修改吗？(y/n)"
read confirm
if [ "$confirm" != "y" ]; then
    echo "操作取消"
    exit 1
fi

# 添加所有修改的文件
git add .

# 提交修改
if [ -z "$1" ]; then
    echo "请输入本次提交的说明："
    read commit_msg
else
    commit_msg="$1"
fi

if [ -z "$commit_msg" ]; then
    echo "提交信息不能为空！"
    exit 1
fi

git commit -m "$commit_msg"

# 推送修改前检查差异
git fetch
if ! git diff --quiet "$current_branch" "$remote_branch"; then
    echo "本地分支与远程分支有差异，建议先拉取更新。"
    exit 1
fi

# 将修改推送到远程分支
git push