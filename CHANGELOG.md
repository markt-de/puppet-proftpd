# Changelog

## UNRELEASED

### Added
* introduce Puppet 4 parameter validation (#28)

### Changed
* allow stdlib and concat deps < 6.0.0  (#29)

### Fixed
* fix "Unknown variable: 'authuser_require'" (#26)

## 1.4.8
* Breaking: Drop Puppet 3.x support
* Feature: Allow to manage an ftpasswd file using resource declaration
* Bugfix: Remove deprecated concat::fragment parameter
* Bugfix: Fix AuthGroupFile support
* Documentation: Add example for using yaml blocks with multiple hash keys
* Contributors: cedef, crispygoth, AlessandroLorenzi, bc-bjoern

## 1.4.7
* Bugfix: Fix for AuthUserFile with additional arguments
* Contributor: derkgort

## 1.4.6
* Feature: Allow additional arguments to AuthUserFile and AuthGroupFile
* Contributor: derkgort

## 1.4.5
* Feature: Allow injection of AuthUserFile and AuthGroupFile
* Bugfix: Fix permissions of AuthUserFile and AuthGroupFile
* Contributor: adepretis

## 1.4.4
* Bugfix: Fix service notifies for config changes
* Contributor: rendhalver

## 1.4.3
* Bugfix: Fix requirements and silence a warning
* Documentation: Known issues when running on Ruby 1.8
* Contributor: franzs

## 1.4.2
* Bugfix: Fix puppet-lint issues

## 1.4.1
* Bugfix: Do not fail if an expected config section does not exist

## 1.4.0
* Bugfix: Several fixes to make the validate_cmd more robust
* Feature: Add parameter for ordering modules
* Contributor: cdenneen

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

