# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
* New dependency: puppetlabs/yumrepo_core

### Fixed
* Fix acceptance tests on Rocky/RHEL 8

### Changed
* Add a resource relationship for yumrepo on RHEL
* Make puppet/epel a dependency (was previously only a "soft" dependency)

## [2.2.0] - 2023-07-11

### Added
* Add Github Actions & basic acceptance test ([#41])

### Changed
* Update package name on Debian 11 ([#40])
* Replace legacy facts with modern facts ([#39])
* Update PDK ([#41])
* Allow stdlib and concat <= 9.0.0 ([#44])

## [2.1.0] - 2022-08-02

### Changed
* Update OS version, Puppet version and dependencies
* Update PDK from 1.18.0 to 2.5.0
* Fix puppet-lint offenses

## [2.0.0] - 2020-06-17
This is a new major release that may contain (unexpected) breaking changes. Please test in non-production environment and report any issues on GitHub.

### Changed
* Migrate default values from `params.pp` to module data
* Declare officially compatible with Puppet 6 ([#35])
* Convert to PDK ([#33])
* Replace deprecated functions ([#31])
* Convert documentation to Puppet Strings

### Fixed
* Fix rubocop offenses

## [1.4.9] - 2019-08-26

### Added
* Introduce Puppet 4 parameter validation (#28)
* Add new parameter `$config_mode` to set file mode for config files (#32)

### Changed
* Allow stdlib and concat deps < 6.0.0  (#29)
* Require Puppet >= 5.0.0

### Fixed
* Fix "Unknown variable: 'authuser_require'" (#26)

## [1.4.8] - 2018-05-03
* Breaking: Drop Puppet 3.x support
* Feature: Allow to manage an ftpasswd file using resource declaration
* Bugfix: Remove deprecated concat::fragment parameter
* Bugfix: Fix AuthGroupFile support
* Documentation: Add example for using yaml blocks with multiple hash keys
* Contributors: cedef, crispygoth, AlessandroLorenzi, bc-bjoern

## [1.4.7] - 2017-04-11
* Bugfix: Fix for AuthUserFile with additional arguments
* Contributor: derkgort

## [1.4.6] - 2017-04-10
* Feature: Allow additional arguments to AuthUserFile and AuthGroupFile
* Contributor: derkgort

## [1.4.5] - 2017-03-22
* Feature: Allow injection of AuthUserFile and AuthGroupFile
* Bugfix: Fix permissions of AuthUserFile and AuthGroupFile
* Contributor: adepretis

## [1.4.4] - 2016-12-19
* Bugfix: Fix service notifies for config changes
* Contributor: rendhalver

## [1.4.3] - 2016-09-29
* Bugfix: Fix requirements and silence a warning
* Documentation: Known issues when running on Ruby 1.8
* Contributor: franzs

## [1.4.2] 2016-05-03
* Bugfix: Fix puppet-lint issues

## [1.4.1] - 2016-05-02
* Bugfix: Do not fail if an expected config section does not exist

## [1.4.0] 2016-03-02
* Bugfix: Several fixes to make the validate_cmd more robust
* Feature: Add parameter for ordering modules
* Contributor: cdenneen

## [1.3.0] - 2015-10-24
* Feature: Create empty AuthUserFile/AuthGroupFile to allow the configtest to succeed
* Bugfix: Fix ERB template to be ready for Puppet 4
* Bugfix: Fix syntax errors in non-hiera example configuration
* Contributors: yarikdot, trlinkin, lmorfitt

## [1.2.0] . 2015-04-17
* Feature: Add hiera lookup for `$::proftpd::options` to merge values from multiple hierarchy levels
* Contributor: cdenneen

## [1.1.1] - 2015-04-12
* Bugfix: Fix `LogFormat` and `ExtendedLog` in default configuration

## [1.1.0] - 2015-03-26
* Feature: Setting an option to 'false' will remove it from the configuration.
* Security: Change insecure default value in `$anonymous_options` to disable write access.

## 1.0.0 - 2015-03-23
* Initial release

[Unreleased]: https://github.com/fraenki/puppet-proftpd/compare/2.2.0...HEAD
[2.2.0]: https://github.com/fraenki/puppet-proftpd/compare/2.1.0...2.2.0
[2.1.0]: https://github.com/fraenki/puppet-proftpd/compare/2.0.0...2.1.0
[2.0.0]: https://github.com/fraenki/puppet-proftpd/compare/1.4.9...2.0.0
[1.4.9]: https://github.com/fraenki/puppet-proftpd/compare/1.4.8...1.4.9
[1.4.8]: https://github.com/fraenki/puppet-proftpd/compare/1.4.7...1.4.8
[1.4.7]: https://github.com/fraenki/puppet-proftpd/compare/1.4.6...1.4.7
[1.4.6]: https://github.com/fraenki/puppet-proftpd/compare/1.4.5...1.4.6
[1.4.5]: https://github.com/fraenki/puppet-proftpd/compare/1.4.4...1.4.5
[1.4.4]: https://github.com/fraenki/puppet-proftpd/compare/1.4.3...1.4.4
[1.4.3]: https://github.com/fraenki/puppet-proftpd/compare/1.4.2...1.4.3
[1.4.2]: https://github.com/fraenki/puppet-proftpd/compare/1.4.1...1.4.2
[1.4.1]: https://github.com/fraenki/puppet-proftpd/compare/1.4.0...1.4.1
[1.4.0]: https://github.com/fraenki/puppet-proftpd/compare/1.3.0...1.4.0
[1.3.0]: https://github.com/fraenki/puppet-proftpd/compare/1.2.0...1.3.0
[1.2.0]: https://github.com/fraenki/puppet-proftpd/compare/1.1.1...1.2.0
[1.1.1]: https://github.com/fraenki/puppet-proftpd/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/fraenki/puppet-proftpd/compare/1.0.0...1.1.0
[#44]: https://github.com/fraenki/puppet-proftpd/issues/44
[#41]: https://github.com/fraenki/puppet-proftpd/issues/41
[#40]: https://github.com/fraenki/puppet-proftpd/issues/40
[#39]: https://github.com/fraenki/puppet-proftpd/issues/39
[#35]: https://github.com/fraenki/puppet-proftpd/issues/35
[#33]: https://github.com/fraenki/puppet-proftpd/issues/33
[#32]: https://github.com/fraenki/puppet-proftpd/issues/32
[#31]: https://github.com/fraenki/puppet-proftpd/issues/31
[#29]: https://github.com/fraenki/puppet-proftpd/issues/29
[#28]: https://github.com/fraenki/puppet-proftpd/issues/28
[#26]: https://github.com/fraenki/puppet-proftpd/issues/26
