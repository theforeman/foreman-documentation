# Foreman documentation site

Uses [nanoc](https://nanoc.app) site generator.

Synopsis:

	$ bundle config set --local path 'vendor/bundle'
	$ bundle install
	$ bundle exec nanoc compile

For auto-reloading do:

	$ bundle exec nanoc live

When executed with "dev" environment, content of guides/build is also symlinked
as /nightly so all built nightly guides are also available through nano:

	$ bundle exec nanoc live --env=dev

To listen on all interfaces:

	$ bundle exec nanoc live -o \*

To perform a HTML validation check:

	$ bundle exec nanoc check

To build the whole site and nightly guides for a full experience:

	$ cd guides/
	$ make clean
	$ make BUILD=foreman-el
	$ make BUILD=foreman-deb
	$ make BUILD=katello
	$ cd ../web
	$ bundle exec nanoc live -o \* --env=dev

Navigate to `http://localhost:3000` to test the result.

To edit the main menu, navigate to content/js/nav.js and edit the file, publish
the changes and all guides and pages will dynamically load the menu from the
data structure.
