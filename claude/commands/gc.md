---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*), Bash(git log:*), Bash(git branch:*)
description: Create a git commit with automated message generation
---

## Context

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

## Your task

Based on the above changes, create a single git commit following these steps:

1. Analyze all staged and unstaged changes
2. Draft a commit message that:
   - Summarizes the nature of changes (new feature, enhancement, bug fix, refactoring, test, docs, etc.)
   - Is concise (1-2 sentences) and focuses on "why" rather than "what"
   - Follows the repository's commit message style based on recent commits
3. Add relevant untracked files to staging if needed
4. Create the commit with the message ending with:
   
   🤖 Generated with [Claude Code](https://claude.ai/code)
   
   Co-Authored-By: Claude <noreply@anthropic.com>

5. Run git status after to confirm the commit succeeded
6. If the commit fails due to pre-commit hooks, retry ONCE to include automated changes

IMPORTANT: 
- Use a HEREDOC for the commit message to ensure proper formatting
- Never use interactive git commands (no -i flag)
- Check for sensitive information before committing
- If there are no changes to commit, inform the user instead of creating an empty commit