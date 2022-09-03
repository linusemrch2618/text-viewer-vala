text_viewer_sources = [
  'main.vala',
  'window.vala',
  'application.vala',
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
  vala_args: '--target-glib=2.50',  dependencies: text_viewer_deps,
  install: true,
)
