fs = require 'fs'
path = require 'path'
express = require 'express'
bodyParser = require 'body-parser'
mkdirp = require 'mkdirp'

fileDir = path.join __dirname, 'files'
getAbsolutePath = (location, go) ->
  # fail if location lies outside ./files
  relativePath = path.relative fileDir, path.join fileDir, location
  if 0 is relativePath.indexOf '.'
    go new Error 'Permission denied'
  else
    go null, path.join fileDir, relativePath

collectFiles = (entries, dir) ->
  for name in fs.readdirSync dir when 0 isnt name.indexOf '.'
    subpath = path.join dir, name
    if fs.statSync(subpath).isDirectory() 
      collectFiles entries, subpath
    else
      if '.gl' is path.extname name
        entries.push subpath
  entries

list = (go) ->
  relativePaths = for absolutePath in collectFiles [], fileDir
    path.relative fileDir, absolutePath
  go null, relativePaths

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

save = (location, contents, go) -> 
  getAbsolutePath location, (error, absolutePath) ->
    if error
      go error
    else
      mkdirp (path.dirname absolutePath), (error) ->
        if error
          go error
        else
          fs.writeFile absolutePath, contents, (error) ->
            if error
              go error
            else
              go null, 'OK'

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

main process.env.PORT ? 2999

