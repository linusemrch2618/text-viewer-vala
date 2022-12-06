project('text-viewer', ['c', 'vala'],
          version: '0.1.1',
          license: 'GPLv3+',
    meson_version: '>= 0.59.0',
  default_options: [ 'warning_level=2', 'werror=false', ],
)

gnome = import('gnome')
i18n = import('i18n')

conf = configuration_data ()
conf.set_quoted ('VERSION', '@0@-@VCS_TAG@'.format (meson.project_version()))
conf.set('PACKAGE_URL', '"https://github.com/linusemrch2618/text-viewer-vala"')

config_h = declare_dependency (
  sources: vcs_tag (
    command: ['git', 'rev-parse', '--short', 'HEAD'],
    input: configure_file (
      output: 'config.h.in',
      configuration: conf
    ),
    output: 'config.h'
  )
)
config_h_dir = include_directories ('.')

subdir('data')
subdir('src')
subdir('po')

gnome.post_install(
     glib_compile_schemas: true,
    gtk_update_icon_cache: true,
  update_desktop_database: true,
)
