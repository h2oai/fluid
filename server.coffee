fs = require 'fs'
path = require 'path'
express = require 'express'
bodyParser = require 'body-parser'
mkdirp = require 'mkdirp'
fluid = require './prototype/fluid.coffee'
coffee = require 'coffee-script'

prelude = "{ #{ fluid._symbols().join ', ' } } = window.fluid\nwindow.fluid._start (context, app, home) ->\n"

appCoffee = path.join __dirname, 'prototype', 'app.coffee'
appJs = path.join __dirname, 'prototype', 'app.js'

#FIXME
getAbsolutePath = (location, go) ->
  # fail if location lies outside ./files
  relativePath = path.relative fileDir, path.join fileDir, location
  if 0 is relativePath.indexOf '.'
    go new Error 'Permission denied'
  else
    go null, path.join fileDir, relativePath

#FIXME
collectFiles = (entries, dir) ->
  for name in fs.readdirSync dir when 0 isnt name.indexOf '.'
    subpath = path.join dir, name
    if fs.statSync(subpath).isDirectory() 
      collectFiles entries, subpath
    else
      if '.gl' is path.extname name
        entries.push subpath
  entries

#FIXME
list = (go) ->
  relativePaths = for absolutePath in collectFiles [], fileDir
    path.relative fileDir, absolutePath
  go null, relativePaths

#FIXME
load = (location, go) -> 
  getAbsolutePath location, (error, absolutePath) ->
    if error
      go error
    else
      fs.readFile absolutePath, { encoding: 'utf-8' }, (error, data) ->
        if error
          go error
        else
          go null, data

wrap = (contents) ->
  prelude + contents
    .split /\n/
    .map (a) -> '  ' + a
    .join "\n"

save = (contents, go) -> 
  try
    js = coffee.compile wrap contents
    fs.writeFile appCoffee, contents, (error) ->
      if error
        go error
      else
        fs.writeFile appJs, js, (error) ->
          if error
            go error
          else
            go null, 'OK'
  catch error
    go error

methods = { list, save, load }

rpc = (req, res) ->
  fail = (status, message) ->
    res.status status
    res.send message

  unless request = req.body?.request
    return fail 400, 'Missing RPC request'

  try
    { name, args } = JSON.parse request
  catch error
    return fail 400, 'Could not parse RPC request'

  unless method = methods[name]
    return fail 400, 'No such method'
  
  unless args
    return fail 400, 'No arguments specified'

  if method.length isnt args.length + 1
    return fail 400, 'Wrong number of arguments'
  
  args.push (error, result) ->
    if error
      console.log error
      fail 500, error.message
    else
      res.json result: result

  try
    method.apply null, args
  catch error
    console.error error
    fail 500, error.message

main = (port) ->
  app = express()

  app.use bodyParser.urlencoded extended: no
  app.use bodyParser.json()
  app.use '/rpc', express.Router()
    .route '/*'
    .post rpc
  app.use express.static __dirname

  app.listen port

main process.env.PORT ? 8080

