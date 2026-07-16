# Migration Maps

This directory contains Asciidoc migration maps, which organize Foreman/Satellite documentation into job-based categories following the DITA map structure.

Asciidoc migration maps can be migrated directly into Adobe Experience Manager.

## Product Documentation Categories

This section copied from DocX Google doc.
Categories and definitions might change.

These categories are used for:
* Organizing topics that display in the table of contents
* Providing a consistent naming convention for AEM folders across products
* Assigning taxonomy values to the use case metadata field

| Category name | Definition | JTBD-Aligned Framing (When I want to…) | What content belongs here? |
| :---- | :---- | ----- | ----- |
| **What's new** | Learn what has changed in the current release. | *Understand what's new, improved, or deprecated. Discover highlights to tech preview features. Learn about bug fixes and known issues.* | Release notes, breaking changes, deprecations, highlights. |
| **Discover** | Orient me to what the product is, what it does, and when I should use it. | *Understand whether this product solves my problem, what it can do, and how it conceptually works.* | High-level orientation, value proposition, key capabilities, conceptual diagrams (not architectural choices). |
| **Get started** | Perform the simplest first tasks to become productive with the product. | *Quickly learn how to do something meaningful with the product after installation.* | Intro tutorials, initial configurations, "hello world," first-time usage. |
| **Plan** | Help me choose the right architecture and topology before installing. | *Design and size the right deployment for my environment before committing to installation.* | Detailed reference architectures, sizing, system requirements, supported topologies, capacity planning, and deployment implications and trade offs. |
| **Install** | Install the product in a supported and repeatable way. | *Set up the product so it's running in my environment.* | Installation procedures, cluster creation, prerequisites verification, installer workflows, post-install checks, and uninstalling procedures. |
| **Upgrade** | Move an existing environment to a newer version safely. | *Update the product without disrupting my environment.* | Upgrade paths, compatibility notes, prerequisites, rollback instructions. |
| **Migrate** | Move from one system or platform to another. | *Shift my data, apps, or clusters to a different environment.* | Migration guides, conversion tools, supported migration paths. |
| **Administer** | Operate and manage the product on an ongoing basis. | *Keep the product healthy, secure, and performing well in production.* | Day-to-day operations, user management, backup/restore, maintenance tasks. |
| **Develop** | Build, modify, or maintain applications or automation that run on or with the product. | *Create software or automation that uses this product's capabilities.* | API usage, SDKs, custom resources, sample code, development workflows. |
| **Configure** | Adjust system or product settings to meet desired behavior. | *Set up or tune the product to behave the way I need.* | Configuration settings, tuning, network configuration, storage configuration. |
| **Secure** | Implement security controls and ensure compliance. | *Protect my system and data, and meet security requirements.* | Authentication, authorization, encryption, compliance, security hardening. |
| **Observe** | Monitor, trace, and understand system behavior and performance. | *See what's happening in my system so I can understand or troubleshoot it.* | Logging, monitoring, metrics, alerts, eventing, observability integrations. |
| **Integrate** | Connect the product to external systems, platforms, or services. | *Make this product work with other products, cloud services, or enterprise systems.* | Authentication integration, cloud provider integration, external monitoring, cross-product workflows, third-party connectors. |
| **Optimize** | Right size the deployment for my environment and tune existing software installations. | *Align product performance with organizational priorities and environment constraints.* | Performance tuning, resource optimization, scaling strategies. |
| **Extend** | Add internal capabilities or optional components that run *inside* the product. | *Enhance the product's functionality by adding supported extensions or plug-ins.* | Operators, plug-ins, platform add-ons, internal services, extensions managed by the platform. |
| **Troubleshoot** | Diagnose and resolve issues in the product. | *Fix a problem so the system works again.* | Known issues, troubleshooting flows, diagnostic tools, remediation steps. |
| **Reference** | Access authoritative details, parameters, and APIs. | *Look up exact details so I can configure or automate accurately.* | API references, CLI options, CRD specs, parameters, schemas. |
| **Download PDF** | Download PDFs for this product version. | *Access the product documentation in PDF for example if I am in a disconnected environment* | PDF Landing page topic |

### Recommended Order in TOC

**Fixed order at top:**
1. What's new
2. Discover
3. Get started
4. Plan

**Flexible order in middle:**
- Install
- Upgrade
- Migrate
- Administer
- Develop
- Configure
- Secure
- Observe
- Integrate
- Optimize
- Extend

**Fixed order at bottom:**
1. Troubleshoot
2. Reference
3. Download PDF

### Guidelines

- Do not add the use case to your TOC if the use case is empty.
- Do not create new categories without DocX team approval.
- Category definitions current as of July 6, 2026.

## Map Structure

The guide uses a hierarchical map structure.

### Master File

`master.adoc` is the top-level guide file that includes all category maps.
This is the main DITA navigation map.

### Map Files

Map files organize content by job categories.
Each map file has the following:
- `map_` prefix (e.g., `map_install.adoc`, `map_plan.adoc`)
- `:context:` attribute matching the category name
- `:_mod-docs-content-type: MAP`
- Category heading (e.g., `= Install`)
- Assemblies and modules from `../common/` with `leveloffset=+1`

## Building the Guide

The guide is built as part of the Foreman documentation build system.
Refer to the main repository documentation for build instructions.
