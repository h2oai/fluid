argv = require('minimist') process.argv.slice 2

path = require 'path'
fs = require 'fs'
fse = require 'fs-extra'
fluid = require '../fluid.js'
_ = require 'lodash'

if argv.verbose
  console.log 'Using opts:'
  console.dir argv

app_coffee = argv._[0]
output_dir = path.dirname app_coffee
app_js = path.join output_dir, path.basename(app_coffee, path.extname(app_coffee)) + '.js'

dist_dir = path.join __dirname, '..', 'dist'

deploy = (name) ->
  file_name = path.join output_dir, name
  console.log "Writing #{file_name}."
  fse.copySync path.join(dist_dir, name), file_name

deploy 'fluid.css'
deploy 'fluid.js'

scripts = argv.script ? []
if not _.isArray scripts then scripts = [ scripts ]

scriptTags = for script in scripts
  "<script src=\"#{script}\"></script>"

stylesheets = argv.stylesheet ? []
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

