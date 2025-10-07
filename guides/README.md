# Foreman guides

This README file explains how to work with the guides included in this repository, including setting up your system for local testing.

## Building locally

### Installing tools

Install the required tools.

1. Install the required packages:

* In Fedora perform:

      dnf -y group install development-tools
      dnf -y install ruby ruby-devel rubygem-bundler linkchecker c++

* In RHEL perform:

      dnf module enable ruby:2.7
      dnf -y groupinstall "Development Tools"
      dnf -y install ruby ruby-devel rubygem-bundler python3-pip
      pip3 install linkchecker

  If you prefer to install Python packages into home folder rather than system-wide folder (requires root), then add `--user` option to the `pip3` command.

* In MacOS, required tools can be installed via brew but instead of "make" call "gmake":

      brew install ruby make
      # brew will ask to perform this after ruby installation, do it and restart the terminal
      echo 'export PATH="/opt/homebrew/opt/ruby/bin:$PATH"' >> ~/.zshrc

  Alternatively, XCode development environment can be installed to have "make" utility available on PATH, however, this takes about an hour to download and install, and requires several gigabytes of HDD space:

      xcode-select --install

2. Install Ruby gems.
In the `foreman-documentation` folder, run:

      make prep

### Building HTML artifacts

To build HTML artifacts, run the `make` command.
If you run the command in the `guides/` directory, all guides are built.
If you run the command in a`doc-*/` subdirectory, a single guide is built.

- `make BUILD=foreman-el` - This builds guides for Foreman on Enterprise Linux (EL) without the Katello plugin.
This is the default build for `make html`.
- `make BUILD=foreman-deb` - This builds guides for Foreman on Debian/Ubuntu without the Katello plugin.
- `make BUILD=katello` - This builds guides for Foreman on EL with the Katello plugin.
- `make BUILD=satellite` - This builds a preview of guides for Satellite.
- `make BUILD=orcharhino` - This builds a preview of guides for orcharhino.
- `make browser` (run from a `doc-*/` subdirectory) - This builds the HTML version and opens a new tab in a browser.

To view the built HTML artifact, go to the `./build` subdirectory and locate the `*.html` file you need.
Note that GNU Makefile tracks changes and only builds relevant artifacts.
To trigger a full rebuild, use `make clean` to delete the build directory and start over.

To speed up the build process, make sure to use `-j` option. Ideally, set it to amount of cores plus one:

	make -j9

An alias is often useful:

	alias make="make -j$(nproc)"

### Building locally by using a container

You can build Foreman documentation locally using a container image.
This requires the cloned git repository plus an application such as Podman or Docker to build and run container images.

Run the following commands from your `foreman-documentation` directory:

1. Build container image:

       podman build --tag foreman_documentation .

2. Build Foreman documentation:

       rm -rf guides/build && podman run --rm -v $(pwd):/foreman-documentation foreman_documentation make html

   On SELinux enabled systems, run this command:

       rm -rf guides/build && podman run --rm -v $(pwd):/foreman-documentation:Z foreman_documentation make html

## Testing link integrity with linkchecker

The repository includes a linkchecker GitHub Action to check the validity of links used in the documentation.

### Running a link check manually

You can check links in your local repository.
The following command checks all links except example.com domain:

	make linkchecker

### Disabling the linkchecker for a specific URL pattern

You can disable the linkcheck job for specific URL pattern, for example for unreleased downstream documentation or to exclude URLs that cannot resolve by design.
Append your pattern to `guides/common/linkchecker.ini`.
Example: [64d825cc9](https://github.com/theforeman/foreman-documentation/commit/64d825cc9da3992879dfbfc088988197edc9f33b)

### Generating a TOC file

For properly testing link integrity in the code, you will need to generate a TOC file.
This file can be generated using `make toc` command either from a container or locally.

This command generates a JSON file that later can be consumed by link validation code.
The basic structure of the file is a nested path parts in the documentation links. For example:
``` json
{
  "administering_red_hat_satellite": {
    "accessing_server_admin": [
      "Logging_in_admin",
      "Using_FreeIPA_credentials_to_log_in_to_the_foreman_Hammer_CLI_admin",
      "Using_FreeIPA_credentials_to_log_in_to_the_foreman_web_UI-with-Mozilla-Firefox_admin",
      "Using_FreeIPA_credentials_to_log_in_to_the_foreman_web_UI-with-a-Chrome-browser_admin",
      "Navigation_Tabs_in_the_Web_UI_admin",
      "Changing_the_Password_admin",
      "Resetting_the_Administrative_User_Password_admin",
      "Setting_a_Custom_Message_on_the_Login_Page_admin"
    ],
  }
}
```
which can be used for validating `administering_red_hat_satellite/accessing_server_admin#Logging_in_admin` link.

Note: The translation of book file names to root part of the link path is dependent on [`upstream_filename_to_satellite_link.json`](./upstream_filename_to_satellite_link.json) file.
For example `build/Administering_Project/index-satellite.html` would be translated to `.../administering_red_hat_satellite/...` path in the TOC.
File names that are missing from this JSON file would be omitted from the TOC.

Currently the main use of the TOC file is for downstream links validation in [`foreman_theme_satellite`](https://github.com/RedHatSatellite/foreman_theme_satellite/commit/7fb213daa8929b1e5ceb7999a79dbc8eebd3500d).
In order to implement the same technique for the upstream documentation, there is need to extract links from the code.

## Creating new guides

Each guide must be in a separate directory in `guides/` prefixed with `doc-`.
The following requirements must be met:

* Top-level file `master.adoc`.
* Symlink `common` to `../common` for shared content.
* Directory `images` with images.
* Symlink `images/common` to `../common/images`.
* File `Makefile` which includes `../common/Makefile`.
* File `docinfo.xml` for Red Hat Satellite guides.
Presence of this file will cause build check via `ccutil`, a tool used by Red Hat documentation team.
* Put new content into the `guides/common/modules` directory and stick to one (level one) heading per file.
* Update `web/content/js/nav.js` to add a new item on the top-level menu.

New guides can typically be created as copies of existing guides, just make sure to clean images, topics and `docinfo.xml`.
