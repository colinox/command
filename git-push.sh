#!/bin/bash

# 用法: ./git-safe-commit.sh "提交说明"

MESSAGE=$1

if [ -z "$MESSAGE" ]; then
  echo "❌ 请输入提交信息："
  echo "   ./git-safe-commit.sh \"你的提交信息\""
  exit 1
fi

echo "🔍 检查本地是否有未提交的修改..."
# 检查是否有本地改动
if [[ -n $(git status --porcelain) ]]; then
  HAS_LOCAL_CHANGES=1
  echo "📦 检测到未提交的本地修改"
else
  HAS_LOCAL_CHANGES=0
  echo "✨ 无本地修改"
fi

echo "⬇️  获取远程最新提交信息..."
git fetch

LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse @{u})

if [ $? -ne 0 ]; then
  echo "❌ 当前分支没有追踪远程分支，请先: git push -u origin 分支名"
  exit 1
fi

echo "本地最新:   $LOCAL"
echo "远程最新:   $REMOTE"

# 检查是否远程有更新
if [ "$LOCAL" = "$REMOTE" ]; then
  echo "👍 远程没有更新，可以直接提交"
else
  echo "⚠️ 检测到远程有其他人的更新，需要先处理更新"

  # 如果本地有修改，先暂存
  if [ $HAS_LOCAL_CHANGES -eq 1 ]; then
    echo "📌 执行 git stash 保存本地修改..."
    git stash push -u -m "auto-stash-before-pull"
  fi

  echo "⬇️ 拉取远程最新代码..."
  git pull --rebase

  if [ $? -ne 0 ]; then
    echo "❌ 拉取远程代码失败，请手动解决后再试"
    exit 1
  fi

  # 取出 stash
  if git stash list | grep -q "auto-stash-before-pull"; then
    echo "📤 恢复本地修改 (git stash pop)..."
    git stash pop

    if [ $? -ne 0 ]; then
      echo "❌ 恢复本地修改时发生冲突，请手动解决冲突后再重新提交"
      exit 1
    fi
  fi
fi

echo "📁 添加改动..."
git add .

echo "📝 提交代码..."
git commit -m "$MESSAGE"

if [ $? -ne 0 ]; then
  echo "❌ 提交失败，请检查是否有需要提交的内容"
  exit 1
fi

echo "⬆️ 推送到远程..."
git push

if [ $? -eq 0 ]; then
  echo "✅ 提交并推送成功！"
else
  echo "❌ 推送失败，请检查网络或冲突"
fi
