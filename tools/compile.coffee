argv = require('minimist') process.argv.slice 2

path = require 'path'
fs = require 'fs'
fse = require 'fs-extra'
fluid = require '../fluid.js'
_ = require 'lodash'

app_coffee = argv._[0]

js = fluid._compile fse.readFileSync app_coffee, encoding: 'utf8'

output_dir = path.dirname app_coffee
app_js = path.join output_dir, path.basename(app_coffee, path.extname(app_coffee)) + '.js'

fse.writeFileSync app_js, js, encoding: 'utf8'

dist_dir = path.join __dirname, '..', 'dist'

deploy = (name) ->
  fse.copySync path.join(dist_dir, name), path.join(output_dir, name)

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

fse.writeFileSync path.join(output_dir, 'index.html'), html, encoding: 'utf8'
