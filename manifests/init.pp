class install_foxit (
  $installer = $install_foxit::params::installer,
) inherits install_foxit::params {
  include staging

  if $::operatingsystem == 'windows' {

    $exe = inline_template('<%= File.basename(@installer) %>')

    acl { "${staging_windir}/install_foxit/${exe}":
      purge => false,
      permissions => [ { identity => 'Administrators', rights => ['full'] },],
      }

      staging::file { $exe:
        source => $installer,
        }


        package { 'Foxit Reader':
          ensure => installed,
          source => "${staging_windir}\\install_foxit\\${exe}",
          require => [ Staging::File[$exe], Acl["${staging_windir}/install_foxit/${exe}"] ],
          install_options => '/verysilent',
          }
  }
}
