---
allowed-tools: Bash(git:*), Bash(gh:*)
description: Create a GitHub pull request using gh CLI
---

## Context

- Current branch: !`git branch --show-current`
- Default branch: !`git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@'`
- Git status: !`git status --porcelain`
- Uncommitted changes: !`git diff --stat`
- Commits ahead of default branch: !`git log --oneline $(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')..HEAD`
- Changes summary: !`git diff $(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')...HEAD --stat`

## Your task

Create a GitHub pull request from the current branch following these steps:

1. Ensure all changes are committed (if there are uncommitted changes, inform the user and stop)
2. Push the current branch to origin if needed
3. Analyze the commits and changes to create a meaningful PR title and description
4. Create the pull request using `gh pr create` with:
   - A concise, descriptive title
   - A body that includes:
     - Summary of changes (2-3 bullet points)
     - Test plan or checklist if applicable
     - Footer with: 🤖 Generated with [Claude Code](https://claude.ai/code)
5. Return the PR URL to the user

IMPORTANT:
- Always use HEREDOC for the PR body to ensure proper formatting
- Never use interactive mode (no -i flag)
- If already on the default branch, inform the user they need to create a feature branch first
- If the branch has no commits ahead of the default branch, inform the user there's nothing to create a PR for
- Check if a PR already exists for the current branch before creating a new one