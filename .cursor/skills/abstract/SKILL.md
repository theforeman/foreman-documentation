---
name: abstract
description: Review or write abstract
---
# Review or write abstract

## Overview

Review and improve the abstract for this file. Write it if it doesn't exist yet.

## Instructions

Every short description must follow this user-centric pattern:

- **What**: State the action or feature clearly.
- **Why**: State the business value, benefit, or goal.
- **Patterns**:
  - "You can [action] to [benefit]"
  - "To [goal], configure [feature]"
  - "[Action] [what] to [why]"

Follow these principles:

* Make the abstract 50-300 characters long.
* Do not use documentation self-referential language (for example: avoid "This procedure..." or "This module").
* Use user-centric language (for example: "You can...") rather than product-centric language (for example: "This feature...").
* Where appropriate, include an example use case (for example: the reason why and when a user might find the contents of the module useful).

Structural constraints:
- **Paragraphs**: Exactly one single paragraph.
- **Length**: 1-2 simple sentences; between 50-300 characters, maximum ~50 words.
- **Placement**: This must be the very first paragraph of the topic, immediately after the title.
- **No Admonitions**: Never place a Note, Warning, or Important box before the short description.
- **Doesn't end with a colon**: Must be a self-contained paragraph, not introduce a list.

Style and tone:
- **Voice**: Active voice, present tense. No "allows you to" or "This section covers...".
- **Product Names**: Use AsciiDoc attributes (`{Project}`, `{SmartProxy}`, etc.) — never hard-code product names.
- **No Repetition**: Do not simply repeat the title; build upon it.
- **No Self-Referential Language**: Avoid phrases like:
  - "This document describes..."
  - "This section explains..."
  - "The following examples..."
  - "The examples below..."
  - Any variation that references the document structure itself

## Examples of preferred rewrites

| Title | Preferred Short Description |
| :--- | :--- |
| Creating a group and adding a system | Group many systems together in the Edge Management application to manage them more easily. For example, you can more easily mitigate vulnerabilities and update systems that are alike. |
| Browsing hosts in Satellite Web UI | Find and categorize your hosts within {Project} to get a quick overview of your managed infrastructure. Browsing hosts helps you understand your environment and identify specific host types for targeted actions. |
| Cloning hosts | Clone existing hosts in {Project} to quickly create new hosts with similar configurations. This streamlines deployment processes and improves consistency across your environment. |
| Editing system purpose | Edit the system purpose attributes for your Red Hat Enterprise Linux hosts to help ensure they receive correct subscriptions and accurate reporting. This optimizes license compliance and management. |
