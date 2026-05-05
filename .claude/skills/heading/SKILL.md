---
name: heading
description: Review or write heading
---

# Review or write heading

## Overview

Review and improve the heading for this file.
Write it if it doesn't exist yet.

## Instructions

Follow these general principles for all headings:

* Make the heading 3-11 words long.
* Use clear headings with familiar keywords for users.
* Ensure the heading summarizes the contents of the part of the documentation it introduces.

Additional principles for specific heading types:

* For concepts (con_*.adoc): Do not start the heading with a gerund or verb. Use a noun phrase and include nouns or noun phrases that appear in the body text.
* For procedures (proc_*.adoc): Start the heading with a gerund.
* For references (ref_*.adoc): Do not start the heading with a gerund or verb. Include nouns that appear in the body text.
* For assemblies (the first con_*.adoc in an assembly_*.adoc) that contain at least one procedure: Start the heading with a gerund.
* For assemblies (the first con_*.adoc in an assembly_*.adoc) that contain only concepts or references: Do not start the heading with a gerund or verb. Use a noun phrase.

## Post-command cleanup

* If you rename a heading, use the `.cursor/skills/refactor-adoc.md` command to update the module's ID, filename, and all references and links to the module in the repository.

## Examples of good headings

Concept headings:

* Provisioning methods in {Project}
* Security considerations in {Project}
* Host groups overview

Procedure headings:

* Deploying SSH keys during provisioning
* Opening required ports
* Configuring pull-based transport for remote execution

Reference headings:

* Job template examples and extensions
* Host parameter hierarchy
* Operating system requirements

Assembly headings:

* Connecting AI applications to the MCP server for {Project}
* Configuring {SmartProxy} and hosts to authenticate with SSH certificates during remote execution
* Content and patch management with {Project}
