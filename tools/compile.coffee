argv = require('minimist') process.argv.slice 2
path = require 'path'
fs = require 'fs'
fse = require 'fs-extra'
fluid = require '../fluid.js'
_ = require 'lodash'

if argv.compile
  app_coffee = if _.isArray argv.compile
    argv.compile[0]
  else
    argv.compile
else
  console.log """
  Usage: fluid [options] --compile app.coffee

  Options:
    --compile      compile to HTML, JavaScript and CSS
    --help         display this help message
    --include-css  include a CSS file in index.html
    --include-js   include a JavaScript file in index.html
    --watch        watch for changes and recompile

  Examples:
    fluid --compile app.coffee
    fluid --compile app.coffee --include-js foo.js
    fluid --compile app.coffee --include-js foo.js --include-js bar.js
    fluid --compile app.coffee --include-js foo.js --include-css baz.css
    fluid --compile app.coffee --include-js foo.js --include-css baz.css --watch
  """
  process.exit 1

if argv.verbose
  console.log 'Using opts:'
  console.dir argv

output_dir = path.dirname app_coffee
app_js = path.join output_dir, path.basename(app_coffee, path.extname(app_coffee)) + '.js'

dist_dir = path.join __dirname, '..', 'dist'

deploy = (name) ->
  file_name = path.join output_dir, name
  console.log "Writing #{file_name}."
  fse.copySync path.join(dist_dir, name), file_name

deploy 'fluid.css'
deploy 'fluid.js'

scripts = argv['include-js'] ? []
if not _.isArray scripts then scripts = [ scripts ]

scriptTags = for script in scripts
  "<script src=\"#{script}\"></script>"

stylesheets = argv['include-css'] ? []
if not _.isArray stylesheets then stylesheets = [ stylesheets ]

stylesheetTags = for stylesheet in stylesheets
  "<link href=\"#{stylesheet}\" rel=\"stylesheet\" type=\"text/css\">"

html = fse.readFileSync path.join(dist_dir, 'index.html'), encoding: 'utf8'
html = html.replace '<!--fluid_styles-->', stylesheetTags.join ''
html = html.replace '<!--fluid_scripts-->', scriptTags.join ''

index_html = path.join output_dir, 'index.html'
console.log "Writing #{index_html}."
fse.writeFileSync index_html, html, encoding: 'utf8'

recompile = ->
  js = fluid._compile fse.readFileSync app_coffee, encoding: 'utf8'
  console.log "Writing #{app_js}."
  fse.writeFileSync app_js, js, encoding: 'utf8'

do recompile

if argv.watch
  console.log "Watching #{app_coffee}..."
  fs.watchFile app_coffee, recompile

