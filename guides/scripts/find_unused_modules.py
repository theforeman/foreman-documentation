#!/usr/bin/env python3

# script to find potentially unused '.adoc' files
# FIXME: this ignores content in 'find guides -type d -iname "topics"'
# This script does not work for file includes that contain attributes.
# Example: "include::modules/proc_configuring-repositories-{build}.adoc[]"

import os
import glob

modules_directory = "guides/common/modules"
list_of_files = []

for file in os.listdir(modules_directory):
    list_of_files.append(os.path.basename(file))

list_of_assemblies = glob.glob("guides/common/assembly_*.adoc")
list_of_master_files = glob.glob("guides/*/master.adoc")
list_of_modules = glob.glob("guides/common/modules/*.adoc")
combined_lists = list_of_assemblies + list_of_master_files + list_of_modules

for assembly in combined_lists:
    with open(assembly, "r") as f:
        for line in f:
            for file in list_of_files:
                if file in line.strip():
                    list_of_files.remove(file)

for i in list_of_files:
    print(i)
