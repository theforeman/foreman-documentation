---
name: review-assembly-user-story
description: Review assembly to ensure it follows the one-user-story principle
---
# Review assembly for single user story

## Overview

Review an assembly file to ensure it describes a single user story.
If the assembly contains multiple user stories, split it into separate assembly files.

Usage:

```
/review-assembly-user-story @assembly_example.adoc
```

## Reasoning

An assembly must cover a single user story (what the user wants to accomplish).
When an assembly attempts to describe multiple user stories, it often loses its focus, becomes too long, and can be confusing to follow.

## Instructions

Review the assembly file to determine if it follows the one-user-story principle.
Each assembly must describe a single user story.

### Step 1: Analyze the assembly

Read the assembly file and:

1. **Identify the primary user story** - What is the main goal or task the user wants to accomplish?
2. **Check the introductory concept module** (the first include in the assembly) - Does it describe a single focused topic?
3. **Review included modules** - Do they all support the same user story, or do they describe separate independent tasks?
4. **Look for clear boundaries** - Are there sections that could stand alone as separate user stories?

### Step 2: Determine if splitting is needed

The assembly needs splitting if:

- It contains procedures for multiple independent tasks that users might want to do separately
- The concept module describes multiple distinct use cases or workflows
- Different sections serve different user goals (e.g., "creating/deleting" vs "configuring" vs "monitoring")
- Modules could be logically grouped into 2 or more cohesive assemblies

Note: Inverse operations (creating/deleting, enabling/disabling) belong together in the same assembly.

The assembly is fine if:

- All procedures work toward a single user goal
- Procedures are sequential steps or alternative approaches for the same task
- Modules provide context, reference, or examples for one user story

### Step 3: If splitting is needed

For each identified user story:

1. **Create a new assembly file** - Name it `assembly_<descriptive-name>.adoc`
2. **Add the assembly header** - Include `:_mod-docs-content-type: ASSEMBLY`
3. **Include relevant modules** - Copy the appropriate module includes for this user story
4. **Create or update the introductory concept module** - Write a focused concept module with an abstract for this specific user story if needed
5. **Update parent files** - Replace the original assembly include with includes for all new assemblies
6. **Delete the original assembly** - Once all content is split and includes are updated

### Step 4: Report findings

Provide a summary that includes:

- Whether the assembly follows the one-user-story principle
- If splitting occurred, list the new assembly files created and their user stories
- Any recommendations for improving the assembly structure

## Principles

- **One user story per assembly** - Each assembly should answer "What does the user want to accomplish?"
- **User-centric organization** - Think from the user's perspective, not the product's features
- **Cohesive modules** - All modules in an assembly should support the same goal

## Examples

### Good examples (single user story):
- `assembly_backing-up-server-and-proxy.adoc` - User wants to back up their system
- `assembly_configuring-email-notifications.adoc` - User wants to set up email notifications

### Important considerations:
- **Inverse operations belong together** - Creating and deleting (e.g., organizations), or enabling and disabling (e.g., external authentication) are part of the same user story, as users may want to revert their actions
- **Alternative methods belong together** - Multiple procedures for the same task (web UI, CLI, API) belong in the same assembly
- **Sequential workflows belong together** - If steps must be done in order for one goal, they belong in the same assembly
