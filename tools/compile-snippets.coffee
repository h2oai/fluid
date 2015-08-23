fs = require 'fs'
path = require 'path'

snippetsCoffee = path.join __dirname, '..', 'snippets.coffee'
snippetsJs = path.join __dirname, '..', 'snippets.js'

data = fs.readFileSync snippetsCoffee, encoding: 'utf-8'
snippets = data
  .split /#[-]{3,}/g
  .map (a) -> a.trim()
  .filter (a) -> if a then yes else no

fs.writeFileSync snippetsJs, "window.fluidSnippets = #{JSON.stringify snippets, null, 2};"

