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
It is prefixed by the `[role="_abstract"]` AsciiDoc tag.

Abstracts, also called short descriptions, help readers and AI-powered search tools find the information that they need and confirm that they are in the right place.

Abstracts typically contain the following information:

- The "What"
- The "Why"
- Where appropriate, an example use case

## Instructions

When reviewing or writing the abstract, follow these principles:

- Ensure the abstract explains the What and the Why as defined in the section "Definition of an abstract".
  - For the `What` part, state the action or definition clearly.
  - For the `Why` part, state the business value, benefit, or goal.
  - For the `Example use case part`, consider including in what situations a user might find the contents of the module useful.
  - Do not simply repeat the heading of the module; build upon it.
- Follow these user-centric language guidelines:
  - Avoid self-referential language (for example: avoid "This procedure..." or "This module...").
  - Avoid feature-centric language (for example: avoid "This feature...").
  - Use user-centric language (for example: use phrases such as "You can [action] to [benefit]", "To [goal], configure [feature]", "[Action] [what] to [why]").
- Follow these length constraints: 50-300 characters, 1-2 sentences, a single paragraph.
- Do not remove useful information. If needed, just move it to the next paragraph instead of replacing it.

### Instructions for concept modules

- Introduce the concept and provide a concise answer to the question "What is this?" and in some cases "Why do I care about this?" 
- If the concept is unfamiliar, you can start with a brief definition.
- Avoid using the short description to lead in or build up to a topic.
- The short description paragraph should contain the main point of the concept topic.

### Instructions for procedure modules

- The short description should explain the task that users can accomplish, the benefits of the task, and the purpose of the task. Do not simply repeat the title. Try to include information that will help users understand when the task is appropriate or why the task is necessary. Avoid stating the obvious, such as "You can use XYZ to do A" as the only statement in the short description for the task. In some cases, add more information about why the task is beneficial.

### Instructions for reference modules

- Briefly describe what the reference item does, what it is, or what it is used for.


## Examples of good abstracts

| Heading | Example abstract (procedure) |
| :--- | :--- |
| Browsing hosts in {ProjectWebUI} | Find and categorize your hosts within {Project} to get a quick overview of your managed infrastructure. Browsing hosts helps you understand your environment and identify specific host types for targeted actions. |
| Cloning hosts in {Project} | Clone existing hosts in {Project} to quickly create new hosts with similar configurations. This streamlines deployment processes and improves consistency across your environment. |
| Editing system purpose | Edit the system purpose attributes for your Red Hat Enterprise Linux hosts to help ensure they receive correct subscriptions and accurate reporting. This optimizes license compliance and management. |

| Heading | Example abstract (concept) |
| :--- | :--- |
| Security considerations in {Project} | {Project} supports multiple security mechanisms to provide additional layers of protection. Implementing these security features enhances the overall security of your {Project} deployment. |
| Overview of authentication methods in {Project} | The authentication methods you can configure depend on the authentication source you are using. If the native authentication features provided by {Project} are not sufficient for your use case, use this information to decide which external authentication provider best suits your requirements. |

| Heading | Example abstract (reference) |
| :--- | :--- |
| Subscriptions usage data | For the purposes of expense management and to optimize your spending, track your subscriptions usage data that you can get from your {Project} environment and Red Hat. You can track usage, capacity, and utilization of your Red Hat subscriptions. |
| Host global status overview | You can use the host global status in {Project} to see at a glance whether a host is OK, needs attention (Warning), or has errors. The status appears on the Hosts Overview page and helps you prioritize which hosts to investigate. |
