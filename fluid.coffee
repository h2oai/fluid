noop = ->
truthy = (a) -> if a then yes else no
falsy = (a) -> if a then no else yes
always = -> yes
never = -> no
_templateOf = (component) -> "#{component._template}-template"
guid = -> _.uniqueId 'fluid-'
hashcode = (obj) ->
  if obj
    if hash = obj.__fluid_hash__
      hash
    else
      obj.__fluid_hash__ = guid()
  else
    guid()
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
    else if (isComponent container) and container.items
      add container.items, elements...
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
    else if (isComponent container) and container.items
      remove container.items, elements...
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
    else if (isComponent container) and container.items
      clear container.items
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

toEvent = (f) ->
  if isEvent f
    f
  else
    e = do event
    bind e, f if _.isFunction f
    e

_bind = (source, f) ->
  if source
    if isNode source
      if _.isFunction f
        source.subscribe f
      else
        console.warn 'bind: target cannot be bound.'
    else if isComponent source
      if source.fire
        _bind source.fire, f
      else if source.value
        _bind source.value, f
      else if source.items
        _bind source.items, f
      else
        console.warn 'bind: source cannot be bound.'
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
    else if isComponent source
      if source.value
        source.value()
      else if source.items
        source.items()
      else
        console.warn 'cannot resolve source'
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
    else if (isComponent source0) and isEvent source0.fire
      source0.fire
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

_get = (source) ->
  if source
    if isComponent source
      if source.value
        _get source.value
      else if source.items
        _get source.items
      else
        undefined
    else if isObservable source
      _get source() # recurse to get at nested nodes
    else
      source
  else
    source

_set = (source, value) ->
  if source
    if isComponent source
      if source.value
        _set source.value, value
      else if source.items
        _set source.items, value
      else
        undefined
    else if isObservable source
      source value
    else
      undefined
  else
    undefined

__fire = (source, args) ->
  if source
    if isComponent source
      if source.fire
        _fire source.fire, args
      else
        undefined
    else if isEvent source
      source args...
    else
      undefined
  else
    undefined

_fire = (source, args...) -> __fire source, args

#
# Controls
#

_untitledCounter = 0
untitled = -> "Untitled#{++_untitledCounter}"

extend = (f, opts) ->
  if _.isFunction f
    (args...) ->
      f args.concat(opts)...
  else
    console.warn 'extend: argument 1 is not a function'
    noop

isComponent = (a) -> if a?.__fluid_component__ then yes else no

Component = (f) ->
  (args...) ->
    opts = {}
    for arg in args
      if isComponent arg
        opts.value = arg
      else if isObservable arg
        opts.value = arg
      else if _.isArray arg
        # noop
      else if _.isString arg
        opts.value = arg
      else if _.isObject arg
        for key, value of arg
          opts[key] = value
      else
        opts.value = arg

    self = f opts
    self.__fluid_component__ = yes
    self

Container = (f) ->
  (args...) ->
    items = []
    opts = { items }
    for arg in args
      if isComponent arg
        items.push arg
      else if _.isArray arg
        for value in arg
          items.push value
      else if _.isString arg
        items.push Text arg
      else if _.isObject arg
        for key, value of arg when key isnt 'items'
          opts[key] = value
      else
        items.push String arg

    self = f opts
    self.__fluid_component__ = yes
    self

Header = Component (opts) ->
  links = toList opts.links
  _hasLinks = from links, length

  {
    links, _hasLinks
  }

Footer = Component (opts) ->
  text = toAtom opts.text or untitled()
  links = toList opts.links
  visible = toAtom opts.visible ? yes
  _hasText = from text, truthy
  _hasLinks = from links, length

  {
    text, links, visible, _hasText, _hasLinks
  }

Page = Container (opts) ->
  id = guid()
  isActive = atom opts.isActive ? no
  label = toAtom opts.label or untitled()
  items = toList opts.items
  load = -> fluid.context.activatePage id

  {
    id, label, items, load, isActive, _templateOf
  }

Grid = Container (opts) ->
  items = toList opts.items

  {
    items, _templateOf
    _template: 'grid'
  }

Cell = (span) -> 
  Container (opts) ->
    items = toList opts.items

    {
      items, _templateOf
      _template: "cell-#{span}"
    }

Card = Container (opts) ->
  items = toList opts.items
  title = toAtom opts.title ? ''
  _hasTitle = from title, truthy
  buttons = toList opts.buttons ? []
  _hasButtons = from buttons, length
  menu = toAtom opts.menu

  {
    _hasTitle, title, items, _hasButtons, buttons, menu, _templateOf
    _template: 'card'
  }

Tab = Container (opts) ->
  id = guid()
  address = "##{id}"
  label = toAtom opts.label or untitled()
  items = toList opts.items
  {
    id, address, label, items, _templateOf
    _isActive: no
  }

Tabs = Container (opts) ->
  items = toList opts.items

  # HACK
  for item, i in items()
    item._isActive = i is 0

  {
    items
    _template: 'tabs'
  }


Markup = Component (opts) ->
  #TODO support bare: yes/no (use spans for bare)
  id = opts.id ? guid()
  value = html = toAtom opts.value
  {
    id, value, html
    _template: 'html'
  }

Text = Component (opts) ->
  #TODO support bare: yes/no (use spans for bare)
  id = opts.id ? guid()
  value = toAtom opts.value
  html = from value, _.escape
  {
    id, value, html
    _template: 'html'
  }

Markdown = Component (opts) ->
  #TODO support bare: yes/no (use spans for bare)
  id = opts.id ? guid()
  value = toAtom opts.value
  html = from value, window.marked
  {
    id, value, html
    _template: 'html'
  }

Menu = Container (opts) ->
  id = opts.id ? guid()
  items = toList opts.items
  #TODO support opt.icon
  {
    id, items
    _template: 'none'
  }

Command = Component (opts) ->
  label = value = toAtom opts.value or untitled()
  disabled = toAtom opts.disabled ? no
  clicked = fire = toEvent opts.clicked

  dispose = -> free clicked

  {
    label, value, fire, clicked, disabled, dispose
    _template: 'command'
  }

Button = Component (opts) ->
  label = value = toAtom opts.value or untitled()
  disabled = toAtom opts.disabled ? no
  clicked = fire = toEvent opts.clicked

  _primary = opts.color is 'primary'
  _accent = opts.color is 'accent'

  dispose = -> free clicked

  {
    #TODO id
    label, value, fire, clicked, disabled, dispose
    _primary, _accent
    _template: 'button'
  }

Link = Component (opts) ->
  label = value = toAtom opts.value or untitled()
  address = toAtom opts.address or 'http://example.com/'
  {
    #TODO id
    label, value, address
    _class: ''
    _template: 'link'
  }

Textfield = Component (opts) ->
  id = guid()
  value = toAtom opts.value ? ''
  label = toAtom opts.label ? ''
  {
    id, label, value
    _template: 'textfield'
  }

Checkbox = Component (opts) ->
  id = guid()
  checked = value = toAtom opts.value ? no
  label = toAtom opts.label or untitled()
  icon = opts.icon or null

  _template = if icon
    if icon is 'switch'
      icon
    else
      'icon-toggle'
  else
    'checkbox'

  {
    id, label, value, checked, icon
    _template
  }

Radio = Component (opts) ->
  id = guid()
  item = opts.item ? guid()
  label = toAtom opts.label or untitled()
  value = if isAtom opts.value
    opts.value
  else
    console.warn 'radio: expected value to be atom'
    atom item

  group = hashcode value

  {
    id, group, item, value, label
    _template: 'radio'
  }


Context = ->
  activatePage: do event
  showDrawer: do event
  hideDrawer: do event

Application = ->
  title = atom ''
  loaded = do event

  page0 = Page isActive: yes
  pages = items = list [ page0 ]
  page = atom page0

  bind fluid.context.activatePage, (id) ->
    target = null
    for item in pages()
      if item.id is id
        item.isActive yes
        target = item
      else
        item.isActive no
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
    title, header, items, page, pages, footer, _templateOf
    loaded
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

  get: _get, set: _set, fire: _fire
  add, remove, clear

  event, isEvent, atom, isAtom, list, isList, length, bind, unbind, to, from
  extend

  # components
  page: Page
  grid: Grid
  cell1: Cell 1
  cell2: Cell 2
  cell3: Cell 3
  cell4: Cell 4
  cell5: Cell 5
  cell6: Cell 6
  cell7: Cell 7
  cell8: Cell 8
  cell9: Cell 9
  cell10: Cell 10
  cell11: Cell 11
  cell12: Cell 12
  cell: Cell 12
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
  checkbox: Checkbox
  radio: Radio


  # Exported for testability
  createApplication: Application
  createContext: Context

}
