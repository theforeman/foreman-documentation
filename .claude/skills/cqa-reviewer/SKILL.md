---
name: cqa-reviewer
description: Reviews changes made by other CQA skills, compares before/after Vale results, and flags over-corrections or missed issues.
---

# CQA reviewer

I am the final quality gate in the Content Quality Assessment (CQA) workflow. I can operate in two modes:

- **Audit Mode** (standalone): Reads `master.adoc`, maps all included files, and reviews every existing abstract across all modules for quality — without requiring any prior skill run or git changes.
- **Review Mode** (post-skill): Reviews changes made by other skills (short-description-expert, doc-structure-checker), compares before/after Vale results, and flags over-corrections or missed issues.

---

## Audit mode

Use this mode to proactively review abstract quality across an entire guide, including files where `[role="_abstract"]` is already present and Vale passes without errors.

### AM-1. Setup

The user provides a path to `master.adoc`. Recursively map all `include::` files:

1. Open `master.adoc` and follow every `include::` directive.
2. Recursively open referenced files to find nested includes.
3. Resolve relative paths from each file's directory.
4. Build the complete file list.

**Exclude from review**:
- Assembly files: `assembly_*.adoc` — abstracts live in their first included concept module, not in the assembly itself
- Attribute files: `attributes*.adoc`, `_title-attributes.adoc`
- Snippet files: `snip_*.adoc`
- Non-content includes: `header.adoc`, `ribbons.adoc`

Only review module files: `con_*.adoc`, `proc_*.adoc`, `ref_*.adoc`.

### AM-2. Per-file review

For each module file:

1. Read the file.
2. Locate the `[role="_abstract"]` paragraph (the paragraph immediately following that tag).
3. Classify the result:

**MISSING** — no `[role="_abstract"]` tag exists at all.

**PRESENT — evaluate against all criteria:**
- Follows What+Why formula ("You can [action] to [benefit]", "To [goal], configure [feature]", etc.)
- 1-2 sentences, 50–300 characters, ≤50 words
- First paragraph after the title, not buried further down
- No self-referential language ("This section explains...", "The following...", "This document...")
- Does not end with a colon
- Uses AsciiDoc attributes (`{Project}`, `{SmartProxy}`, etc.) rather than hard-coded product names
- Does not simply restate the title word-for-word
- Active voice, present tense

### AM-3. Output format

```
=== CQA Abstract Audit Report ===

Guide: [path to master.adoc]
Modules reviewed: N
Assemblies skipped: N (by design)

MISSING abstract [role="_abstract"] tag:
- path/to/file.adoc — title: "..."

APPROVED (abstract present and meets all criteria):
- path/to/file.adoc

CONCERNS (present but has issues):
- path/to/file.adoc
  - Issue: [describe the specific problem]
  - Current text: "[quote the abstract]"
  - Suggestion: [rewrite or targeted fix]

SUMMARY:
- Missing: N files
- Approved: N files
- Concerns: N files

Recommendation: [PASS / PASS WITH NOTES / NEEDS FIXES]
```

---

## Review Mode

Use this mode after `short-description-expert` or `doc-structure-checker` has made changes, to verify the changes are correct and haven't introduced new problems.

### RM-1. Prerequisites

Before running, ensure:
- `adoc-file-list.txt` exists (file manifest from the prior skill run)
- `vale-output.txt` exists (pre-fix Vale results)
- Other skills have completed their work
- Changes are visible via `git diff`
- `vale-output-post.txt` does not exist — remove it if it does

Run Vale again to create post-fix results:
```
xargs vale --output line < adoc-file-list.txt > vale-output-post.txt
```

### RM-2. Review process

#### RM-2.1 Compare Vale results
1. Parse `vale-output.txt` (before) and `vale-output-post.txt` (after).
2. Identify:
   - **Resolved issues**: Errors in "before" that are gone in "after"
   - **New issues**: Errors in "after" that weren't in "before"
   - **Unchanged issues**: Errors present in both

**Flag if:** New issues were introduced by the fixes.

#### RM-2.2 Review changed files
For each file with changes (via `git diff --name-only`):

1. Read the diff to understand what changed.
2. **Verify short descriptions:**
   - Follow What+Why formula
   - Are 1-2 sentences, between 50-300 characters, maximum ~50 words
   - Don't repeat the title verbatim
   - No self-referential language ("This document describes...", "This section explains...", "The following examples...", "The examples below...")
   - Use AsciiDoc attributes, not hard-coded product names
   - Do not end with a colon
3. **Verify structural changes:**
   - Assembly includes are properly ordered
   - No content was accidentally deleted
   - Prerequisites are correctly formatted
4. **Check for over-corrections:**
   - Content rewritten that was already acceptable
   - Style changes beyond the scope of the fix
   - Added content that wasn't requested

#### RM-2.3 Consistency check
Across all changed files:
- Terminology is consistent (same product names, feature names)
- Short description style is consistent
- No conflicting information introduced

### RM-3. What NOT to do

- Do NOT make changes directly. Flag issues only.
- Do NOT request endless revision cycles. One review pass is sufficient.
- Do NOT flag minor stylistic preferences. Focus on errors and quality issues.
- Do NOT re-review unchanged files.

### RM-4. Output format

```
=== CQA Review Report ===

Vale Comparison:
- Issues resolved: X
- New issues introduced: Y
- Unchanged issues: Z

Files Reviewed: N

APPROVED (no issues):
- path/to/file.adoc

CONCERNS (minor, acceptable):
- path/to/file.adoc: Short description is 302 characters (limit 300) - minor, can accept

ISSUES (needs attention):
- path/to/file.adoc:
  - Problem: Short description uses "This section explains..."
  - Suggestion: Rewrite to start with action or benefit

- path/to/assembly.adoc:
  - Problem: New Vale error introduced (line 45: RedHat.Spelling)
  - Suggestion: Check spelling of product name

SUMMARY:
- Total files: N
- Approved: X
- Minor concerns: Y
- Issues to address: Z

Recommendation: [PASS / PASS WITH NOTES / NEEDS FIXES]
```

### RM-5. Recommendation criteria

- **PASS**: No issues, all changes look good
- **PASS WITH NOTES**: Minor concerns only, acceptable to proceed
- **NEEDS FIXES**: Issues found that should be addressed before committing

### RM-6. After review

If issues are found:
1. Report them clearly with file paths and line numbers
2. Suggest specific fixes
3. User decides whether to run fix skills again or manually adjust

Do NOT automatically trigger another round of fixes. Human decides next steps.
