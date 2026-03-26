---
name: prerequisites
description: Review or add prerequisites
---
# Review or add prerequisites

## Overview

Review prerequisites in this file to make sure they are labeled correctly and use consistent formatting. Prerequisites are a bulleted list of conditions that must be satisfied before the user starts the procedure.

## Instructions

1. Only procedure modules (proc_*.adoc) can include a `.Prerequisites` section. If a module other than a procedure module contains `.Prerequisites`, flag this as an issue for human review.
2. If a section titled `.Prerequisites` exists in the file, ensure it uses consistent formatting:
    - Each prerequisite must start with a bullet point.
    - Prerequisites must use parallel language. For example, if one bullet is a complete sentence, write the other bullets as complete sentences.
    - Prerequisites should not use imperative voice.
    - Passive voice is acceptable for prerequisites if the prerequisite represents an action that is not completed by the current user. For example, having a configuration enabled by a system admin.
2. If a section titled `.Prerequisites` exists in the file, ensure it contains information suitable for prerequisites:
    - Prerequisites are checks that are true, checks that the user must have completed before they begin a procedure, or items that the user must have ready before beginning a procedure. Prerequisites can also be actions that the user, another person, or piece of technology has completed before the user can being the procedure.
    - Focus on relevant prerequisites that users might not otherwise be aware of. Do not list obvious prerequisites.
    - Do not include steps in prerequisites. If `.Prerequisites` includes a step, move the step to the `.Procedure` section.
    - Do not exceed 10 prerequisites. If `.Prerequisites` includes more than 10 items, flag this as an issue for human review.
3. If a procedure module does not include `.Prerequisites` section, scan the module to identify steps that meet criteria for prerequisites. If a step or steps like this exist, create a `.Prerequisites` section and rephrase the step or steps as prerequisites in this section.

## Examples of good prerequisites

* The `kernelcare` package is installed on your hosts.
* The base system of the {SmartProxy} is registered to the newly upgraded {ProjectServer}.
* Your user account has a role assigned that has the `view_policies` permission.
* You are logged in to the registry.redhat.io container registry.
* If you use `dzdo` for Ansible jobs, the `community.general` Ansible collection must be installed.
