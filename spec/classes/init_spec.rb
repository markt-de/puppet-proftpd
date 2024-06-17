# ex: syntax=ruby ts=2 sw=2 si et
require 'spec_helper'

describe 'proftpd' do
  on_supported_os.each do |os, facts|
    case facts[:os]['family']
    when 'Debian'
      expected_config         = '/etc/proftpd/proftpd.conf'
      expected_base_dir       = '/etc/proftpd'
      expected_log_dir        = '/var/log/proftpd'
      expected_run_dir        = '/var/run/proftpd'
      expected_packages       = if facts[:os]['distro']['codename'] == 'bullseye'
                                  ['proftpd-core']
                                else
                                  ['proftpd-basic']
                                end
      expected_service_name   = 'proftpd'
    when 'RedHat'
      expected_config         = '/etc/proftpd.conf'
      expected_base_dir       = '/etc/proftpd'
      expected_log_dir        = '/var/log/proftpd'
      expected_run_dir        = '/var/run/proftpd'
      expected_packages       = ['proftpd']
      expected_service_name   = 'proftpd'
    when 'FreeBSD'
      prefix                  = '/usr/local'
      expected_config         = "#{prefix}/etc/proftpd.conf"
      expected_base_dir       = "#{prefix}/etc/proftpd"
      expected_log_dir        = '/var/log/proftpd'
      expected_run_dir        = '/var/run/proftpd'
      expected_packages       = ['ftp/proftpd']
      expected_service_name   = 'proftpd'
    end
    context "on #{os}" do
      let(:facts) { facts }

      context 'with defaults parameters' do
        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('proftpd') }
        it { is_expected.to contain_class('proftpd::install') }
        it { is_expected.to contain_class('proftpd::config') }
        it { is_expected.to contain_class('proftpd::service') }
        it { is_expected.to contain_file(expected_base_dir) }
        it { is_expected.to contain_file(expected_config) }
        it { is_expected.to contain_file(expected_run_dir) }
        it { is_expected.to contain_file(expected_log_dir) }
        it { is_expected.to contain_package(expected_packages.first) }
        it { is_expected.to contain_service(expected_service_name) }
        it { is_expected.to contain_concat("#{expected_base_dir}/modules.conf") }
      end
      context 'with manage_ftpasswd_file set to true' do
        let(:params) do
          {
            manage_ftpasswd_file: true,
            ftpasswd_file: '/etc/proftpd/my_custom_ftpasswd',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_concat("#{expected_base_dir}/my_custom_ftpasswd") }
      end
    end
  end
end
