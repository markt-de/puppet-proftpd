require 'spec_helper_acceptance'

describe 'proftpd class' do
  context 'default parameters' do
    it 'is expected to work idempotently with no errors' do
      pp = <<-EOS
      if $facts['os']['family'] == 'RedHat' {
        yumrepo { 'epel':
          name       => 'epel',
          descr      => 'Extra Packages for Enterprise Linux $releasever - $basearch',
          ensure     => 'present',
          enabled    => 1,
          gpgcheck   => 1,
          metalink   => 'https://mirrors.fedoraproject.org/metalink?repo=epel-$releasever&arch=$basearch&infra=$infra&content=$contentdir',
          mirrorlist => 'absent',
          gpgkey     => "http://ftp.fau.de/epel/RPM-GPG-KEY-EPEL-${facts['os']['release']['major']}",
        }
      }
      class { 'proftpd': }
      EOS
      # Run it twice and test for idempotency
      idempotent_apply(pp)
    end
  end
end
