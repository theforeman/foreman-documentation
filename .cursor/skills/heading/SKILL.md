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
* For procedures (proc_*.adoc): When writing a new heading, start with a verb in imperative voice. When reviewing an existing heading that uses a gerund, keep the gerund; do not rewrite it in imperative voice.
* For references (ref_*.adoc): Do not start the heading with a gerund or verb. Include nouns that appear in the body text.
* For assemblies (the first con_*.adoc in an assembly_*.adoc) that contain at least one procedure: When writing a new heading, start with a verb in imperative voice. When reviewing an existing heading, keep the gerund; do not rewrite it in imperative voice.
* For assemblies (the first con_*.adoc in an assembly_*.adoc) that contain only concepts or references: Do not start the heading with a gerund or verb. Use a noun phrase.

## Post-command cleanup

* If you rename a heading, use the `.cursor/skills/refactor-adoc.md` command to update the module's ID, filename, and all references and links to the module in the repository.

## Examples of good headings

Concept headings:

* Provisioning methods in {Project}
* Security considerations in {Project}
* Host groups overview

Procedure headings:

* Deploy SSH keys during provisioning
* Open required ports
* Configure pull-based transport for remote execution

Reference headings:

* Job template examples and extensions
* Host parameter hierarchy
* Operating system requirements

Assembly headings:

* Connect AI applications to the MCP server for {Project}
* Configure {SmartProxy} and hosts to authenticate with SSH certificates during remote execution
* Content and patch management with {Project}
