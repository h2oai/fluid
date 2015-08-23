argv = require('minimist') process.argv.slice 2

path = require 'path'
fs = require 'fs-extra'
fluid = require '../fluid.js'

app_coffee = argv._[0]

console.log fluid._compile fs.readFileSync app_coffee, encoding: 'utf8'

