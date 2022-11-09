#!/usr/bin/env python3

import os
import re
import subprocess
import sys

dict_url_to_title = {
    "AdministeringDocURL": "AdministeringDocTitle",
    "ManagingConfigurationsAnsibleDocURL": "ManagingConfigurationsAnsibleDocTitle",
    "ConfiguringLoadBalancerDocURL": "ConfiguringLoadBalancerDocTitle",
    "ContentManagementDocURL": "ContentManagementDocTitle",
    "InstallingServerDocURL": "InstallingServerDocTitle",
    "InstallingSmartProxyDocURL": "InstallingSmartProxyDocTitle",
    "ManagingConfigurationsPuppetDocURL": "ManagingConfigurationsPuppetDocTitle",
    "ManagingHostsDocURL": "ManagingHostsDocTitle",
    "ManagingOrganizationsLocationsDocURL": "ManagingOrganizationsLocationsDocTitle",
    "PlanningDocURL": "PlanningDocTitle",
    "ProvisioningDocURL": "ProvisioningDocTitle",
    "UpgradingDocURL": "UpgradingDocTitle",
    "InstallingServerDisconnectedDocURL": "InstallingServerDisconnectedDocTitle",
}
list_of_adoc_files = []
pattern_docurl = r"([Ss])*(ee )*(in )*(the )*({)([A-Za-z]*DocURL)(})([A-Za-z_{}-]*)(\[)([_]*)([A-Z{}a-z0-9 (),-]*)([_]*)(\])*( )*(in )*(the )*(_)*([A-Za-z{} ]*)(_)*( [Gg]uide)*(_)*"

# FIXME: These titles have no DocURL?
"""
list of DocTitles:
    * AdministeringAnsibleDocTitle
    * AppCentricDeploymentDocTitle
    * ConvertingHostRHELDocTitle
    * DeployingAWSDocTitle
    * InstallingServerDisconnectedDocTitle
    * QuickstartDocTitle
    * ReleaseNotesDocTitle
"""

result = subprocess.run(["git", "restore", "guides/"], stdout=subprocess.PIPE)
print(result.stdout.decode("utf-8"))

# https://stackoverflow.com/a/3964691
for root, dirs, files in os.walk("./guides"):
    for file in files:
        if file.endswith(".adoc"):
            list_of_adoc_files.append(os.path.join(root, file))

for adoc_file in list_of_adoc_files:
    with open(str(adoc_file), "r") as f:
        file_content = f.read().splitlines(keepends=True)
        new_content = []
        for line in file_content:
            matches = re.finditer(pattern_docurl, line)
            for match in matches:
                mg1 = match.group(1)  # optional: capitalization of 's' of '[Ss]ee'; necessary if sentence starts with 'See'
                mg2 = match.group(2)  # optional: 'ee ' of '[Ss]ee'
                mg3 = match.group(3)  # optional: 'in '
                mg4 = match.group(4)  # optional: 'the '
                mg5 = match.group(5)  # opening curly bracket
                mg6 = match.group(6)  # DocURL
                mg7 = match.group(7)  # closing curly bracket
                mg8 = match.group(8)  # optional: anchor
                mg9 = match.group(9)  # opening bracket
                mg10 = match.group(10)  # optional: '_' to make title italic
                mg11 = match.group(11)  # title
                mg12 = match.group(12)  # optional: '_' to make title italic
                mg13 = match.group(13)  # closing bracket
                mg14 = match.group(14)  # optional: ' ' if sentence continues.
                mg15 = match.group(15)  # optional: 'in '
                mg16 = match.group(16)  # optional: 'the '
                mg17 = match.group(17)  # optional: '_' to make DocURL italic
                mg18 = match.group(18)  # optional: DocURL title
                mg19 = match.group(19)  # optional: '_' to make DocURL italic
                mg20 = match.group(20)  # optional: '[Gg]uide'
                mg21 = match.group(21)  # optional: '_' to make [Gg] italic
                print("mg1:", mg1)
                print("mg2:", mg2)
                print("mg3:", mg3)
                print("mg4:", mg4)
                print("mg5:", mg5)
                print("mg6:", mg6)
                print("mg7:", mg7)
                print("mg8:", mg8)
                print("mg9:", mg9)
                print("mg10:", mg10)
                print("mg11:", mg11)
                print("mg12:", mg12)
                print("mg13:", mg13)
                print("mg14:", mg14)
                print("mg15:", mg15)
                print("mg16:", mg16)
                print("mg17:", mg17)
                print("mg18:", mg18)
                print("mg19:", mg19)
                print("mg20:", mg20)
                print("mg21:", mg21)

                use_case = "0"
                if mg1 is None and mg2 is None and mg3 is None and mg4 is None:
                    # line does not start with "see" or "in the"
                    use_case = "ignore"
                elif mg15 is None and mg16 is None and mg17 is None:
                    use_case = "ignore"
                elif mg18.split(" ")[0] == "and":
                    # line contains two links in a row
                    use_case = "ignore"
                elif mg10 == "_" and mg12 == "_":
                    use_case = "replace_title_only"
                elif mg8 is not None:
                    use_case = "docURL_with_anchor"

                # allow for concatenation of 'None' values
                if mg1 is None:
                    mg1 = ""
                if mg2 is None:
                    mg2 = ""
                if mg3 is None:
                    mg3 = ""
                if mg4 is None:
                    mg4 = ""
                if mg8 is None:
                    mg8 = ""
                if mg10 is None:
                    mg10 = ""
                if mg12 is None:
                    mg12 = ""
                if mg14 is None:
                    mg14 = ""
                if mg15 is None:
                    mg15 = ""
                if mg16 is None:
                    mg16 = ""
                if mg17 is None:
                    mg17 = ""
                if mg18 is None:
                    mg18 = ""
                if mg19 is None:
                    mg19 = ""
                if mg20 is None:
                    mg20 = ""
                if mg21 is None:
                    mg21 = ""

                docurl = mg1 + mg2 + mg3 + mg4 + mg5 + mg6 + mg7 + mg8 + mg9 + mg10 + mg11 + mg12 + mg13 + mg14 + mg15 + mg16 + mg17 + mg18 + mg19 + mg20 + mg21
                print(f'use_case   : "{use_case}"')
                print(f'docurl     : "{docurl}"')

                if use_case == "0":
                    sys.exit(1)
                elif use_case == "docURL_with_anchor":
                    docTitle = dict_url_to_title.get(mg6)
                    replacement = mg1 + mg2 + mg3 + mg4 + mg5 + mg6 + mg7 + mg8 + "[" + mg11 + "]" + " in " + "_{" + docTitle + "}_"
                elif use_case == "replace_title_only":
                    docTitle = dict_url_to_title.get(mg6)
                    replacement = mg1 + mg2 + mg3 + mg4 + mg5 + mg6 + mg7 + mg8 + "[_{" + docTitle + "}_]"
                elif use_case == "ignore":
                    print(f'ignore : "{docurl}"')
                    replacement = docurl

                print(f'replacement: "{replacement}"')
                line = line.replace(docurl, replacement)
                print()

            new_content.append(line)
    with open(str(adoc_file), "w") as f:
        for line in new_content:
            f.write(line)

result = subprocess.run(["git", "diff", "-U0"], stdout=subprocess.PIPE)
print(result.stdout.decode("utf-8"))

# for debugging only
# result = subprocess.run(["git", "restore", "guides/"], stdout=subprocess.PIPE)
# print(result.stdout.decode("utf-8"))
