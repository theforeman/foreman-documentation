---
name: Headings
description: Review or write heading
---
#### Overview

Headings should be clear, concise, and use familiar keywords that help users understand what the content covers.

**General principles for all headings:**
- Make the heading 3-11 words long
- Make the heading understandable without surrounding context by naming the subject and, for procedures, the action or outcome
- Use familiar terms that users are likely to search for and reuse key nouns from the content
- Avoid generic headings such as "Overview", "Additional configuration", or "Other options"
- Ensure the heading summarizes the contents of the part of the documentation it introduces
- Do not use gerunds (-ing verb forms) in headings

**Module-type-specific principles:**
- **Concepts** (con_*.adoc): Do not start with a verb. Use a noun phrase and include nouns that appear in the body text.
NOTE: If the concept is the first file in an assembly that contains procedures, it might need a verb-based heading.
- **Procedures** (proc_*.adoc): Start the heading with an imperative verb (e.g., "Configure...", "Create..."). Do not use gerunds.
- **References** (ref_*.adoc): Do not start with a verb. Use a noun phrase and include nouns that appear in the body text.
- **Assemblies** containing procedures: Start the heading with an imperative verb.
- **Assemblies** containing only concepts or references: Do not start with a verb. Use a noun phrase.

#### Examples

**Concept headings:**
- Provisioning methods in {Project}
- Security considerations in {Project}
- Host groups overview

**Procedure headings:**
- Deploy SSH keys during provisioning
- Open required ports
- Configure pull-based transport for remote execution

**Reference headings:**
- Job template examples and extensions
- Host parameter hierarchy
- Operating system requirements

**Assembly headings:**
- Connect AI applications to the MCP server for {Project}
- Configure {SmartProxy} and hosts to authenticate with SSH certificates during remote execution
- Content and patch management with {Project}

#### Instructions

Review and improve the heading for this file. Write it if it doesn't exist yet.

Follow the principles outlined in the Overview section above.

#### Post-command cleanup

If you rename a heading, use the `/refactor-adoc` command to update the anchor, and filename of the module and all references and links to the module in the repository.

After renaming, verify that the module ID, heading, and filename all match by running:

```bash
./scripts/check-filename-id-heading-match.sh path/to/file.adoc
```
