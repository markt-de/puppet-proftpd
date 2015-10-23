# Changelog

## 1.3.0
* Feature: Create empty AuthUserFile/AuthGroupFile to allow the configtest to succeed
* Bugfix: Fix ERB template to be ready for Puppet 4
* Bugfix: Fix syntax errors in non-hiera example configuration
* Contributors: yarikdot, trlinkin, lmorfitt

## 1.2.0
* Feature: Add hiera lookup for `$::proftpd::options` to merge values from multiple hierarchy levels
* Contributor: cdenneen

## 1.1.1
* Bugfix: Fix `LogFormat` and `ExtendedLog` in default configuration

## 1.1.0
* Feature: Setting an option to 'false' will remove it from the configuration.
* Security: Change insecure default value in `$anonymous_options` to disable write access.

## 1.0.0
* Initial release

