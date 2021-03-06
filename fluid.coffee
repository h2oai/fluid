if module?.exports?
  _ = require 'lodash'
  marked = require 'marked'
  diecut = require 'diecut'
  jss = require 'jss'
  ko = require 'knockout'
  CoffeeScript = require 'coffee-script'
else
  { _, marked, diecut, jss, ko, CoffeeScript } = window

print = (a...) -> console.log a...

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

at = (container, index) ->
  if container
    if isList container
      container()[index]
    else if _.isArray container
      container[index]
    else if isContainer container
      at container.items, index
    else if isAtom container
      at container(), index
    else if (_.isObject container)
      container[index]
    else
      console.warn 'at: source is not a container'
      undefined
  else
    console.warn 'at: source is not a container'
    undefined

add = (container, elements...) ->
  if container
    if elements.length
      if (isList container) or (_.isArray container)
        container.push elements...
      else if isContainer container
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
      else if isContainer container
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
    else if _.isArray container
      result = container[0...]
      container.length = 0
      result
    else if isContainer container
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

fixed = (value) -> value: value, __fluid_fixed__: yes

isFixed = (a) -> if a?.__fluid_fixed__ then yes else no

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
  if _.isArray a
    a.length
  else if isList a
    a().length
  else if isContainer a
    a.items().length
  else if isAtom a
    length a()
  else
    0

hasLength = (a) -> if length a then yes else no

isNode = (a) -> (isObservable a) or isAction a

toAtom = (value) ->
  if isFixed value
    value.value
  else if isAtom value
    value
  else
    atom value

toList = (a) ->
  if a
    if isFixed a
      a.value
    else if isList a
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
        console.warn 'resolve: cannot resolve source'
    else
      console.warn 'resolve: cannot resolve source'
      undefined
  else
    console.warn 'resolve: cannot resolve source'
    undefined

_apply = (sources, f) ->
  f (sources.map _resolve)...

#TODO unused
# act = (sources..., f) ->
#   _apply sources, f
#   sources.map (source) ->
#     _bind source, -> _apply sources, f

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
    else if isAtom source
      source value
    else if isList source
      if _.isArray value
        source value
      else
        source [ value ]
    else
      undefined
  else
    undefined

__fire = (source, args) ->
  if source
    if isComponent source
      if source.fire
        __fire source.fire, args
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
isContainer = (a) -> if (isComponent a) and a.items then yes else no

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

Container = (f) ->
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
      else if isAtom arg
        items.push arg()
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
        items.push Text String arg

    self = f opts
    self.__fluid_component__ = yes
    self

Header = Component (opts) ->
  links = toList opts.links
  _hasLinks = from links, hasLength
  menu = atom null

  {
    links, _hasLinks, menu
  }

Footer = Component (opts) ->
  title = toAtom opts.title or untitled()
  links = toList opts.links
  buttons = toList opts.buttons

  visible = toAtom opts.visible ? yes
  _hasTitle = from title, truthy
  _hasLinks = from links, hasLength
  _hasButtons = from buttons, hasLength

  {
    title, links, buttons, visible, _hasTitle, _hasLinks, _hasButtons
  }

Page = Container (opts) ->
  id = guid()
  isActive = atom opts.isActive ? no
  title = toAtom opts.title or untitled()
  items = toList opts.items
  load = -> fluid.context.activatePage id

  {
    id, title, items, load, isActive, _templateOf
  }

GenericContainer = (template) ->
  Container (opts) ->
    visible = toAtom opts.visible ? yes
    items = toList opts.items
    style = opts.style ? {}

    {
      items, visible, style, _templateOf
      _template: template
    }

Grid = GenericContainer 'grid'

Cell = (span) -> GenericContainer "cell-#{span}"

Block = GenericContainer 'div'

Inline = GenericContainer 'span'

Spinner = Component (opts) ->
  visible = toAtom opts.visible ? yes

  {
    visible
    _template: 'spinner'
  }

Progress = Component (opts) ->
  visible = toAtom opts.visible ? yes
  progress = toAtom opts.progress ? 0
  _indeterminate = from progress, (progress) -> progress <= 0 or progress > 100

  {
    progress, visible, _indeterminate
    _template: 'progress'
  }

Thumbnail = Component (opts) ->
  image = value = toAtom opts.value ? opts.image #TODO apply pattern to .value attributes of other components
  visible = toAtom opts.visible ? yes
  title = toAtom opts.title ? ''
  _hasTitle = from title, truthy
  style = opts.style ? {}
  style.width ?= '256px'
  style.height ?= '256px'
  style.background ?= from image, (url) -> "url('#{url}') center / cover"

  {
    _hasTitle, title, image, visible, value, style
    _template: 'thumbnail'
  }

Card = Container (opts) ->
  items = toList opts.items
  visible = toAtom opts.visible ? yes
  title = toAtom opts.title ? ''
  _hasTitle = from title, truthy
  buttons = toList opts.buttons ? []
  _hasButtons = from buttons, hasLength
  menu = toAtom opts.menu
  image = toAtom opts.image
  _hasImage = from image, truthy

  style = opts.style ? {}

  _titleStyle =
    background: from image, (url) -> "url('#{url}') center / cover"

  _titleStyle.color = opts.color if opts.color

  {
    _hasTitle, visible, title, items, _hasButtons, buttons, menu, image, _hasImage, style, _titleStyle, _templateOf
    _template: 'card'
  }

Tab = Container (opts) ->
  id = guid()
  _address = "##{id}"
  title = toAtom opts.title or untitled()
  items = toList opts.items
  {
    id, _address, title, items, _templateOf
    _isActive: no
  }

Tabset = Container (opts) ->
  items = toList opts.items
  visible = toAtom opts.visible ? yes

  # HACK
  for item, i in items()
    item._isActive = i is 0

  {
    items, visible
    _template: 'tabs'
  }

Markup = Component (opts) ->
  id = opts.id ? guid()
  visible = toAtom opts.visible ? yes
  value = html = toAtom opts.value
  {
    id, visible, value, html
    _template: 'html'
  }

Pre = Component (opts) ->
  id = opts.id ? guid()
  visible = toAtom opts.visible ? yes
  value = toAtom opts.value
  {
    id, visible, value
    _template: 'pre'
  }

Text = Component (opts) ->
  id = opts.id ? guid()
  visible = toAtom opts.visible ? yes
  value = toAtom opts.value
  html = from value, _.escape
  {
    id, visible, value, html
    _template: 'text'
  }

makeFontTemplate = (tag, type, opts) ->
  classNames = []
  classNames.push "mdl-typography--#{type}" + if opts.alt then '-color-contrast' else ''
  for opt, selected of opts when opt isnt 'value' and opt isnt 'alt'
    switch opt
      when 'center', 'justify', 'left', 'right', 'capitalize', 'lowercase', 'uppercase'
        classNames.push "mdl-typography--text-#{opt}" if selected
      when 'wrap'
        classNames.push "mdl-typography--text-nowrap" if not selected

  prefix = "<#{tag} class='#{classNames.join ' '}'>"
  suffix = "</#{tag}>"
  (content) -> prefix + _.escape(content) + suffix


Styled = (tag, type) ->
  Component (opts) ->
    id = opts.id ? guid()
    visible = toAtom opts.visible ? yes
    value = toAtom opts.value
    html = from value, makeFontTemplate tag, type, opts
    {
      id, visible, value, html
      _template: 'html'
    }

Markdown = Component (opts) ->
  #TODO support bare: yes/no (use spans for bare)
  id = opts.id ? guid()
  visible = toAtom opts.visible ? yes
  value = toAtom opts.value
  html = from value, marked
  {
    id, visible, value, html
    _template: 'html'
  }

TableRow = Container (opts) ->
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

Table = Container (opts) ->
  items = toList opts.items
  visible = toAtom opts.visible ? yes
  selectable = opts.selectable ? no
  _headers = items.shift()
  {
    _headers, visible, items, selectable
    _template: 'table'
  }

Menu = Container (opts) ->
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
  visible = toAtom opts.visible ? yes
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
    title, visible, value, icon, fire, clicked, disabled, dispose
    _isPrimary, _isAccent, _isRaised, _isSmall
    _template
  }

Link = Component (opts) ->
  title = value = toAtom opts.value or untitled()
  visible = toAtom opts.visible ? yes
  address = toAtom opts.address or 'http://example.com/'
  {
    #TODO id
    title, value, visible, address
    _class: ''
    _template: 'link'
  }

Badge = Component (opts) ->
  value = toAtom opts.value or '?'
  visible = toAtom opts.visible ? yes
  title = toAtom opts.title
  icon = opts.icon
  _template = 'badge' + if icon then '-icon' else ''
  {
    title, visible, value, icon
    _template
  }

Icon = Component (opts) ->
  icon = value = opts.value ? opts.icon ? 'extension'
  visible = toAtom opts.visible ? yes
  disabled = opts.disabled #TODO atom?
  size = opts.size

  sizeStyle = switch size
    when 'small'
      ' md-18'
    when 'medium'
      ' md-24'
    when 'large'
      ' md-36'
    when 'x-large'
      ' md-48'
    else
      ''

  disabledStyle = if disabled then ' md-inactive' else ''

  _class = "material-icons md-dark #{sizeStyle}#{disabledStyle}"

  {
    value, visible, icon, _class 
    _template: 'icon'
  }
  
Textfield = Component (opts) ->
  id = guid()
  visible = toAtom opts.visible ? yes
  value = toAtom opts.value ? ''
  title = toAtom opts.title ? ''
  error = toAtom opts.error ? 'Error'
  pattern = opts.pattern
  icon = opts.icon
  _template = 'textfield' + if pattern then '-masked' else if icon then '-expandable' else ''
  {
    id, title, value, visible, pattern, error, icon
    _template
  }

Textarea = Component (opts) ->
  id = guid()
  visible = toAtom opts.visible ? yes
  value = toAtom opts.value ? ''
  title = toAtom opts.title ? ''
  rows = opts.rows ? 3
  {
    id, title, value, visible, rows
    _template: 'textarea'
  }

Checkbox = Component (opts) ->
  id = guid()
  visible = toAtom opts.visible ? yes
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
    id, title, value, checked, visible, icon
    _template
  }

Radio = Component (opts) ->
  id = guid()
  visible = toAtom opts.visible ? yes
  item = opts.item ? guid()
  title = toAtom opts.title or untitled()
  value = if isAtom opts.value
    opts.value
  else
    console.warn 'radio: expected value to be atom'
    atom item

  group = hashcode value

  {
    id, group, item, value, visible, title
    _template: 'radio'
  }

Slider = Component (opts) ->
  value = toAtom opts.value ? 0
  visible = toAtom opts.visible ? yes
  min = opts.min ? 0
  max = opts.max ? 100

  {
    value, min, max, visible
    _template: 'slider'
  }

Context = ->
  activatePage: do action
  toggleDrawer: do action
  toggleEditor: do action

Application = ->
  title = atom 'Fluid'
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
    fluid.context.toggleDrawer()
    return

  header = Header
    links: [
      Link 'Help', address: 'http://example.com/help'
    ]

  footer = Footer
    title: fluid.version
    links: [
      Link 'Source', address: 'https://github.com/h2oai/fluid'
      Link 'H2O.ai', address: 'http://h2o.ai/'
    ]

  bind title, (title) -> document.title = title

  {
    title, header, items, home, page, pages, footer, _templateOf
    loaded
  }

Css = (obj) ->
  if obj
    rules = fluid.styles.addRule obj
    rules[0].className
  else
    ''

Style = (obj) ->
  styles = for key, value of obj when value?
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


ko.bindingHandlers.progress =
  init: (element, valueAccessor, allBindings, viewModel, bindingContext) ->
    value = ko.unwrap valueAccessor()
    element.addEventListener 'mdl-componentupgraded', ->
      @MaterialProgress.setProgress value

  update: (element, valueAccessor, allBindings, viewModel, bindingContext) ->
    value = ko.unwrap valueAccessor()
    if el = element.MaterialProgress
      el.setProgress value

preload = ->
  $drawer = $ '#fluid-drawer'
  bind fluid.context.toggleDrawer, -> $drawer.toggleClass 'is-visible'
  bind fluid.context.toggleEditor, -> $('body').toggleClass 'fluid-is-editing'

loadSettings = ->
  if window.localStorage?
    if data = window.localStorage['fluid_data']
      return JSON.parse data
  return

saveSettings = (spool) ->
  if window.localStorage?
    window.localStorage['fluid_data'] = JSON.stringify
      version: '1'
      repl:
        history: spool
  return

createSpool = ->
  _entries = []
  _index = -1

  if settings = loadSettings()
    if settings.version is '1'
      _entries = settings.repl.history
      _index = _entries.length - 1

  push: (source) ->
    if source isnt _entries[_entries.length - 1]
      _entries.push source
      if _entries.length > 100
        _entries.shift() 
    _index = _entries.length - 1
    saveSettings _entries

  prev: ->
    if 0 <= i = _index
      _index--
      _entries[i]

  next: ->
    if _entries.length > i = _index + 1
      _index++
      _entries[i]

listModuleSymbols = ->
  (k for k of fluid when '_' isnt k.charAt 0)

createRepl = (elementId) ->
  _spool = createSpool()

  _lastReplResult = undefined

  _prelude = do ->
    "{#{listModuleSymbols().join ','}} = window.fluid"

  evaluateSnippet = ->
    source = editor.getValue()
    console.group source
    try
      cs = _prelude + '\nreturn do ->\n' + source
        .split "\n"
        .map (a) -> "  #{a}"
        .join "\n"
      js = CoffeeScript.compile cs, bare: yes
      closure = new Function 'context', 'app', 'home', 'activePage', 'last', js
      console.log _lastReplResult = closure(
        fluid.context
        fluid.app
        fluid.app.home
        fluid.app.page()
        _lastReplResult
      )
      editor.setValue ''
      _spool.push source
    catch error
      console.error error
    finally
      console.groupEnd()

  loadPreviousSnippet = ->
    editor.setValue source if source = _spool.prev()

  loadNextSnippet = ->
    editor.setValue source if source = _spool.next()

  editor = CodeMirror.fromTextArea document.getElementById(elementId),
    theme: 'eclipse'
    extraKeys:
      'Alt-Up': loadPreviousSnippet
      'Alt-Down': loadNextSnippet
      'Alt-Enter': evaluateSnippet

indent = (contents) ->
  contents
    .split /\n/
    .map (a) -> '  ' + a
    .join "\n"

createPrelude = -> #TODO cache
  """
  { #{ listModuleSymbols().join ', ' } } = window.fluid
  window.fluid._start (context, app, home, activePage) ->
    bind app.page, (it) -> activePage = it

  """

_compile = (contents) ->
  CoffeeScript.compile createPrelude() + indent contents

_start = (init) ->
  # Create style sheet with global selectors
  fluid.styles = jss.createStyleSheet(null, named:no).attach()
  fluid.context = context = do Context
  fluid.app = app = do Application
  try
    init context, app, app.home, app.home
    ko.applyBindings app
  catch error
    console.error error
  preload()
  createRepl 'fluid-editor'
  app.loaded()

fluid = {
  version: 'Fluid 0.0.1'

  _start, _compile

  app: null
  context: null
  styles: null

  get: _get, set: _set, fire: _fire
  at, add, remove, clear

  action, isAction, atom, isAtom, list, isList, length, bind, unbind, to, from

  fixed, isFixed

  isComponent, isContainer, show, hide, extend, print

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
  block: Block
  pre: Pre
  inline: Inline
  card: Card
  spinner: Spinner
  progress: Progress
  thumbnail: Thumbnail
  text: Text
  tab: Tab
  tabset: Tabset
  markup: Markup
  markdown: Markdown
  menu: Menu
  command: Command
  button: Button
  link: Link
  badge: Badge
  icon: Icon
  textfield: Textfield
  textarea: Textarea
  checkbox: Checkbox
  radio: Radio
  slider: Slider
  tags: diecut
  css: Css
  style: Style

  # Typography
  display4: Styled 'h1', 'display-4'
  display3: Styled 'h2', 'display-3'
  display2: Styled 'h3', 'display-2'
  display1: Styled 'h4', 'display-1'
  headline: Styled 'h5', 'headline'
  title: Styled 'h6', 'title'
  subhead: Styled 'p', 'subhead'
  body2: Styled 'p', 'body-2'
  body1: Styled 'p', 'body-1'
  caption: Styled 'p', 'caption'

  # Exported for testability
  createApplication: Application
  createContext: Context
  createComponent: Component
  createContainer: Container
  _toAtom: toAtom
  _toList: toList
  _toAction: toAction
  _header: Header
  _footer: Footer

  # Phony keywords for codemirror
  home: null
  activePage: null

  # Exported for codemirror mode keyword support.
  _symbols: listModuleSymbols
}

if module?.exports?
  module.exports = fluid
else
  window.fluid = fluid
