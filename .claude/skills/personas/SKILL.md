---
name: User personas
description: Understand and apply Foreman user personas when writing documentation
---
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

#### Instructions

When reviewing or writing documentation, identify the target persona and ensure:

1. The content matches the persona's permission level and responsibilities
2. Technical depth is appropriate for the persona's expertise
3. Prerequisites assume the persona's typical environment
4. Examples and use cases reflect the persona's real-world scenarios

If content targets multiple personas, report this for human review and suggest how to split it.
