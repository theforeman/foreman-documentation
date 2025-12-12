This file includes a web UI procedure (`.Procedure`) and a CLI procedure (`.CLI procedure`). Split it into two files: `proc_*-by-using-web-ui.adoc` and `proc_*-by-using-cli.adoc`. Follow these principles:

* Include the introduction (before `.Procedure`) in both new files.
* Adjust the ID of the new files: `[id="original-id-by-using-web-ui"]` and `[id="original-id-by-using-cli"]`.
* Adjust the heading of the new files: `= Original heading by using {ProjectWebUI}` and `= Original heading by using Hammer CLI`.
* Adjust the abstract if needed: `Original abstract from the {ProjectWebUI}` or `Original abstract by using the {ProjectWebUI}` and `Original abstract by using Hammer CLI`.
* Include both new files in its parent file to replace the original `proc_*.adoc` file.
* When creating the CLI file, replace `.CLI procedure` with `.Procedure` and do not include a separate CLI ID.
