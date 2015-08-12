editor = null
hasLocalStorage = if window.localStorage? then yes else no

rpc = (name, args..., go) ->
  payload = JSON.stringify name: name, args: args
  request = $.post "/rpc", request: payload
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

initSnippets = ->
  allSnippets = window.fluidSnippets

  lowerCaseSnippets = for snippet in allSnippets
    snippet.toLowerCase()

  snippetEls = allSnippets.map (snippet) ->
    pre = document.createElement 'pre'
    pre.textContent = _.escape snippet
    pre.addEventListener 'click', ->
      editor.replaceSelection '\n' + snippet + '\n'
    pre

  snippetsEl = document.getElementById 'fluid-snippets'
  for el in snippetEls
    snippetsEl.appendChild el

  onSearch = (value) -> 
    value = value.trim().toLowerCase()
    if value
      for el, i in snippetEls
        el.style.display = if 0 <= lowerCaseSnippets[i].indexOf value then 'block' else 'none'
    else
      for el, i in snippetEls
        el.style.display = 'block'
    return

  onSearch_throttled = _.throttle onSearch, 1000
  $search = $ '#search'
  $search.on 'input', -> onSearch_throttled $search.val()

  $sidebar = $ '#fluid-sidebar'
  $showSnippets = $ '#show-snippets'
  $showSnippets.click -> $sidebar.show()
  $hideSnippets = $ '#hide-snippets'
  $hideSnippets.click -> $sidebar.hide()

initEditor = ->
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

main = ->
  do initEditor 
  do initSnippets

do main
