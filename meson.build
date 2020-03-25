project('coach', 'vala', 'c')

executable(
    meson.project_name(),
    'main.vala',
    'root_window.vala',
    'task.vala',
    import('gnome').compile_resources('main', 'gresource.xml'),
    dependencies: [
        dependency('glib-2.0', version: '>=2.38'),
        dependency('gtk+-3.0'),
        dependency('gee-0.8'),
        meson.get_compiler('c').find_library('m'),
    ])
