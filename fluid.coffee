noop = ->
truthy = (a) -> if a then yes else no
falsy = (a) -> if a then no else yes
always = -> yes
never = -> no
px = (value) ->
  if value is 'auto' or value is 'initial' or value is 'inherit'
    value
  else
    "#{value}px"
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
    if elements.length
      if (isList container) or (_.isArray container)
        container.push elements...
      else if (isComponent container) and container.items
        add container.items, elements...
      else if isAtom container
        add container(), elements...
      else
        console.warn 'add: source is not a container'
    else
      console.warn 'add: no elements to add'
  else
    console.warn 'add: source is not a container'
  return

_remove = (array, element) ->
  if -1 < index = array.indexOf element
    (array.splice index, 1)[0]
  return

remove = (container, elements...) ->
  if container
    if elements.length
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
      console.warn 'remove: no elements to remove'
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

action = (opts) ->
  _bindings = []
  _multicast = if opts?.multicast is off then off else on

  self = (args...) ->
    if _bindings.length is 0
      undefined
    else
      if _multicast
        _bindings.map (binding) -> binding.target args...
      else
        _bindings[0].target args...

  self.subscribe = (f) ->
    binding = target: f, dispose: -> _remove _bindings, binding
    if _multicast
      _bindings.push binding
      binding
    else
      if _bindings.length
        console.warn 'action: attempt to rebind unicast action. dropping exsting binding.'
        _bindings[0].dispose()
      _bindings[0] = binding

  self.dispose = ->
    for binding in _bindings[0..]
      binding.dispose()
    _bindings.length = 0
    return

  self.__fluid_action__ = yes

  self

isAction = (a) -> if a?.__fluid_action__ then yes else no

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

isNode = (a) -> (isObservable a) or isAction a

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

toAction = (f) ->
  if isAction f
    f
  else
    e = do action
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

actionAt0 = (sources) ->
  if sources.length is 1
    source0 = sources[0]
    if isAction source0
      source0
    else if (isComponent source0) and isAction source0.fire
      source0.fire
    else
      undefined
  else
    undefined

bind = (sources..., f) ->
  if evt = actionAt0 sources
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
    else if isAction source
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

show = (source) ->
  if (isComponent source) and source.visible
    source.visible yes
  else
    console.warn 'show: source is not a component'
  return

hide = (source) ->
  if (isComponent source) and source.visible
    source.visible no
  else
    console.warn 'hide: source is not a component'
  return


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
      else if _.isFunction arg
        opts.action = arg
      else if _.isObject arg
        for key, value of arg
          opts[key] = value
      else
        opts.value = arg

    self = f opts
    self.__fluid_component__ = yes
    self

Components = (f) ->
  (args...) ->
    items = []
    opts = { items }
    for arg in args
      if isComponent arg
        items.push arg
      else if isList arg
        # Clobber opts.items, which means that everything that went/goes
        #   into `items` is discarded.
        opts.items = arg
      else if _.isArray arg
        for value in arg
          items.push value
      else if _.isString arg
        items.push Text arg
      else if _.isFunction arg
        opts.action = arg
      else if _.isObject arg
        for key, value of arg
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
  buttons = toList opts.buttons

  visible = toAtom opts.visible ? yes
  _hasText = from text, truthy
  _hasLinks = from links, length
  _hasButtons = from buttons, length
  {
    text, links, buttons, visible, _hasText, _hasLinks, _hasButtons
  }

Page = Components (opts) ->
  id = guid()
  isActive = atom opts.isActive ? no
  title = toAtom opts.title or untitled()
  items = toList opts.items
  load = -> fluid.context.activatePage id

  {
    id, title, items, load, isActive, _templateOf
  }

Container = (template) ->
  Components (opts) ->
    items = toList opts.items
    {
      items, _templateOf
      _template: template
    }

Grid = Container 'grid'
Cell = (span) -> Container "cell-#{span}"
Div = Container 'div'
Span = Container 'span'

Thumbnail = Component (opts) ->
  image = value = toAtom opts.value ? opts.image #TODO apply pattern to .value attributes of other components
  title = toAtom opts.title ? ''
  _hasTitle = from title, truthy
  _style =
    width: (opts.width ? 256) + 'px'
    height: (opts.height ? 256)   + 'px'
    background: from image, (url) -> "url('#{url}') center / cover"

  {
    _hasTitle, title, image, value, _style
    _template: 'thumbnail'
  }

Card = Components (opts) ->
  items = toList opts.items
  title = toAtom opts.title ? ''
  _hasTitle = from title, truthy
  buttons = toList opts.buttons ? []
  _hasButtons = from buttons, length
  menu = toAtom opts.menu
  image = toAtom opts.image
  _hasImage = from image, truthy

  _style =
    width: if opts.width? then px opts.width else undefined
    height: if opts.height? then px opts.height else undefined

  _titleStyle =
    background: from image, (url) -> "url('#{url}') center / cover"

  _titleStyle.color = opts.color if opts.color

  {
    _hasTitle, title, items, _hasButtons, buttons, menu, image, _hasImage, _style, _titleStyle, _templateOf
    _template: 'card'
  }

Tab = Components (opts) ->
  id = guid()
  _address = "##{id}"
  title = toAtom opts.title or untitled()
  items = toList opts.items
  {
    id, _address, title, items, _templateOf
    _isActive: no
  }

Tabs = Components (opts) ->
  items = toList opts.items

  # HACK
  for item, i in items()
    item._isActive = i is 0

  {
    items
    _template: 'tabs'
  }

Markup = Component (opts) ->
  id = opts.id ? guid()
  value = html = toAtom opts.value
  {
    id, value, html
    _template: 'html'
  }

Pre = Component (opts) ->
  value = toAtom opts.value
  {
    id, value
    _template: 'pre'
  }

Text = Component (opts) ->
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

TableRow = Components (opts) ->
  items = opts.items
  {
    items
  }

TableDataCell = Component (opts) ->
  value = opts.value
  _isNonNumeric = if opts.align?
    opts.align is 'left'
  else
    not _.isNumber value
  {
    value, _isNonNumeric
  }

Table = Components (opts) ->
  items = toList opts.items
  selectable = opts.selectable ? no
  _headers = items.shift()
  {
    _headers, items, selectable
    _template: 'table'
  }

Menu = Components (opts) ->
  id = opts.id ? guid()
  items = toList opts.items
  icon = opts.icon ? 'more_vert'
  {
    id, items, icon
    _template: 'none'
  }

Command = Component (opts) ->
  title = value = toAtom opts.value or untitled()
  disabled = toAtom opts.disabled ? no
  clicked = fire = toAction opts.clicked ? opts.action

  dispose = -> free clicked

  {
    title, value, fire, clicked, disabled, dispose
    _template: 'command'
  }

Button = Component (opts) ->
  title = value = toAtom opts.value or untitled()
  disabled = toAtom opts.disabled ? no
  clicked = fire = toAction opts.clicked ? opts.action
  dispose = -> free clicked

  icon = opts.icon

  _isPrimary = _isAccent = _isRaised = no
  if opts.color is 'primary'
    _isPrimary = yes
  else if opts.color is 'accent'
    _isAccent = yes
  _isRaised = opts.type is 'raised'
  _isSmall = opts.size is 'small'

  _template = if opts.type is 'floating'
    'button-floating'
  else
    if icon
      'button-icon'
    else
      'button'

  icon = 'add' if _template is 'button-floating' and not icon

  {
    #TODO id
    title, value, icon, fire, clicked, disabled, dispose
    _isPrimary, _isAccent, _isRaised, _isSmall
    _template
  }

Link = Component (opts) ->
  title = value = toAtom opts.value or untitled()
  address = toAtom opts.address or 'http://example.com/'
  {
    #TODO id
    title, value, address
    _class: ''
    _template: 'link'
  }

Badge = Component (opts) ->
  value = toAtom opts.value or '?'
  title = toAtom opts.title
  icon = opts.icon
  _template = 'badge' + if icon then '-icon' else ''
  {
    title, value, icon
    _template
  }

Textfield = Component (opts) ->
  id = guid()
  value = toAtom opts.value ? ''
  title = toAtom opts.title ? ''
  error = toAtom opts.error ? 'Error'
  pattern = opts.pattern
  icon = opts.icon
  _template = 'textfield' + if pattern then '-masked' else if icon then '-expandable' else ''
  {
    id, title, value, pattern, error, icon
    _template
  }

Textarea = Component (opts) ->
  id = guid()
  value = toAtom opts.value ? ''
  title = toAtom opts.title ? ''
  rows = opts.rows ? 3
  {
    id, title, value, rows
    _template: 'textarea'
  }

Checkbox = Component (opts) ->
  id = guid()
  checked = value = toAtom opts.value ? no
  title = toAtom opts.title or untitled()
  icon = opts.icon or null

  _template = if icon
    if icon is 'switch'
      icon
    else
      'icon-toggle'
  else
    'checkbox'

  {
    id, title, value, checked, icon
    _template
  }

Radio = Component (opts) ->
  id = guid()
  item = opts.item ? guid()
  title = toAtom opts.title or untitled()
  value = if isAtom opts.value
    opts.value
  else
    console.warn 'radio: expected value to be atom'
    atom item

  group = hashcode value

  {
    id, group, item, value, title
    _template: 'radio'
  }

Slider = Component (opts) ->
  value = toAtom opts.value ? 0
  min = opts.min ? 0
  max = opts.max ? 100

  {
    value, min, max
    _template: 'slider'
  }

Context = ->
  activatePage: do action
  showDrawer: do action
  hideDrawer: do action

Application = ->
  title = atom ''
  loaded = do action

  home = Page title: 'Home', isActive: yes
  pages = items = list [ home ]
  page = atom home

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
    title, header, items, home, page, pages, footer, _templateOf
    loaded
  }

Rule = (obj) ->
  if obj
    rules = fluid.styles.addRule obj
    rules[0].className
  else
    ''

Style = (obj) ->
  styles = for key, value of obj when obj?
    "#{key}:#{value}"
  "#{styles.join ';'};"

#
# Upgrades DOM element to MDL component.
# e.g. data-binding="mdl:true"
#
# init:
# This will be called when the binding is first applied to an element
# Set up any initial state, event handlers, etc. here
#
# update:
# This will be called once when the binding is first applied to an element,
# and again whenever any observables/computeds that are accessed change
# Update the DOM element based on the supplied values here.

ko.bindingHandlers.mdl =
  init: (element, valueAccessor, allBindings, viewModel, bindingContext) ->
    componentHandler.upgradeElement element
    ko.utils.domNodeDisposal.addDisposeCallback element, ->
      #TODO does this leak if skipped?
      componentHandler.downgradeElements element
    return

ko.bindingHandlers.mdlu =
  update: (element, valueAccessor, allBindings, viewModel, bindingContext) ->
    componentHandler.upgradeElement element
    ko.utils.domNodeDisposal.addDisposeCallback element, ->
      #TODO does this leak if skipped?
      componentHandler.downgradeElements element
    return

ko.bindingHandlers.badge =
  update: (element, valueAccessor, allBindings, viewModel, bindingContext) ->
    value = ko.unwrap valueAccessor()
    $(element).attr 'data-badge', "#{value}"

preload = ->
  $drawer = $ '#fluid-drawer'
  bind fluid.context.showDrawer, -> $drawer.addClass 'is-visible'
  bind fluid.context.hideDrawer, -> $drawer.removeClass 'is-visible'

start = (init) ->
  # Create style sheet with global selectors
  fluid.styles = window.jss.createStyleSheet(null, named:no).attach()
  fluid.context = context = do Context
  fluid.app = app = do Application
  init context, app, app.home
  window.ko.applyBindings app
  preload()
  app.loaded()

window.fluid = fluid = {
  version: 'Fluid 0.0.1'

  # Available after app start (mutable, for testability)
  app: null
  context: null
  styles: null

  start

  get: _get, set: _set, fire: _fire
  add, remove, clear

  action, isAction, atom, isAtom, list, isList, length, bind, unbind, to, from
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
  table: Table
  tr: TableRow
  th: TableDataCell
  td: TableDataCell
  div: Div
  pre: Pre
  span: Span
  card: Card
  thumbnail: Thumbnail
  text: Text
  tab: Tab
  tabs: Tabs
  markup: Markup
  markdown: Markdown
  menu: Menu
  command: Command
  button: Button
  link: Link
  badge: Badge
  textfield: Textfield
  textarea: Textarea
  checkbox: Checkbox
  radio: Radio
  slider: Slider
  tags: window.diecut
  rule: Rule
  style: Style

  # Exported for testability
  createApplication: Application
  createContext: Context

}
