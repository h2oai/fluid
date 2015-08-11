editor = null
hasLocalStorage = if window.localStorage? then yes else no

rpc = (name, args..., go) ->
  payload = JSON.stringify name: name, args: args
  request = $.post "/rpc", { request: payload }
  request.done (data, status, xhr) -> go null, data
  request.fail (xhr, status, error) -> go error
  return

_dirty = no
_title = 'Fluid Editor'
markDirty = ->
  unless _dirty
    document.title = "#{_title}*"
    _dirty = yes
  return

markClean = ->
  if _dirty
    document.title = _title
    _dirty = no
  return

autosave = ->
  if hasLocalStorage
    window.localStorage['fluid_buffer'] = editor.getValue()
  return

saveSource = ->
  rpc 'save', editor.getValue(), (error, result) ->
    if error
      console.error error
    else
      markClean()

main = ->
  editor = CodeMirror.fromTextArea document.getElementById('fluid-editor'),
    theme: 'eclipse'
    lineNumbers: yes
    extraKeys:
      'Ctrl-S': saveSource
      'Cmd-S': saveSource

  if hasLocalStorage and buffer = window.localStorage['fluid_buffer']
    editor.setValue buffer

  editor.on 'change', _.debounce autosave, 2000
  editor.on 'change', markDirty

do main
