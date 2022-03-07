# Foreman documentation site

Uses [nanoc](https://nanoc.app) site generator.

Synopsis:

	$ bundle config set --local path 'vendor/bundle'
	$ bundle install
	$ bundle exec nanoc compile

For auto-reloading do:

	$ bundle exec nanoc live

To listen on all interfaces:

	$ bundle exec nanoc live -o \*

To perform a HTML validation check:

	$ bundle exec nanoc check

Navigate to `http://localhost:3000` to test the result. To test full site with
guides, use the Makefile in the root directory.

To edit the main menu, navigate to content/js/nav.js and edit the file, publish
the changes and all guides and pages will dynamically load the menu from the
data structure.
