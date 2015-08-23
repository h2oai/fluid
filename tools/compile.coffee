argv = require('minimist') process.argv.slice 2

path = require 'path'
fs = require 'fs'
fse = require 'fs-extra'
fluid = require '../fluid.js'

app_coffee = argv._[0]

js = fluid._compile fse.readFileSync app_coffee, encoding: 'utf8'

output_dir = path.dirname app_coffee
app_js = path.join output_dir, path.basename(app_coffee, path.extname(app_coffee)) + '.js'

fse.writeFileSync app_js, js, encoding: 'utf8'

dist_dir = path.join __dirname, '..', 'dist'

deploy = (name) ->
  fse.copySync path.join(dist_dir, name), path.join(output_dir, name), clobber: no

deploy 'fluid.css'
deploy 'fluid.js'
deploy 'index.html'

