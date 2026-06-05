---
name: User personas
description: Understand and apply Foreman user personas when writing documentation
---
### User personas

#### Overview

Foreman documentation targets different user personas with varying responsibilities and permissions. Understanding the target persona helps ensure documentation addresses the user's needs and capabilities appropriately.

**User persona:**
- Has limited permissions
- Runs regular Foreman operations
- Example responsibilities: managing content, provisioning hosts, managing hosts

**Admin persona:**
- Has unlimited permissions, including root access to the Foreman Server
- Example responsibilities: managing Foreman server, configuring system settings

**Architect persona:**
- Has no permissions, does not perform practical administrative or management tasks
- Example responsibilities: evaluating whether Foreman/Katello meets organizational needs, planning deployment architecture

**When to consider personas:**
- Use persona-appropriate language and assume persona-appropriate knowledge
- For User persona: Focus on tasks they can perform with limited permissions
- For Admin persona: Include system administration and configuration tasks
- For Architect persona: Provide planning, architecture, and decision-making information

#### Instructions

When reviewing or writing documentation, identify the target persona and ensure:

1. The content matches the persona's permission level and responsibilities
2. Technical depth is appropriate for the persona's expertise
3. Prerequisites assume the persona's typical environment
4. Examples and use cases reflect the persona's real-world scenarios

If content targets multiple personas, consider splitting it or clearly indicating which sections apply to which personas.
