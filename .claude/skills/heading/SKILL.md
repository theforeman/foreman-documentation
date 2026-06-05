---
name: Headings
description: Review or write heading
---

### Review or write heading

#### Overview

Headings should be clear, concise, and use familiar keywords that help users understand what the content covers.

**General principles for all headings:**
- Make the heading 3-11 words long
- Use clear headings with familiar keywords for users
- Ensure the heading summarizes the contents of the part of the documentation it introduces

**Module-type-specific principles:**
- **Concepts** (con_*.adoc): Do not start with a gerund or verb. Use a noun phrase and include nouns that appear in the body text.
- **Procedures** (proc_*.adoc): Start the heading with a gerund (e.g., "Configuring...", "Creating...").
- **References** (ref_*.adoc): Do not start with a gerund or verb. Include nouns that appear in the body text.
- **Assemblies** containing procedures: Start the heading with a gerund.
- **Assemblies** containing only concepts or references: Do not start with a gerund or verb. Use a noun phrase.

#### Examples

**Concept headings:**
- Provisioning methods in {Project}
- Security considerations in {Project}
- Host groups overview

**Procedure headings:**
- Deploying SSH keys during provisioning
- Opening required ports
- Configuring pull-based transport for remote execution

**Reference headings:**
- Job template examples and extensions
- Host parameter hierarchy
- Operating system requirements

**Assembly headings:**
- Connecting AI applications to the MCP server for {Project}
- Configuring {SmartProxy} and hosts to authenticate with SSH certificates during remote execution
- Content and patch management with {Project}

#### Instructions

Review and improve the heading for this file. Write it if it doesn't exist yet.

Follow the principles outlined in the Overview section above.

#### Post-command cleanup

If you rename a heading, use the `/refactor-adoc` command to update the module's ID, filename, and all references and links to the module in the repository.
