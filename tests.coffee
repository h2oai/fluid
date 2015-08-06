if module?.exports?
  tape = require 'tape'
  _ = require 'lodash'
  fluid = require './fluid.js'
  through = (o, m) -> (args...) -> m.apply o, args
  test = (name, f) ->
    tape name, (t) ->
      stub =
        ok: through t, t.ok
        expect: through t, t.plan
        strictEqual: through t, t.strictEqual
        deepEqual: through t, t.deepEqual
      f stub
      t.end()
else
  _ = window._
  fluid = window.fluid
  test = QUnit.test

{ at, get, set, fire, add, remove, clear, action, isAction, atom, isAtom, list, isList, length, bind, unbind, to, from, fixed, isFixed, page, grid, cell, cell1, cell2, cell3, cell4, cell5, cell6, cell7, cell8, cell9, cell10, cell11, cell12, table, tr, th, td, block, inline, card, spinner, progress, thumbnail, tabset, tab, text, markup, markdown, pre, menu, command, button, link, badge, icon, textfield, textarea, checkbox, radio, slider, tags, style, css, display4, display3, display2, display1, headline, title, subhead, body2, body1, caption, show, hide, extend, print, _toAtom, _toList, _toAction, createComponent, createContainer, isComponent, _header, _footer } = fluid

test 'isAction', (t) ->
  t.ok no is isAction undefined
  t.ok no is isAction null
  t.ok no is isAction 42
  t.ok no is isAction '42'
  t.ok no is isAction ->
  t.ok no is isAction atom()
  t.ok no is isAction list()
  t.ok yes is isAction action()

test 'isAtom', (t) ->
  t.ok no is isAtom undefined
  t.ok no is isAtom null
  t.ok no is isAtom 42
  t.ok no is isAtom '42'
  t.ok no is isAtom ->
  t.ok yes is isAtom atom()
  t.ok no is isAtom list()
  t.ok no is isAtom action()

test 'isList', (t) ->
  t.ok no is isList undefined
  t.ok no is isList null
  t.ok no is isList 42
  t.ok no is isList '42'
  t.ok no is isList ->
  t.ok no is isList atom()
  t.ok yes is isList list()
  t.ok no is isList action()

test 'action should not fail when unbound', (t) ->
  j = do action
  result = null
  result = j 1, 2, 3
  t.ok result is undefined

test 'action should propagate when linked', (t) ->
  j = do action
  bind j, (a, b, c) -> a + b + c
  t.deepEqual j(1, 2, 3), [6]

test 'action should stop propagating when unbound', (t) ->
  j = do action
  f = (a, b, c) -> a + b + c
  binding = bind j, f
  t.deepEqual j(1, 2, 3), [6]
  unbind binding
  result = null
  result = j 1, 2, 3
  t.ok result is undefined

test 'action should stop propagating when disposed', (t) ->
  j = do action
  f = (a, b, c) -> a + b + c
  binding = bind j, f
  t.deepEqual j(1, 2, 3), [6]
  j.dispose()
  result = null
  result = j 1, 2, 3
  t.ok result is undefined

test 'unicast action should not fail when unbound', (t) ->
  j = action multicast:off
  result = null
  result = j 1, 2, 3
  t.ok result is undefined

test 'unicast action should propagate when linked', (t) ->
  j = action multicast:off
  bind j, (a, b, c) -> a + b + c
  t.deepEqual j(1, 2, 3), 6

test 'unicast action should allow rebinding', (t) ->
  j = action multicast:off
  bind j, (a, b, c) -> a + b + c
  t.deepEqual j(1, 2, 3), 6
  bind j, (a, b, c) -> a + b * c # issues harmless warning
  t.deepEqual j(1, 2, 3), 7

test 'unicast action should stop propagating when unbound', (t) ->
  j = action multicast:off
  f = (a, b, c) -> a + b + c
  binding = bind j, f
  t.deepEqual j(1, 2, 3), 6
  unbind binding
  result = null
  result = j 1, 2, 3
  t.ok result is undefined

test 'action should allow multicasting', (t) ->
  j = action multicast:on # default, but anyway...
  f1 = (a, b, c) -> a + b + c
  f2 = (a, b, c) -> a * b * c
  bind j, f1
  bind j, f2
  t.deepEqual j(2, 3, 4), [9, 24]

test 'action should stop propagating when unbound', (t) ->
  j = do action
  f1 = (a, b, c) -> a + b + c
  f2 = (a, b, c) -> a * b * c
  binding1 = bind j, f1
  binding2 = bind j, f2
  t.deepEqual j(2, 3, 4), [9, 24]
  unbind binding1
  t.deepEqual j(2, 3, 4), [24]
  unbind binding2
  t.ok j(2, 3, 4) is undefined

test 'action should stop propagating when disposed', (t) ->
  j = do action
  f1 = (a, b, c) -> a + b + c
  f2 = (a, b, c) -> a * b * c
  binding1 = bind j, f1
  binding2 = bind j, f2
  t.deepEqual j(2, 3, 4), [9, 24]
  j.dispose()
  t.ok j(2, 3, 4) is undefined

test 'atom should hold value when initialized', (t) ->
  n = atom 42
  t.strictEqual n(), 42

test 'atom should return value when called without arguments', (t) ->
  n = atom 42
  t.strictEqual n(), 42

test 'atom should hold new value when reassigned', (t) ->
  n = atom 42
  t.strictEqual n(), 42
  n 43
  t.strictEqual n(), 43

test 'atom should not propagate unless value is changed (without comparator)', (t) ->
  n = atom 42
  propagated = no
  bind n, (value) -> propagated = yes
  t.strictEqual propagated, no
  n 42
  t.strictEqual propagated, no

test 'atom should propagate value when value is changed (without comparator)', (t) ->
  n = atom 42
  propagated = no
  propagatedValue = 0
  bind n, (value) ->
    propagated = yes
    propagatedValue = value
  t.strictEqual propagated, no
  n 43
  t.strictEqual propagated, yes
  t.strictEqual propagatedValue, 43

test 'atom should not propagate unless value is changed (with comparator)', (t) ->
  comparator = (a, b) -> a.answer is b.answer
  n = atom { answer: 42 }, comparator
  propagated = no
  bind n, (value) -> propagated = yes
  t.strictEqual propagated, no
  n answer: 42
  t.strictEqual propagated, no

test 'atom should propagate when value is changed (with comparator)', (t) ->
  comparator = (a, b) -> a.answer is b.answer
  n = atom { answer: 42 }, comparator
  propagated = no
  propagatedValue = null
  bind n, (value) ->
    propagated = yes
    propagatedValue = value
  t.strictEqual propagated, no

  newValue = answer: 43
  n newValue
  t.strictEqual propagated, yes
  t.strictEqual propagatedValue, newValue

test 'atom should allow multicasting', (t) ->
  n = atom 42
  propagated1 = no
  propagated2 = no
  target1 = (value) -> propagated1 = yes
  target2 = (value) -> propagated2 = yes
  bind n, target1
  bind n, target2
  t.strictEqual propagated1, no
  t.strictEqual propagated2, no

  n 43
  t.strictEqual propagated1, yes
  t.strictEqual propagated2, yes

test 'atom should stop propagating when unbound', (t) ->
  n = atom 42
  propagated1 = no
  propagated2 = no
  target1 = (value) -> propagated1 = yes
  target2 = (value) -> propagated2 = yes
  binding1 = bind n, target1
  binding2 = bind n, target2
  t.strictEqual propagated1, no
  t.strictEqual propagated2, no

  n 43
  t.strictEqual propagated1, yes
  t.strictEqual propagated2, yes

  propagated1 = no
  propagated2 = no
  unbind binding2
  n 44
  t.strictEqual propagated1, yes
  t.strictEqual propagated2, no

  propagated1 = no
  propagated2 = no
  unbind binding1
  n 45
  t.strictEqual propagated1, no
  t.strictEqual propagated2, no

test 'empty nodes should always propagate', (t) ->
  event = do atom
  propagated = no
  bind event, -> propagated = yes
  t.strictEqual propagated, no
  event yes
  t.strictEqual propagated, yes

test 'context should unbind multiple bindings at once', (t) ->
  n = atom 42
  propagated1 = no
  propagated2 = no
  target1 = (value) -> propagated1 = yes
  target2 = (value) -> propagated2 = yes
  binding1 = bind n, target1
  binding2 = bind n, target2
  t.strictEqual propagated1, no
  t.strictEqual propagated2, no

  n 43
  t.strictEqual propagated1, yes
  t.strictEqual propagated2, yes

  propagated1 = no
  propagated2 = no
  unbind [ binding1, binding2 ]
  n 44
  t.strictEqual propagated1, no
  t.strictEqual propagated2, no

test 'bind', (t) ->
  width = atom 2
  height = atom 6
  area = 0
  binding = bind width, height, (w, h) -> area = w * h
  t.strictEqual area, 0

  width 7
  t.strictEqual area, 42

  unbind binding
  width 2
  t.strictEqual area, 42

test 'to', (t) ->
  width = atom 2
  height = atom 6
  area = atom 0
  binding = to area, width, height, (w, h) -> w * h
  t.strictEqual area(), 12

  width 7
  t.strictEqual area(), 42

  unbind binding
  width 2
  t.strictEqual area(), 42

test 'from', (t) ->
  width = atom 2
  height = atom 6
  area = from width, height, (w, h) -> w * h
  t.strictEqual area(), 12

  width 7
  t.strictEqual area(), 42

test 'fixed', (t) ->
  it = fixed 42
  t.strictEqual isFixed(it), yes

test 'toAtom()', (t) ->
  t.strictEqual _toAtom(fixed 42), 42
  t.strictEqual _toAtom(atom 42)(), 42
  t.strictEqual _toAtom(42)(), 42

test 'toList()', (t) ->
  t.strictEqual _toList(fixed 42), 42

  it = list [ 42 ]
  t.ok isList _toList(it)
  t.strictEqual _toList(it)()[0], 42

  it = atom [ 42 ]
  t.ok isList _toList(it)
  t.strictEqual _toList(it)()[0], 42

  it = [ 42 ]
  t.ok isList _toList(it)
  t.strictEqual _toList(it)()[0], 42

  it = 42
  t.ok isList _toList(it)
  t.strictEqual _toList(it)()[0], 42

  it = undefined
  t.ok isList _toList(it)

test 'toAction()', (t) ->
  it = action()
  t.strictEqual _toAction(it), it

  it = (a) -> a * a
  t.deepEqual _toAction(it)(6), [ 36 ]

test 'length()', (t) ->
  a = {}
  b = {}
  c = {}

  t.strictEqual length([ a, b, c ]), 3
  t.strictEqual length(list [ a, b, c ]), 3
  t.strictEqual length(block [ a, b, c ]), 3
  t.strictEqual length(atom [ a, b, c ]), 3
  t.strictEqual length(null), 0
  t.strictEqual length(undefined), 0
  t.strictEqual length(3), 0

test 'at()', (t) ->
  a = {}
  it = [ a ]
  t.strictEqual at(it, 0), a

  it = list [ a ]
  t.strictEqual at(it, 0), a

  it = block [ a ]
  t.strictEqual at(it, 0), a

  it = 0:a
  t.strictEqual at(it, 0), a

  it = foo:a
  t.strictEqual at(it, 'foo'), a

  it = null
  t.strictEqual at(it, 0), undefined

  it = 10
  t.strictEqual at(it, 0), undefined

test 'add()', (t) ->
  a = {}
  b = {}
  c = {}

  it = [ a ]
  add it, b, c
  t.strictEqual at(it, 1), b
  t.strictEqual at(it, 2), c

  it = list [ a ]
  add it, b, c
  t.strictEqual at(it, 1), b
  t.strictEqual at(it, 2), c

  it = [ a ]
  atom_it = atom it
  add atom_it, b, c
  t.strictEqual at(atom_it, 1), b
  t.strictEqual at(atom_it, 2), c

  it = block [ a ]
  add it, b, c
  t.strictEqual at(it, 1), b
  t.strictEqual at(it, 2), c

  # noop
  it = null
  add it, b, c

  # noop
  it = {}
  add it

  # noop
  it = {}
  add it, b, c

test 'remove()', (t) ->
  a = {}
  b = {}
  c = {}

  it = [ a, b, c ]
  remove it, a, c
  t.strictEqual length(it), 1
  t.strictEqual at(it, 0), b

  it = list [ a, b, c ]
  remove it, a, c
  t.strictEqual length(it), 1
  t.strictEqual at(it, 0), b

  it = [ a, b, c ]
  atom_it = atom it
  remove atom_it, a, c
  t.strictEqual length(atom_it), 1
  t.strictEqual at(atom_it, 0), b

  it = block [ a, b, c ]
  remove it, a, c
  t.strictEqual length(it), 1
  t.strictEqual at(it, 0), b

  # noop
  it = null
  remove it, b, c

  # noop
  it = {}
  remove it

  # noop
  it = {}
  remove it, b, c

test 'clear()', (t) ->
  a = {}
  b = {}
  c = {}

  it = [ a, b, c ]
  t.strictEqual length(it), 3
  clear it
  t.strictEqual length(it), 0

  it = list [ a, b, c ]
  t.strictEqual length(it), 3
  clear it
  t.strictEqual length(it), 0

  it = [ a, b, c ]
  atom_it = atom it
  t.strictEqual length(atom_it), 3
  clear atom_it
  t.strictEqual length(atom_it), 0

  it = block [ a, b, c ]
  t.strictEqual length(it), 3
  clear it
  t.strictEqual length(it), 0

  # noop
  it = null
  clear it

  # noop
  it = {}
  clear it

test 'bind() - invalid values', (t) ->
  it = atom 42
  bind it, null # issues harmless warning
  bind {}, null # issues harmless warning
  bind null, null # issues harmless warning
  t.ok yes

test 'bind(command)', (t) ->
  it = command()
  bound = no
  bind it, -> bound = yes
  it.clicked()
  t.strictEqual bound, yes

test 'bind(container)', (t) ->
  it = block()
  bound = no
  bind it, -> bound = yes
  add it, {}
  t.strictEqual bound, yes

test 'bind(component)', (t) ->
  it = pre()
  bound = no
  bind it, -> bound = yes
  set it, {}
  t.strictEqual bound, yes

test 'get()', (t) ->
  it = undefined
  t.strictEqual get(it), it

  it = null
  t.strictEqual get(it), it

  it = {}
  t.strictEqual get(it), it

  a = answer:42
  it = atom a
  t.strictEqual get(it), a

  it = list [a]
  t.deepEqual get(it), [a]

  it = spinner()
  t.strictEqual get(it), undefined

  it = pre 'foo'
  t.strictEqual get(it), 'foo'

  it = block [ 'foo' ]
  t.deepEqual get(it), [ 'foo' ]

test 'set()', (t) ->
  it = undefined
  t.strictEqual set(it, 42), undefined

  it = null
  t.strictEqual set(it, 42), undefined

  it = {}
  t.deepEqual set(it, 42), undefined

  a = answer:42
  b = answer:43

  it = atom a
  set(it, b)
  t.strictEqual get(it), b

  it = list [ a ]
  set(it, [ b ])
  t.deepEqual get(it), [ b ]

  it = list [ a ]
  set(it, b)
  t.deepEqual get(it), [ b ]

  it = spinner()
  t.strictEqual set(it, a), undefined

  it = pre 'foo'
  set it, 'bar'
  t.strictEqual get(it), 'bar'

  it = block [ 'foo' ]
  set it, 'bar'
  t.deepEqual get(it), [ 'bar' ]

  it = block [ 'foo' ]
  set it, [ 'bar' ]
  t.deepEqual get(it), [ 'bar' ]

test 'fire()', (t) ->
  t.strictEqual fire(undefined), undefined
  t.strictEqual fire(null), undefined
  t.strictEqual fire(42), undefined
  t.strictEqual fire(spinner()), undefined

  it = action()
  a = null
  b = null
  c = {}
  d = {}
  bind it, (aa, bb) -> a = aa; b = bb
  fire it, c, d
  t.strictEqual a, c
  t.strictEqual b, d

  it = command()
  a = null
  b = null
  c = {}
  d = {}
  bind it, (aa, bb) -> a = aa; b = bb
  fire it, c, d
  t.strictEqual a, c
  t.strictEqual b, d

test 'show()', (t) ->
  t.strictEqual show(undefined), undefined
  t.strictEqual show(null), undefined
  t.strictEqual show(42), undefined
  t.strictEqual show({}), undefined

  it = pre visible:no
  t.strictEqual it.visible(), no
  show it
  t.strictEqual it.visible(), yes

test 'hide()', (t) ->
  t.strictEqual hide(undefined), undefined
  t.strictEqual hide(null), undefined
  t.strictEqual hide(42), undefined
  t.strictEqual hide({}), undefined

  it = pre()
  t.strictEqual it.visible(), yes
  hide it
  t.strictEqual it.visible(), no

test 'component cons / arg coalescing', (t) ->
  opts = null
  cons = createComponent (arg) -> opts = arg; {}

  it = cons()
  t.ok isComponent it
  t.deepEqual opts, {}

  it = cons a = cons()
  t.strictEqual opts.value, a

  it = cons a = []
  t.strictEqual opts.value, undefined

  it = cons a = undefined
  t.strictEqual opts.value, a

  it = cons a = null
  t.strictEqual opts.value, a

  it = cons a = 42
  t.strictEqual opts.value, a

  it = cons a = 'foo'
  t.strictEqual opts.value, a

  it = cons a = atom 42
  t.strictEqual opts.value, a

  it = cons a = ->
  t.strictEqual opts.action, a

  it = cons a = foo: 42, bar: 43
  t.deepEqual opts, a

test 'container cons / arg coalescing', (t) ->
  opts = null
  cons = createContainer (arg) -> opts = arg; {}

  it = cons()
  t.ok isComponent it
  t.ok _.isArray opts.items
  t.strictEqual opts.items.length, 0

  it = cons a = cons()
  t.ok _.isArray opts.items
  t.strictEqual opts.items.length, 1
  t.strictEqual at(opts.items, 0), a

  it = cons a = [ 42, 43, 44 ]
  t.deepEqual opts.items, a

  it = cons a = undefined
  t.ok _.isArray opts.items
  t.strictEqual opts.items.length, 1
  t.ok isComponent b = at(opts.items, 0)
  t.strictEqual b.value(), 'undefined'

  it = cons a = null
  t.ok _.isArray opts.items
  t.strictEqual opts.items.length, 1
  t.ok isComponent b = at(opts.items, 0)
  t.strictEqual b.value(), 'null'

  it = cons a = 42
  t.ok _.isArray opts.items
  t.strictEqual opts.items.length, 1
  t.ok isComponent b = at(opts.items, 0)
  t.strictEqual b.value(), '42'

  it = cons a = 'foo'
  t.ok _.isArray opts.items
  t.strictEqual opts.items.length, 1
  t.ok isComponent b = at(opts.items, 0)
  t.strictEqual b.value(), a

  it = cons a = atom 42
  t.ok _.isArray opts.items
  t.strictEqual opts.items.length, 1
  t.deepEqual opts.items, [ 42 ]

  it = cons a = ->
  t.ok _.isArray opts.items
  t.strictEqual opts.items.length, 0
  t.strictEqual opts.action, a

  it = cons a = foo: 42, bar: 43
  t.ok _.isArray opts.items
  t.strictEqual opts.items.length, 0
  t.deepEqual opts, foo: 42, bar: 43, items: []

  it = cons a = list [ 42, 43, 44 ]
  t.strictEqual opts.items, a

test 'header()', (t) ->
  it = _header()
  t.ok isList it.links
  t.strictEqual length(it.links), 0

  it = _header links: [ 
    link 'Help', address: 'http://example.com/help' 
  ]

  t.ok isList it.links
  t.strictEqual it._hasLinks(), yes

test 'footer()', (t) ->
  it = _footer()
  t.ok if it.title() then yes else no
  t.ok isList it.links
  t.strictEqual length(it.links), 0
  t.ok isList it.buttons
  t.strictEqual length(it.buttons), 0
  t.ok isAtom it.visible
  t.strictEqual it.visible(), yes

test 'pre(string)', (t) ->
  it = pre 'foo'
  t.ok it.id?
  t.strictEqual it.visible(), yes
  t.strictEqual it.value(), 'foo'
  t.strictEqual it._template, 'pre'

  it = pre value:'foo'
  t.strictEqual it.value(), 'foo'

  it = pre id:'foo'
  t.strictEqual it.id, 'foo'

  it = pre visible:no
  t.strictEqual it.visible(), no

