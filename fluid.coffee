noop = ->
truthy = (a) -> if a then yes else no
falsy = (a) -> if a then no else yes
always = -> yes
never = -> no
templateOf = (component) -> "#{component.template}-template"
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
  if (isList container) or (_.isArray container)
    container.push elements...
  return

_remove = (array, element) ->
  if -1 < index = array.indexOf element
    (array.splice index, 1)[0]
  else
    undefined

remove = (container, elements...) ->
  if isList container
    container.removeAll elements
  else if _.isArray container
    for element in elements
      _remove container, element
  else
    undefined

clear = (container) ->
  if isList container
    container.removeAll()
  else if isAtom container
    container undefined
  else if _.isArray container
    result = container[0...]
    container.length = 0
    result
  else
    undefined

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

isAtom = (a) -> (ko.isObservable a) and not _.isFunction a.remove

list = (array=[]) -> ko.observableArray array

isList = (a) -> (ko.isObservable a) and _.isFunction a.remove

length = (a) ->
  if _.isArray
    a.length
  else if isList a
    a().length
  else
    0

isNode = (a) -> (ko.isObservable a) or isEvent a

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

_apply = (sources, f) ->
  f (sources.map (source) -> source())...

act = (sources..., f) -> #TODO unused
  _apply sources, f
  sources.map (source) ->
    _bind source, -> _apply sources, f

bind = (sources..., f) ->
  if sources.length is 1 and isEvent sources[0]
    _bind sources[0], f
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

#
# Component hierarchy:
#   App
#     Sections (Menu + Pages)
#       Pages (Nav + Content)
#         Layout
#           Panel
#         
#       

extend = (f, opts) ->
  if _.isFunction f
    (arg, opts2) ->
      f arg, if opts2 then _.extend {}, opts, opts2 else opts
  else
    console.warn 'extend: argument 1 is not a function'
    noop

Layout = (_panels, opts={}) ->
  contents = toList _panels

  {
    contents, templateOf
    template: 'layout'
  }

Panel = (_controls, opts={}) ->
  span = clamp opts.span ? 12, 1, 12
  contents = toList _controls

  {
    contents, templateOf
    template: "panel-#{span}"
  }

Panel_ = (span) -> extend Panel, span: span

Card = (_html, opts={}) ->
  html = toAtom _html
  title = toAtom opts.title ? ''
  _hasTitle = from title, truthy
  buttons = toList opts.buttons ? []
  _hasButtons = from buttons, length
  _hasMenu = no #TODO

  {
    _hasTitle, title, html, _hasButtons, buttons, _hasMenu
    template: 'card'
  }

Html = (_html, opts={}) ->
  #TODO support bare: yes/no (use spans for bare)
  id = opts.id ? guid()
  html = toAtom _html
  {
    id, html
    template: 'html'
  }

Markdown = (_value, opts={}) ->
  #TODO support bare: yes/no (use spans for bare)
  id = opts.id ? guid()
  value = toAtom _value
  html = from value, window.marked
  {
    id, value, html
    template: 'html'
  }

Button = (_label, opts={}) ->
  label = toAtom _label
  clicked = do event
  bind clicked, opts.clicked if _.isFunction opts.clicked
  dispose = -> free clicked

  {
    #TODO id
    label, clicked, dispose
    template: 'button' 
  }

Link = (_label, opts={}) ->
  label = toAtom _label
  address = toAtom opts.address or '#'
  {
    #TODO id
    label, address
    _class: ''
    template: 'link'
  }

Textfield = (_value, opts={}) ->
  id = guid()
  value = toAtom _value
  label = toAtom opts.label ? ''
  {
    id, label, value
    template: 'textfield'
  }

Header = (_text, opts={}) ->
  links = toList opts.links
  _hasLinks = from links, length

  {
    links, _hasLinks
  }

Footer = (_text, opts={}) ->
  text = toAtom _text
  links = toList opts.links
  visible = toAtom opts.visible ? yes
  _hasText = from text, truthy
  _hasLinks = from links, length

  {
    text, links, visible, _hasText, _hasLinks
  }

Application = (version) ->
  title = atom ''
  page = list []
  pages = list [ page ]
  header = Header version,
    links: [
      Link 'Help', address: 'http://example.com/help'
    ]

  footer = Footer version,
    links: [
      Link 'Source', address: 'https://github.com/h2oai/fluid'
      Link 'H2O.ai', address: 'http://h2o.ai/'
    ]
  bind title, (title) -> document.title = title

  { title, header, pages, page, footer, templateOf }

Fluid = ->
  app = Application 'Fluid 0.0.1'
  loaded = do event
  ready = (f) -> bind loaded, f

  {
    app, loaded, ready

    add, remove, clear

    # dataflow primitives
    event, isEvent, atom, isAtom, list, isList, length, bind, unbind, to, from

    extend

    # components
    layout: Layout
    panel1: Panel_ 1
    panel2: Panel_ 2
    panel3: Panel_ 3
    panel4: Panel_ 4
    panel5: Panel_ 5
    panel6: Panel_ 6
    panel7: Panel_ 7
    panel8: Panel_ 8
    panel9: Panel_ 9
    panel10: Panel_ 10
    panel11: Panel_ 11
    panel12: Panel
    panel: Panel
    card: Card
    html: Html
    markdown: Markdown
    button: Button
    link: Link
    textfield: Textfield
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

window.fluid = fluid = Fluid()

main = ->
  ko.applyBindings fluid.app
  fluid.loaded fluid.app

if document.readyState isnt 'loading'
  main()
else
  document.addEventListener 'DOMContentLoaded', main
