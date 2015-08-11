editor = null
hasLocalStorage = if window.localStorage? then yes else no

autosave = ->
  if hasLocalStorage
    window.localStorage['fluid_buffer'] = editor.getValue()
  console.log 'autosaved'
  return

saveSource = ->
  console.log editor.getValue()

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

do main
