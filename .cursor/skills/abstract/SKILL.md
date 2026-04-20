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
Short descriptions help readers and AI-powered search tools find the information that they need and confirm that they are in the right place.

Abstracts typically contain the following information:

- What the user must do
- Why the user must complete the action
- Where appropriate, an example use case

## Instructions

When reviewing or writing the abstract, follow these principles:

- Ensure the abstract explains the What and the Why as defined in the section "Definition of an abstract".
  - For the `What` part, state the action or feature clearly.
  - For the `Why` part, state the business value, benefit, or goal.
  - For the `Example use case part`, consider including in what situations a user might find the contents of the module useful.
  - Do not simply repeat the heading of the module; build upon it.
- Follow these user-centric language guidelines:
  - Avoid documentation self-referential language (for example: avoid "This procedure..." or "This module").
  - Avoid feature-centric language (for example: avoid "This feature...").
  - Use user-centric language (for example: use phrases such as "You can [action] to [benefit]", "To [goal], configure [feature]", "[Action] [what] to [why]").
- Follow these length constraints: 50-300 characters, 1-2 sentences, a single paragraph.

## Examples of good abstracts

| Title | Preferred Short Description |
| :--- | :--- |
| Creating a group and adding a system | Group many systems together in the Edge Management application to manage them more easily. For example, you can more easily mitigate vulnerabilities and update systems that are alike. |
| Browsing hosts in {ProjectWebUI} | Find and categorize your hosts within {Project} to get a quick overview of your managed infrastructure. Browsing hosts helps you understand your environment and identify specific host types for targeted actions. |
| Cloning hosts | Clone existing hosts in {Project} to quickly create new hosts with similar configurations. This streamlines deployment processes and improves consistency across your environment. |
| Editing system purpose | Edit the system purpose attributes for your Red Hat Enterprise Linux hosts to help ensure they receive correct subscriptions and accurate reporting. This optimizes license compliance and management. |
