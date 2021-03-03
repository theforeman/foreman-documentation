---
title: "Foreman 2.3 and Katello 3.18 documentation"
---

This is work-in-progress documentation site for <a href="https://www.theforeman.org">Foreman</a> open-source software.
Official documentation [is available here](https://theforeman.org/manuals/2.3/index.html).

### Headline features

#### Host Registration

New simplified process of registering hosts to the Foreman. With utilization of provisioning templates,
already running hosts can be registered to the Foreman with one command.
For more details about registration process:
* New page _All Hosts > Register Host_
* Provisioning templates _Global Registration_ & _Linux registration default_
* [RFC - Simple & automatic host registration WF](https://community.theforeman.org/t/rfc-simple-automatic-host-registration-wf/19588)

#### Safe mode template preview when safe mode rendering is disabled
When template safe mode rendering is disabled in the settings, users can now preview rendering of templates with safe mode enabled. This will enable      +updating templates to ensure they render properly under safe mode before turning it on for the whole Foreman. ([#30949](https://projects.theforeman.org/ +issues/30949))

#### Show instance name in top menu
For users managing multiple Foreman instances, a new setting (`instance_title`) has been introduced that allows setting a name for each instance. When    +set, an icon will appear on the top bar which will display the instance name when hovered over. ([#29024](https://projects.theforeman.org/issues/29024))

Available guides for version 2.3:

{{% guide-list version="2.3" %}}
