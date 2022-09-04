text_viewer_sources = [
  'application.vala',
  'config.vapi',
  'main.vala',
  'window.vala',
]

text_viewer_deps = [
  dependency('libadwaita-1', version: '>= 1.0'),
]

gnome = import('gnome')

text_viewer_sources += gnome.compile_resources('text_viewer-resources',
  'text_viewer.gresource.xml',
  c_name: 'text_viewer'
)

executable('text-viewer', text_viewer_sources,
  include_directories: config_h_dir, vala_args: '--target-glib=2.50',
  dependencies: text_viewer_deps, install: true,
)
