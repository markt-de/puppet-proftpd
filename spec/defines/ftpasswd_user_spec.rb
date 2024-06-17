require 'spec_helper'

describe 'proftpd::ftpasswd_user' do
  let(:pre_condition) do
    "class { '::proftpd':
       manage_ftpasswd_file => true,
     }
     "
  end

  on_supported_os.each do |os, facts|
    case facts[:os]['family']
    when 'Debian'
      expected_base_dir       = '/etc/proftpd'
      expected_ftpasswd_file  = "#{expected_base_dir}/ftpd.passwd"
    when 'RedHat'
      expected_base_dir       = '/etc/proftpd'
      expected_ftpasswd_file  = "#{expected_base_dir}/ftpd.passwd"
    when 'FreeBSD'
      prefix                  = '/usr/local'
      expected_base_dir       = "#{prefix}/etc/proftpd"
      expected_ftpasswd_file  = "#{expected_base_dir}/ftpd.passwd"
    end
    context "on #{os}" do
      let(:facts) { facts }
      # Resource title:
      let(:title) { 'foobar' }

      context 'with minimum parameters' do
        let(:params) do
          {
            hashed_passwd: '123456',
            uid: 1001,
            gid: 1001,
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_concat(expected_ftpasswd_file) }
        it do
          is_expected.to contain_concat__fragment('10-entry-foobar')
            .with_content(%r{foobar:123456:1001:1001:foobar:/home/foobar:/bin/false})
        end
      end
      context 'with all parameters' do
        let(:params) do
          {
            hashed_passwd: '123456',
            uid: 1001,
            gid: 1001,
            gecos: 'Foobar user',
            homedir: '/var/www/html',
            shell: '/bin/ksh',
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_concat(expected_ftpasswd_file) }
        it do
          is_expected.to contain_concat__fragment('10-entry-foobar')
            .with_content(%r{foobar:123456:1001:1001:Foobar user:/var/www/html:/bin/ksh})
        end
      end
    end
  end
end
