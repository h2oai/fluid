if module?.exports?
  tape = require 'tape'
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
  fluid = window.fluid
  test = QUnit.test

{ action, isAction, atom, isAtom, list, isList, bind, act, unbind, from, to } = fluid

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
  add = (a, b, c) -> a + b + c
  multiply = (a, b, c) -> a * b * c
  bind j, add
  bind j, multiply
  t.deepEqual j(2, 3, 4), [9, 24]

test 'action should stop propagating when unbound', (t) ->
  j = do action
  add = (a, b, c) -> a + b + c
  multiply = (a, b, c) -> a * b * c
  additionbinding = bind j, add
  multiplicationbinding = bind j, multiply
  t.deepEqual j(2, 3, 4), [9, 24]
  unbind additionbinding
  t.deepEqual j(2, 3, 4), [24]
  unbind multiplicationbinding
  t.ok j(2, 3, 4) is undefined

test 'action should stop propagating when disposed', (t) ->
  j = do action
  add = (a, b, c) -> a + b + c
  multiply = (a, b, c) -> a * b * c
  additionbinding = bind j, add
  multiplicationbinding = bind j, multiply
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
  it = fluid.fixed 42
  t.strictEqual fluid.isFixed(it), yes

test 'toAtom()', (t) ->
  t.strictEqual fluid._toAtom(fluid.fixed 42), 42
  t.strictEqual fluid._toAtom(atom 42)(), 42
  t.strictEqual fluid._toAtom(42)(), 42

test 'toList()', (t) ->
  t.strictEqual fluid._toList(fluid.fixed 42), 42

  it = list [ 42 ]
  t.ok isList fluid._toList(it)
  t.strictEqual fluid._toList(it)()[0], 42

  it = atom [ 42 ]
  t.ok isList fluid._toList(it)
  t.strictEqual fluid._toList(it)()[0], 42

  it = [ 42 ]
  t.ok isList fluid._toList(it)
  t.strictEqual fluid._toList(it)()[0], 42

  it = 42
  t.ok isList fluid._toList(it)
  t.strictEqual fluid._toList(it)()[0], 42

  it = undefined
  t.ok isList fluid._toList(it)

test 'toAction()', (t) ->
  it = action()
  t.strictEqual fluid._toAction(it), it

  it = (a) -> a * a
  t.deepEqual fluid._toAction(it)(6), [ 36 ]

test 'length()', (t) ->
  a = {}
  b = {}
  c = {}

  t.strictEqual fluid.length([ a, b, c ]), 3
  t.strictEqual fluid.length(list [ a, b, c ]), 3
  t.strictEqual fluid.length(fluid.block [ a, b, c ]), 3
  t.strictEqual fluid.length(atom [ a, b, c ]), 3
  t.strictEqual fluid.length(null), 0
  t.strictEqual fluid.length(undefined), 0
  t.strictEqual fluid.length(3), 0

test 'at()', (t) ->
  a = {}
  it = [ a ]
  t.strictEqual fluid.at(it, 0), a

  it = list [ a ]
  t.strictEqual fluid.at(it, 0), a

  it = fluid.block [ a ]
  t.strictEqual fluid.at(it, 0), a

  it = 0:a
  t.strictEqual fluid.at(it, 0), a

  it = foo:a
  t.strictEqual fluid.at(it, 'foo'), a

  it = null
  t.strictEqual fluid.at(it, 0), undefined

  it = 10
  t.strictEqual fluid.at(it, 0), undefined

test 'add()', (t) ->
  a = {}
  b = {}
  c = {}

  it = [ a ]
  fluid.add it, b, c
  t.strictEqual fluid.at(it, 1), b
  t.strictEqual fluid.at(it, 2), c

  it = list [ a ]
  fluid.add it, b, c
  t.strictEqual fluid.at(it, 1), b
  t.strictEqual fluid.at(it, 2), c

  it = [ a ]
  atom_it = atom it
  fluid.add atom_it, b, c
  t.strictEqual fluid.at(atom_it, 1), b
  t.strictEqual fluid.at(atom_it, 2), c

  it = fluid.block [ a ]
  fluid.add it, b, c
  t.strictEqual fluid.at(it, 1), b
  t.strictEqual fluid.at(it, 2), c

  # noop
  it = null
  fluid.add it, b, c

  # noop
  it = {}
  fluid.add it

  # noop
  it = {}
  fluid.add it, b, c

test 'remove()', (t) ->
  a = {}
  b = {}
  c = {}

  it = [ a, b, c ]
  fluid.remove it, a, c
  t.strictEqual fluid.length(it), 1
  t.strictEqual fluid.at(it, 0), b

  it = list [ a, b, c ]
  fluid.remove it, a, c
  t.strictEqual fluid.length(it), 1
  t.strictEqual fluid.at(it, 0), b

  it = [ a, b, c ]
  atom_it = atom it
  fluid.remove atom_it, a, c
  t.strictEqual fluid.length(atom_it), 1
  t.strictEqual fluid.at(atom_it, 0), b

  it = fluid.block [ a, b, c ]
  fluid.remove it, a, c
  t.strictEqual fluid.length(it), 1
  t.strictEqual fluid.at(it, 0), b

  # noop
  it = null
  fluid.remove it, b, c

  # noop
  it = {}
  fluid.remove it

  # noop
  it = {}
  fluid.remove it, b, c

test 'clear()', (t) ->
  a = {}
  b = {}
  c = {}

  it = [ a, b, c ]
  t.strictEqual fluid.length(it), 3
  fluid.clear it
  t.strictEqual fluid.length(it), 0

  it = list [ a, b, c ]
  t.strictEqual fluid.length(it), 3
  fluid.clear it
  t.strictEqual fluid.length(it), 0

  it = [ a, b, c ]
  atom_it = atom it
  t.strictEqual fluid.length(atom_it), 3
  fluid.clear atom_it
  t.strictEqual fluid.length(atom_it), 0

  it = fluid.block [ a, b, c ]
  t.strictEqual fluid.length(it), 3
  fluid.clear it
  t.strictEqual fluid.length(it), 0

  # noop
  it = null
  fluid.clear it

  # noop
  it = {}
  fluid.clear it

test 'bind() - invalid values', (t) ->
  it = atom 42
  bind it, null # issues harmless warning
  bind {}, null # issues harmless warning
  bind null, null # issues harmless warning
  t.ok yes

test 'bind(command)', (t) ->
  it = fluid.command()
  bound = no
  bind it, -> bound = yes
  it.clicked()
  t.strictEqual bound, yes

test 'bind(container)', (t) ->
  it = fluid.block()
  bound = no
  bind it, -> bound = yes
  fluid.add it, {}
  t.strictEqual bound, yes

test 'bind(component)', (t) ->
  it = fluid.pre()
  bound = no
  bind it, -> bound = yes
  fluid.set it, {}
  t.strictEqual bound, yes

test 'get()', (t) ->
  it = undefined
  t.strictEqual fluid.get(it), it

  it = null
  t.strictEqual fluid.get(it), it

  it = {}
  t.strictEqual fluid.get(it), it

  a = answer:42
  it = atom a
  t.strictEqual fluid.get(it), a

  it = list [a]
  t.deepEqual fluid.get(it), [a]

  it = fluid.spinner()
  t.strictEqual fluid.get(it), undefined

  it = fluid.pre 'foo'
  t.strictEqual fluid.get(it), 'foo'

  it = fluid.block [ 'foo' ]
  t.deepEqual fluid.get(it), [ 'foo' ]

test 'set()', (t) ->
  it = undefined
  t.strictEqual fluid.set(it, 42), undefined

  it = null
  t.strictEqual fluid.set(it, 42), undefined

  it = {}
  t.deepEqual fluid.set(it, 42), undefined

  a = answer:42
  b = answer:43

  it = atom a
  fluid.set(it, b)
  t.strictEqual fluid.get(it), b

  it = list [ a ]
  fluid.set(it, [ b ])
  t.deepEqual fluid.get(it), [ b ]

  it = list [ a ]
  fluid.set(it, b)
  t.deepEqual fluid.get(it), [ b ]

  it = fluid.spinner()
  t.strictEqual fluid.set(it, a), undefined

  it = fluid.pre 'foo'
  fluid.set it, 'bar'
  t.strictEqual fluid.get(it), 'bar'

  it = fluid.block [ 'foo' ]
  fluid.set it, 'bar'
  t.deepEqual fluid.get(it), [ 'bar' ]

  it = fluid.block [ 'foo' ]
  fluid.set it, [ 'bar' ]
  t.deepEqual fluid.get(it), [ 'bar' ]

test 'fire()', (t) ->
  t.strictEqual fluid.fire(undefined), undefined
  t.strictEqual fluid.fire(null), undefined
  t.strictEqual fluid.fire(42), undefined
  t.strictEqual fluid.fire(fluid.spinner()), undefined

  it = action()
  a = null
  b = null
  c = {}
  d = {}
  bind it, (aa, bb) -> a = aa; b = bb
  fluid.fire it, c, d
  t.strictEqual a, c
  t.strictEqual b, d

  it = fluid.command()
  a = null
  b = null
  c = {}
  d = {}
  bind it, (aa, bb) -> a = aa; b = bb
  fluid.fire it, c, d
  t.strictEqual a, c
  t.strictEqual b, d

test 'show()', (t) ->
  t.strictEqual fluid.show(undefined), undefined
  t.strictEqual fluid.show(null), undefined
  t.strictEqual fluid.show(42), undefined
  t.strictEqual fluid.show({}), undefined

  it = fluid.pre visible:no
  t.strictEqual it.visible(), no
  fluid.show it
  t.strictEqual it.visible(), yes

test 'hide()', (t) ->
  t.strictEqual fluid.hide(undefined), undefined
  t.strictEqual fluid.hide(null), undefined
  t.strictEqual fluid.hide(42), undefined
  t.strictEqual fluid.hide({}), undefined

  it = fluid.pre()
  t.strictEqual it.visible(), yes
  fluid.hide it
  t.strictEqual it.visible(), no

test 'pre(string)', (t) ->
  it = fluid.pre 'foo'
  t.ok it.id?
  t.strictEqual it.visible(), yes
  t.strictEqual it.value(), 'foo'
  t.strictEqual it._template, 'pre'

test 'pre(value:string)', (t) ->
  it = fluid.pre value:'foo'
  t.strictEqual it.value(), 'foo'

test 'pre(id:id)', (t) ->
  it = fluid.pre id:'foo'
  t.strictEqual it.id, 'foo'

test 'pre(visible:visible)', (t) ->
  it = fluid.pre visible:no
  t.strictEqual it.visible(), no
