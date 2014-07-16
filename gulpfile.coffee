#-----------------------------------------------------------------
# Setup
#-----------------------------------------------------------------

server      = false
fs          = require('fs')
gulp        = require('gulp')
plugins     = require('gulp-load-plugins')()
paths       =
  styles: './src/assets/styles/index.styl'
  scripts: './src/assets/scripts/main.coffee'
  images: './src/assets/images/**/*.{png,gif,jpeg,jpg}'
  templates: './src/**/*.jade'


#-----------------------------------------------------------------
# Defaults
#-----------------------------------------------------------------

gulp.task('default', ['images', 'scripts', 'styles', 'templates'])


#-----------------------------------------------------------------
# Watch
#-----------------------------------------------------------------

gulp.task 'watch', () ->
  server = plugins.livereload()
  gulp.watch(paths.styles, ['styles'])
  gulp.watch(paths.scripts, ['scripts'])
  gulp.watch(paths.images, ['images'])
  gulp.watch(paths.templates, ['templates'])


#-----------------------------------------------------------------
# Clean
#-----------------------------------------------------------------

gulp.task 'clean', () ->
  gulp.src('./public/', force: true )
    .pipe(plugins.clean())


#-----------------------------------------------------------------
# Styles
#-----------------------------------------------------------------

gulp.task 'styles', () ->

  gulp.src(paths.styles)
    .pipe(plugins.stylus(
      use: [require('nib')()]
    ))
    .pipe(plugins.rename('main.min.css'))
    .pipe(gulp.dest('./public/assets/styles/'))

  # LiveReload
  server.changed('./public/assets/styles/main.min.css') if server


#-----------------------------------------------------------------
# Scripts
#-----------------------------------------------------------------

gulp.task 'scripts', () ->

  bowerfiles = require('main-bower-files')
  es = require('event-stream')

  gulp.src(bowerfiles())
    .pipe(plugins.concat('libs.min.js'))
    .pipe(gulp.dest('./public/assets/scripts/'))

  gulp.src(paths.scripts).pipe(plugins.coffee( bare: true ))
    .pipe(plugins.concat('main.min.js'))
    .pipe(gulp.dest('./public/assets/scripts/'))

  # LiveReload
  server.changed('./public/assets/styles/libs.min.js') if server
  server.changed('./public/assets/styles/main.min.js') if server


#-----------------------------------------------------------------
# Images
#-----------------------------------------------------------------

gulp.task 'images', () ->

  gulp.src('./public/assets/images/')
    .pipe(plugins.imagemin())
    .pipe(gulp.dest('./public/assets/images/'))


#-----------------------------------------------------------------
# Templates
#-----------------------------------------------------------------

gulp.task 'templates', () ->

  gulp.src(paths.templates)
    .pipe(plugins.jade( pretty: true ))
    .pipe(gulp.dest('./public/'))

  server.changed('./public/**/*.html') if server

