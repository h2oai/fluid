noop = ->
truthy = (a) -> if a then yes else no
falsy = (a) -> if a then no else yes
always = -> yes
never = -> no
_templateOf = (component) -> "#{component._template}-template"
guid = -> _.uniqueId 'fluid-'
free = (entity) -> if entity and _.isFunction entity.dispose then entity.dispose()

clamp = (value, min, max) ->
  if value < min
    min
  else if value > max
    max
  else
    value

add = (container, elements...) ->
  if container
    if (isList container) or (_.isArray container)
      container.push elements...
    else if container.__fluid_list__
      add container.__fluid_list__, elements...
    else if isAtom container
      add container(), elements...
    else
      console.warn 'add: source is not a container'
  else
    console.warn 'add: source is not a container'
  return

_remove = (array, element) ->
  if -1 < index = array.indexOf element
    (array.splice index, 1)[0]
  return

remove = (container, elements...) ->
  if container
    if isList container
      container.removeAll elements
    else if _.isArray container
      for element in elements
        _remove container, element
    else if container.__fluid_list__
      remove container.__fluid_list__, elements...
    else if isAtom container
      remove container(), elements...
    else
      console.warn 'remove: source is not a container'
  else
    console.warn 'remove: source is not a container'
  return

clear = (container) ->
  if container
    if isList container
      container.removeAll()
    else if isAtom container
      container undefined
    else if _.isArray container
      result = container[0...]
      container.length = 0
      result
    else if container.__fluid_list__
      clear container.__fluid_list__
    else if isAtom container
      clear container()
    else
      console.warn 'clear: source is not a container'
  else
    console.warn 'clear: source is not a container'

  return

event = ->
  _bindings = []

  self = (args...) ->
    switch _bindings.length
      when 0
        undefined
      when 1
        _bindings[0].target args...
      else
        _bindings.map (binding) -> binding.target args...

  self.subscribe = (f) ->
    _bindings.push binding = target: f, dispose: -> _remove _bindings, binding
    binding

  self.dispose = ->
    for binding in _bindings[0..]
      binding.dispose()
    _bindings.length = 0
    return

  self.__event__ = yes

  self

isEvent = (a) -> if a?.__event__ then yes else no

atom = (value, equalityComparer) ->
  if arguments.length is 0
    atom undefined, never
  else
    observable = ko.observable value
    observable.equalityComparer = equalityComparer if _.isFunction equalityComparer
    observable

isObservable = ko.isObservable

isAtom = (a) -> (isObservable a) and not _.isFunction a.remove

list = (array=[]) -> ko.observableArray array

isList = (a) -> (isObservable a) and _.isFunction a.remove

length = (a) ->
  if _.isArray
    a.length
  else if isList a
    a().length
  else
    0

isNode = (a) -> (isObservable a) or isEvent a

toAtom = (value) ->
  if isAtom value then value else atom value

toList = (a) ->
  if a
    if isList a
      a
    else if isAtom a
      list a()
    else if _.isArray a
      list a
    else
      list [ a ]
  else
    list()

_bind = (source, f) ->
  if source
    if isNode source
      if _.isFunction f
        source.subscribe f
      else
        console.warn 'bind: target cannot be bound.'
    else if source.__fluid_node__
      _bind source.__fluid_node__, f
    else
      console.warn 'bind: source cannot be bound.'
  else
    console.warn 'bind: source cannot be bound.'

unbind = (bindings) ->
  if _.isArray bindings
    for binding in bindings
      unbind binding
  else
    free bindings
  return

_resolve = (source) ->
  if source
    if _.isFunction source
      source()
    else if isObservable source.__fluid_node__
      source.__fluid_node__()
    else
      console.warn 'cannot resolve source'
      undefined
  else
    console.warn 'cannot resolve source'
    undefined

_apply = (sources, f) ->
  f (sources.map _resolve)...

act = (sources..., f) -> #TODO unused
  _apply sources, f
  sources.map (source) ->
    _bind source, -> _apply sources, f

eventAt0 = (sources) ->
  if sources.length is 1
    source0 = sources[0]
    if isEvent source0
      source0
    else if isEvent source0.__fluid_node__
      source0.__fluid_node__
    else
      undefined
  else
    undefined

bind = (sources..., f) ->
  if evt = eventAt0 sources
    _bind evt, f
  else
    sources.map (source) ->
      _bind source, -> _apply sources, f

to = (target, sources..., f) ->
  evaluate = -> _apply sources, f
  target evaluate()
  sources.map (source) ->
    _bind source, -> target evaluate()

from = (sources..., f) ->
  evaluate = -> _apply sources, f
  target = atom evaluate()
  sources.map (source) ->
    _bind source, -> target evaluate()
  target

#
# Controls
#

_untitledCounter = 0
untitled = -> "Untitled#{++_untitledCounter}"

extend = (f, opts) ->
  if _.isFunction f
    (opts2) ->
      f if opts2 then _.extend {}, opts, opts2 else opts
  else
    console.warn 'extend: argument 1 is not a function'
    noop

Header = (opts={}) ->
  links = toList opts.links
  _hasLinks = from links, length

  {
    links, _hasLinks
  }

Footer = (opts={}) ->
  text = toAtom opts.text or untitled()
  links = toList opts.links
  visible = toAtom opts.visible ? yes
  _hasText = from text, truthy
  _hasLinks = from links, length

  {
    text, links, visible, _hasText, _hasLinks
  }

Page = (opts={}) ->
  id = guid()
  isActive = atom opts.isActive ? no
  label = toAtom opts.label or untitled()
  contents = toList opts.contents
  load = -> fluid.context.activatePage id

  {
    id, label, contents, load, isActive, _templateOf
    __fluid_list__: contents
  }

Grid = (opts={}) ->
  contents = toList opts.contents

  {
    contents, _templateOf
    __fluid_list__: contents
    _template: 'grid'
  }

Cell = (opts={}) ->
  span = clamp opts.span ? 12, 1, 12
  contents = toList opts.contents

  {
    contents, _templateOf
    __fluid_list__: contents
    _template: "cell-#{span}"
  }

Cell_ = (span) -> extend Cell, span: span

Card = (opts={}) ->
  contents = toList if _.isString opts.contents then [ Text opts.contents ] else opts.contents
  title = toAtom opts.title ? ''
  _hasTitle = from title, truthy
  buttons = toList opts.buttons ? []
  _hasButtons = from buttons, length
  menu = toAtom opts.menu

  {
    _hasTitle, title, contents, _hasButtons, buttons, menu, _templateOf
    __fluid_list__: contents
    _template: 'card'
  }

Tab = (opts={}) ->
  id = guid()
  address = "##{id}"
  label = toAtom opts.label or untitled()
  contents = toList if _.isString opts.contents then [ Text opts.contents ] else opts.contents
  {
    id, address, label, contents, _templateOf
    _isActive: no
  }

Tabs = (opts={}) ->
  tabs = toList opts.tabs

  # HACK
  for item, i in tabs()
    item._isActive = i is 0

  {
    tabs
    _template: 'tabs'
  }

Markup = (_html, opts={}) ->
  #TODO support bare: yes/no (use spans for bare)
  id = opts.id ? guid()
  html = toAtom _html
  {
    id, html
    _template: 'html'
  }

Text = (_text, opts={}) ->
  Markup _.escape(_text), opts

Markdown = (_value, opts={}) ->
  #TODO support bare: yes/no (use spans for bare)
  id = opts.id ? guid()
  value = toAtom _value
  html = from value, window.marked
  {
    id, value, html
    _template: 'html'
  }

Menu = (opts={}) ->
  id = opts.id ? guid()
  commands = toList opts.commands
  #TODO support opt.icon
  {
    id, commands
    __fluid_list__: commands
    _template: 'none'
  }

Command = (opts={}) ->
  label = toAtom opts.label or untitled()
  disabled = toAtom opts.disabled ? no
  if isEvent opts.clicked
    clicked = opts.clicked
  else
    clicked = do event
    bind clicked, opts.clicked if _.isFunction opts.clicked

  dispose = -> free clicked

  {
    label, clicked, disabled, dispose
    __fluid_node__: clicked
    _template: 'command'
  }

Button = (opts={}) ->
  label = toAtom opts.label or untitled()
  disabled = toAtom opts.disabled ? no
  if isEvent opts.clicked
    clicked = opts.clicked
  else
    clicked = do event
    bind clicked, opts.clicked if _.isFunction opts.clicked

  _primary = opts.color is 'primary'
  _accent = opts.color is 'accent'

  dispose = -> free clicked

  {
    #TODO id
    label, clicked, disabled, dispose
    _primary, _accent
    __fluid_node__: clicked
    _template: 'button'
  }

Link = (opts={}) ->
  label = toAtom opts.label or untitled()
  address = toAtom opts.address or '#'
  {
    #TODO id
    label, address
    _class: ''
    _template: 'link'
  }

Textfield = (opts={}) ->
  id = guid()
  value = toAtom opts.value or ''
  label = toAtom opts.label ? ''
  {
    id, label, value
    __fluid_node__: value
    _template: 'textfield'
  }

Context = ->
  activatePage: do event
  showDrawer: do event
  hideDrawer: do event

Application = ->
  title = atom ''
  loaded = do event

  page0 = Page isActive: yes
  pages = list [ page0 ]
  page = atom page0

  bind fluid.context.activatePage, (id) ->
    target = null
    for p in pages()
      if p.id is id
        p.isActive yes
        target = p
      else
        p.isActive no
    page target 
    fluid.context.hideDrawer()
    return

  header = Header
    links: [
      Link 'Help', address: 'http://example.com/help'
    ]

  footer = Footer
    text: fluid.version
    links: [
      Link 'Source', address: 'https://github.com/h2oai/fluid'
      Link 'H2O.ai', address: 'http://h2o.ai/'
    ]

  bind title, (title) -> document.title = title

  {
    title, header, page, pages, footer, _templateOf
    loaded
    __fluid_list__: pages
  }

#
# Upgrades DOM element to MDL component.
# e.g. data-binding="mdl:true"
#
ko.bindingHandlers.mdl =
  init: (element, valueAccessor, allBindings, viewModel, bindingContext) ->

    # This will be called when the binding is first applied to an element
    # Set up any initial state, event handlers, etc. here

    componentHandler.upgradeElement element
    ko.utils.domNodeDisposal.addDisposeCallback element, ->
      #TODO does this leak if skipped?
      componentHandler.downgradeElements element
    return

ko.bindingHandlers.mdlu =
  update: (element, valueAccessor, allBindings, viewModel, bindingContext) ->

    # This will be called once when the binding is first applied to an element,
    # and again whenever any observables/computeds that are accessed change
    # Update the DOM element based on the supplied values here.

    componentHandler.upgradeElement element
    ko.utils.domNodeDisposal.addDisposeCallback element, ->
      #TODO does this leak if skipped?
      componentHandler.downgradeElements element
    return

preload = ->
  $drawer = $ '#fluid-drawer'
  bind fluid.context.showDrawer, -> $drawer.addClass 'is-visible'
  bind fluid.context.hideDrawer, -> $drawer.removeClass 'is-visible'

start = (init) ->
  fluid.context = context = do Context
  fluid.app = app = do Application
  init context, app
  ko.applyBindings app
  preload()
  app.loaded()

window.fluid = fluid = {
  version: 'Fluid 0.0.1'

  # Available after app start (mutable, for testability)
  app: null
  context: null

  start

  add, remove, clear
  event, isEvent, atom, isAtom, list, isList, length, bind, unbind, to, from
  extend

  # components
  page: Page
  grid: Grid
  cell1: Cell_ 1
  cell2: Cell_ 2
  cell3: Cell_ 3
  cell4: Cell_ 4
  cell5: Cell_ 5
  cell6: Cell_ 6
  cell7: Cell_ 7
  cell8: Cell_ 8
  cell9: Cell_ 9
  cell10: Cell_ 10
  cell11: Cell_ 11
  cell12: Cell
  cell: Cell
  card: Card
  text: Text
  tab: Tab
  tabs: Tabs
  markup: Markup
  markdown: Markdown
  menu: Menu
  command: Command
  button: Button
  link: Link
  textfield: Textfield

  # Exported for testability
  createApplication: Application
  createContext: Context

}
