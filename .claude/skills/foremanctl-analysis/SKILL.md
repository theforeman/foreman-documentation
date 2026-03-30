---
name: foremanctl-doc-impact
description: Manual skill that provides methodology for analyzing which documentation is affected by the foremanctl deployment utility that will replace foreman-installer and foreman-maintain.
disable-model-invocation: true
---

# Analysis of *foremanctl* documentation impact

This skill guides research to identify which documentation pieces are affected by the *foremanctl* deployment utility, which will replace *foreman-installer* and *foreman-maintain*.

## Background

**The change:**
- `foremanctl` is a new deployment utility
- Replaces existing `foreman-installer` and `foreman-maintain` utilities.

**Components to evaluate for *foremanctl* impact:**
- Alternate content sources
- Capsule - Content
- Container image management
- Content credentials
- Content views
- Errata management
- Image mode
- Inter Satellite Sync (ISS)
- Lifecycle environments
- Pulp
- Repositories
- Sync plans

## Research methodology

### Step 1: Identify documentation that covers the above-listed components

Search across the `guides/` directory for each component listed in the Background section.

For each component search:
1. Use Grep to find files mentioning the component
2. Note the guide name and file path
3. Track findings as a list of files per component for use in Steps 2 and 3

Search tips:
- Use component keywords that catch variations (e.g., "repositor" catches repository/repositories)
- Check procedure files (proc_*.adoc), concept files (con_*.adoc), reference files (ref_*.adoc), and snippets (snip_*.adoc)

### Step 2: Identify and process direct references to *foreman-installer* and *foreman-maintain*

#### Step 2a: Filter the list of files related to the component to find files that directly reference *foreman-installer* and *foreman-maintain*

Search the component-related files (from Step 1) for any mentions of:
- `foreman-installer`
- `foreman-maintain`

Use Grep with `output_mode: "content"` to see context around matches.

#### Step 2b: Extract user stories for context

For each affected file identified in Step 2a:
1. Identify which assembly file includes this module (search for the filename in assembly_*.adoc files)
2. Extract the user story from that assembly (typically near the top, before module includes)
3. Note the user story for inclusion in the report

#### Step 2c: For each identified file, summarize the expected documentation impact of *foremanctl*

### Step 3: Identify and process documentation that does not directly reference *foreman-installer* and *foreman-maintain* but are likely impacted as well through indirect workflow dependency

#### Step 3a: Filter the list of files related to the component for any additional potential impact of *foremanctl*. This means files that do not directly reference *foreman-installer* or *foreman-maintain* but document workflows or use cases that could also be affected by the *foremanctl* transition.

#### Step 3b: Extract user stories for context

For each affected file identified in Step 3a:
1. Identify which assembly file includes this module (search for the filename in assembly_*.adoc files)
2. Extract the user story from that assembly (typically near the top, before module includes)
3. Note the user story for inclusion in the report

#### Step 3c: For each identified file, summarize the expected documentation impact of *foremanctl*

## Output format

Present findings as:

### Summary
- Total number of affected files
- List of affected guides

### Affected files

For each affected file, provide:

**File**: path/to/file.adoc
**Guide**: [Guide name]
**Component**: [The component this relates to]
**User story**: [the user story from the parent assembly that includes this module]
**Tool reference**: foreman-installer | foreman-maintain | both | indirect (workflow dependency, no direct tool mention)
**Scope**: Minor (command change) | Moderate (procedure rewrite) | Major (workflow redesign)
**Expected impact**: [how the documented workflow will change]
**Questions**: [what's unclear about how foremanctl changes this]

---

**Note**: Only list files that ARE affected (those that mention foreman-installer or foreman-maintain). Do not list files that are not affected.
