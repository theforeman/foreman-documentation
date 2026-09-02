---
name: cherry-pick
description: Cherry-pick a merged PR commit to the version branches indicated in the PR description checklist. Use when the user provides a PR number or URL and wants to backport it.
---

#### Overview

Foreman documentation uses version branches (e.g. `3.15`, `3.16`, `3.17`) on the `upstream` remote. When a PR is merged to a version branch, its commit often needs to be cherry-picked to other version branches as indicated by checked boxes (`[x]`) in the PR description. Sometimes the target branches are specified in PR comments instead.

The cherry-pick workflow:
1. Identify the merge commit and target branches from the PR
2. Cherry-pick with `-x` onto each target branch (oldest first)
3. Resolve any conflicts
4. Leave the branches ready for the user to push, or offer review options if conflicts were substantial

#### Instructions

**Step 1: Gather PR information**
- Use `gh pr view <number> --json title,body,baseRefName,mergeCommit,comments` to get the PR details and comments.
- Parse the PR body for the cherry-pick checklist. Lines matching `* [x]` with a version like `Foreman X.Y` indicate target branches. Lines with `* [ ]` (unchecked) should be skipped.
- Also check PR comments — sometimes target branches are specified there instead of (or in addition to) the checklist, especially for irregular cherry-picks outside the normal range.
- The base branch (where the PR was merged) is NOT a cherry-pick target.
- Extract the merge commit SHA from the PR metadata, or use the SHA the user provides.

**Step 2: Fetch and prepare**
- Run `git fetch upstream` to ensure all version branches are up to date.
- Also fetch the specific target branches: `git fetch upstream <branch1> <branch2> ...`
- Verify the merge commit exists with `git log --oneline <sha> -1`.
- Check which target branches already have the commit: `git log --oneline upstream/<version> | grep "#<PR>"`. Skip branches that already have it.

**Step 3: Cherry-pick to each target branch**

Process branches from oldest to newest (e.g. 3.12 before 3.13). For each target branch:

1. Check out the local branch: `git checkout <version> 2>/dev/null || git checkout -b <version> upstream/<version>`
2. **Always pull the latest** after switching: `git pull --ff-only upstream <version>`
3. **Verify you are on the correct branch** before cherry-picking: `git branch --show-current`
4. Run `git cherry-pick -x <commit-sha>`.
5. If the cherry-pick succeeds cleanly, move to the next branch.

When cherry-picking across multiple versions, use the commit SHA from the closest ancestor branch (e.g. use the 3.13 cherry-picked SHA when cherry-picking to 3.12, not the original from 3.15).

**Step 4: Resolve conflicts**

When conflicts occur, handle them by type:

- **modify/delete conflicts** (file deleted on the target branch but modified by the cherry-pick): Check `git log upstream/<version> -- <file>` to confirm the file never existed or was removed on this branch. If so, `git rm <file>`.

- **rename/delete conflicts** (file renamed by the cherry-pick but the original doesn't exist on the target branch): Check if the content exists in a different form on the target branch (e.g. an aggregated module instead of split individual files). If so, `git rm` the new file and apply the semantic change to the existing aggregated file instead.

- **Content conflicts**: Read the conflicted file and understand what each side contributes:
  - The HEAD side has the target branch's current state.
  - The incoming side has the PR's changes.
  - Keep the target branch's structure/context (e.g. if grub1 was not yet removed on an older branch, keep it) and apply only the semantic change from the PR (e.g. renaming "Puppet server" to "OpenVox server").
  - When uncertain about structural differences (e.g. whether a feature was backported), check the git log for that file on the target branch, and check release notes in `guides/doc-Release_Notes/topics/` for context.

- After resolving all conflicts, verify no conflict markers remain: `grep -rn "<<<<<<< \|>>>>>>>" <files>`
- Stage resolved files with `git add` and continue: `git cherry-pick --continue --no-edit`

**Step 5: Report status and review options**

After all cherry-picks are complete, show:
- `git branch -vv | grep -E '<version branches>'` to confirm each branch is ahead by the expected count.
- List any conflicts that were resolved and the decisions made.

If cherry-picks were clean (no conflicts), remind the user to push: `git push upstream <branch>` (never push yourself).

If conflicts required substantial resolution, offer review options before pushing:
1. **Patch files**: `git format-patch upstream/<version>..<version> --stdout > ~/Documents/foreman-cherry-picks-<version>.patch`
2. **Fork branches for review**: Push to fork under a descriptive branch name and share GitHub compare links:
   - `git push jafiala <version>:cherry-pick-<description>-<version>`
   - Share: `https://github.com/theforeman/foreman-documentation/compare/<version>...jafiala:foreman-documentation:cherry-pick-<description>-<version>`

#### Conflict resolution principles

1. The PR's *semantic change* (the rename, the new content, the fix) should be applied.
2. The target branch's *structural context* (files that exist, features present, formatting conventions) should be preserved.
3. When the PR added content that doesn't exist on the target branch (e.g. a prerequisite line, a `[role="_abstract"]` tag), check whether it existed before the PR on the source branch. If it was added by the PR, include it. If it existed independently on the source branch but not on the target, omit it.
4. When the PR removed content that still exists on the target branch for valid reasons (e.g. grub1 removal was reverted on older branches), keep the target branch's version.
5. For wording changes unrelated to the PR's purpose (e.g. "a number of" changed to "several"), keep the target branch's original wording.
6. When the target branch uses a different file structure (e.g. one aggregated module instead of split individual files), apply the semantic change to the files that exist on the target branch rather than introducing the new structure. Remove any files created by the cherry-pick that belong to the newer structure.
7. When the target branch uses different formatting conventions (e.g. bare `@host.xxx` vs backtick-wrapped `` `@host.xxx` ``), keep the target branch's formatting.
8. When resolving xrefs, verify anchor IDs match the actual IDs in the files on the target branch — they may differ from the source branch.
