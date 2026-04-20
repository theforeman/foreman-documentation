---
name: abstract
description: Review or write abstract
---
# Review or write abstract

## Overview

Review and improve the abstract for this file. Write it if it doesn't exist yet.

## Definition of an abstract

An abstract is the first paragraph of the module.
It follows after the module heading.
It is pre-fixed by the `[role="_abstract"]` AsciiDoc tag.
Every abstract must follow this user-centric pattern:

- What: State the action or feature clearly.
- Why: State the business value, benefit, or goal.
- Example patterns of user-centric language:
  - "You can [action] to [benefit]"
  - "To [goal], configure [feature]"
  - "[Action] [what] to [why]"

## Instructions

When reviewing or writing the abstract, follow these principles:

* Ensure the abstract explains the What and the Why as defined in the section "Definition of an abstract".
* Follow these length constraints: 50-300 characters, 1-2 sentences, a single paragraph.
* Avoid documentation self-referential language (for example: avoid "This procedure..." or "This module").
* Avoid feature-centric language (for example: avoid "This feature...")
* Where appropriate, include an example use case (for example: the reason why and when a user might find the contents of the module useful).
* Do not simply repeat the heading of the module; build upon it.

## Examples of good abstracts

| Title | Preferred Short Description |
| :--- | :--- |
| Creating a group and adding a system | Group many systems together in the Edge Management application to manage them more easily. For example, you can more easily mitigate vulnerabilities and update systems that are alike. |
| Browsing hosts in {ProjectWebUI} | Find and categorize your hosts within {Project} to get a quick overview of your managed infrastructure. Browsing hosts helps you understand your environment and identify specific host types for targeted actions. |
| Cloning hosts | Clone existing hosts in {Project} to quickly create new hosts with similar configurations. This streamlines deployment processes and improves consistency across your environment. |
| Editing system purpose | Edit the system purpose attributes for your Red Hat Enterprise Linux hosts to help ensure they receive correct subscriptions and accurate reporting. This optimizes license compliance and management. |
