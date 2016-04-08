
# -----------------------------------------------------------------
#
# Simple HTTP Server, in one line:
# python -m SimpleHTTPServer
#
# -----------------------------------------------------------------

# -----------------------------------------------------------------
#  Setup
# -----------------------------------------------------------------

defaultTasks    = ['scripts', 'styles', 'images', 'templates']
gulp 			      = require('gulp')
uglify          = require('gulp-uglify')
plugins 		    = require('gulp-load-plugins')()
nib             = require('nib')
jeet            = require('jeet')
cleanCSS        = require('gulp-clean-css')

# --------------------------------------
# Handlers
# --------------------------------------

errorHandler = (error) ->
  console.log('Task Error: ', error)

serverHandler = () ->
  console.log('Started Server...')

templateHandler = (error) ->
  console.log('Template Error: ', error) if error

fileHandler = (error) ->
  console.log('File Error: ', error) if error

# -----------------------------------------------------------------
#  Paths
# -----------------------------------------------------------------

paths           =
  src             :
    default       : './src/'
    scripts       : './src/scripts/**/*.coffee'
    styles        : './src/styles/styles.styl'
    images        : './src/images/**/*.{gif,png,jpeg,jpg}'
    templates     : './src/**/*.jade'
    styleLibs     : './node_modules/slick-carousel/slick/slick.css'
    scriptLibs    : ['./node_modules/chart.js/Chart.min.js', './node_modules/slick-carousel/slick/slick.min.js']
    jquery        : './node_modules/jquery/dist/jquery.min.js'
  build           :
    scripts       : './www/scripts/'
    vendor        : './www/scripts/vendor/'
    styles        : './www/styles/'
    images        : './www/images/'
    templates     : './www/'
  watch           :
    scripts       : './src/**/*.{js,coffee}'
    styles        : './src/**/*.styl'
    templates     : './src/**/*.jade'


# -----------------------------------------------------------------
#  Defaults
# -----------------------------------------------------------------

gulp.task('default', defaultTasks)

# --------------------------------------
# Styles  Task
# --------------------------------------

gulp.task 'styles', () ->

  # Define
  main  = gulp.src(paths.src.styles)

  # Create Main
  main
    .pipe(plugins.stylus(use: [
      nib(),
      jeet()
    ]))
    .pipe(cleanCSS())
    .pipe(plugins.rename('main.min.css'))
    .on('error', errorHandler)
    .pipe(gulp.dest(paths.build.styles))

# --------------------------------------
# Style Libraries Task
# --------------------------------------

gulp.task 'styleLibs', () ->

  libs  = gulp.src(paths.src.styleLibs)

  # Create Libs
  libs
    .pipe(cleanCSS())
    .pipe(plugins.rename('libs.min.css'))
    .on('error', errorHandler)
    .pipe(gulp.dest(paths.build.styles))

# --------------------------------------
# Templates Task
# --------------------------------------

gulp.task 'templates', () ->

  gulp.src(paths.src.templates)
    .on('error', errorHandler)
    .pipe(plugins.jade({ pretty: false }))
    .pipe(gulp.dest(paths.build.templates))

# -----------------------------------------------------------------
#  Scripts Task
# -----------------------------------------------------------------

gulp.task 'scripts', () ->

  # Main Scripts
  gulp.src(paths.src.scripts)
    .pipe(plugins.concat('main.min.js'))
    .pipe(plugins.coffee( bare: true ))
    .on('error', errorHandler)
    .pipe(uglify())
    .pipe(gulp.dest(paths.build.scripts))

# --------------------------------------
# Script Libraries Task
# --------------------------------------

gulp.task 'scriptLibs', () ->
  files = paths.src.scriptLibs
  files = files.concat([])

  gulp.src(files)
    .pipe(plugins.concat('libs.min.js'))
    .on('error', errorHandler)
    .pipe(uglify())
    .pipe(gulp.dest(paths.build.scripts))

  #jQuery backup
  gulp.src(paths.src.jquery)
    .pipe(plugins.rename('jquery.js'))
    .pipe(gulp.dest(paths.build.vendor))




# --------------------------------------
# Images Task
# --------------------------------------

gulp.task 'images', () ->

  gulp.src(paths.src.images)
    .pipe(plugins.imagemin())
    .on('error', errorHandler)
    .pipe(gulp.dest(paths.build.images))

# -----------------------------------------------------------------
#  Watch Task
# -----------------------------------------------------------------

gulp.task 'watch', () ->


  # Watch Files & Kick-off Tasks
  gulp.watch(paths.watch.templates, ['templates']).on('error', errorHandler)
  gulp.watch(paths.watch.styles, ['styles']).on('error', errorHandler)
  gulp.watch(paths.watch.scripts, ['scripts']).on('error', errorHandler)
