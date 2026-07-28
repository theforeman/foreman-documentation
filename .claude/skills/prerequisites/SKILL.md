---
name: Prerequisites
description: Review or add prerequisites
---
#### Overview

Prerequisites are a bulleted list of conditions that must be satisfied before the user starts a procedure. Only procedure modules (proc_*.adoc) can include a `.Prerequisites` section.

**What prerequisites are:**
- Checks that are true before the user begins
- Conditions the user must have completed beforehand
- Items the user must have ready
- Actions that the user, another person, or technology has completed before the user can begin

**Formatting guidelines:**
- The first word of each prerequisite must be capitalized
- Each prerequisite must start with a bullet point
- Prerequisites must not use imperative voice
- If prerequisites are full sentences, end all with a period
- If prerequisites are sentence fragments, do not use any end punctuation
- Use passive voice for prerequisites representing an action not completed by the current user
- Prerequisites must use parallel language (all sentences or all fragments, not mixed)

**Content guidelines:**
- Focus on relevant prerequisites that users might not otherwise be aware of
- Do not list obvious prerequisites
- Do not include procedure steps in prerequisites
- Do not exceed 10 prerequisites

#### Examples

**Good prerequisites:**
- The `kernelcare` package is installed on your hosts.
- The base system of the {SmartProxy} is registered to the newly upgraded {ProjectServer}.
- Your user account has a role that grants the `view_policies` permission.
- You are logged in to the registry.redhat.io container registry.
- If you use `dzdo` for Ansible jobs, the `community.general` Ansible collection must be installed.

**Bad prerequisites (and why):**
- You are logged in. *(Obvious prerequisite)*
- The host is registered to {Project}. *(Obvious prerequisite)*
- At least one host exists in {Project}. *(Obvious prerequisite)*
- Ensure the `kernelcare` package is installed on your hosts. *(Uses imperative voice)*
- Install the `kernelcare` package on your hosts. *(Phrased like a procedure step)*

#### Instructions

1. Only process procedure modules (proc_*.adoc). These are the only modules that can include a `.Prerequisites` section.
2. If a section titled `.Prerequisites` exists in the file, ensure it uses consistent formatting as described in the Overview.
3. If a section titled `.Prerequisites` exists in the file, ensure it contains information suitable for prerequisites.
4. If a procedure module does not include a `.Prerequisites` section, scan the module to identify steps that meet criteria for prerequisites. If such steps exist, create a `.Prerequisites` section and rephrase the steps as prerequisites.
