test = QUnit.test

{ action, isAction, atom, isAtom, list, isList, bind, act, unbind, from, to } = window.fluid

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
  t.equal j(1, 2, 3), 6

test 'action should stop propagating when unbound', (t) ->
  j = do action
  f = (a, b, c) -> a + b + c
  binding = bind j, f
  t.equal j(1, 2, 3), 6
  unbind binding
  result = null
  result = j 1, 2, 3
  t.ok result is undefined

test 'action should stop propagating when disposed', (t) ->
  j = do action
  f = (a, b, c) -> a + b + c
  binding = bind j, f
  t.equal j(1, 2, 3), 6
  j.dispose()
  result = null
  result = j 1, 2, 3
  t.ok result is undefined

test 'action should not fail when unbound', (t) ->
  j = do action
  result = null
  result = j 1, 2, 3
  t.ok result is undefined

test 'action should propagate when linked', (t) ->
  j = do action
  bind j, (a, b, c) -> a + b + c
  t.equal j(1, 2, 3), 6

test 'action should allow multicasting', (t) ->
  j = do action
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
  t.equal j(2, 3, 4), 24
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
  t.equal n(), 42

test 'atom should return value when called without arguments', (t) ->
  n = atom 42
  t.equal n(), 42

test 'atom should hold new value when reassigned', (t) ->
  n = atom 42
  t.equal n(), 42
  n 43
  t.equal n(), 43

test 'atom should not propagate unless value is changed (without comparator)', (t) ->
  n = atom 42
  propagated = no
  bind n, (value) -> propagated = yes
  t.equal propagated, no
  n 42
  t.equal propagated, no

test 'atom should propagate value when value is changed (without comparator)', (t) ->
  n = atom 42
  propagated = no
  propagatedValue = 0
  bind n, (value) ->
    propagated = yes
    propagatedValue = value
  t.equal propagated, no
  n 43
  t.equal propagated, yes
  t.equal propagatedValue, 43

test 'atom should not propagate unless value is changed (with comparator)', (t) ->
  comparator = (a, b) -> a.answer is b.answer
  n = atom { answer: 42 }, comparator
  propagated = no
  bind n, (value) -> propagated = yes
  t.equal propagated, no
  n answer: 42
  t.equal propagated, no

test 'atom should propagate when value is changed (with comparator)', (t) ->
  comparator = (a, b) -> a.answer is b.answer
  n = atom { answer: 42 }, comparator
  propagated = no
  propagatedValue = null
  bind n, (value) ->
    propagated = yes
    propagatedValue = value
  t.equal propagated, no

  newValue = answer: 43
  n newValue
  t.equal propagated, yes
  t.equal propagatedValue, newValue

test 'atom should allow multicasting', (t) ->
  n = atom 42
  propagated1 = no
  propagated2 = no
  target1 = (value) -> propagated1 = yes
  target2 = (value) -> propagated2 = yes
  bind n, target1
  bind n, target2
  t.equal propagated1, no
  t.equal propagated2, no

  n 43
  t.equal propagated1, yes
  t.equal propagated2, yes

test 'atom should stop propagating when unbound', (t) ->
  n = atom 42
  propagated1 = no
  propagated2 = no
  target1 = (value) -> propagated1 = yes
  target2 = (value) -> propagated2 = yes
  binding1 = bind n, target1
  binding2 = bind n, target2
  t.equal propagated1, no
  t.equal propagated2, no

  n 43
  t.equal propagated1, yes
  t.equal propagated2, yes

  propagated1 = no
  propagated2 = no
  unbind binding2
  n 44
  t.equal propagated1, yes
  t.equal propagated2, no

  propagated1 = no
  propagated2 = no
  unbind binding1
  n 45
  t.equal propagated1, no
  t.equal propagated2, no

test 'empty nodes should always propagate', (t) ->
  event = do atom
  propagated = no
  bind event, -> propagated = yes
  t.equal propagated, no
  event yes
  t.equal propagated, yes

test 'context should unbind multiple bindings at once', (t) ->
  n = atom 42
  propagated1 = no
  propagated2 = no
  target1 = (value) -> propagated1 = yes
  target2 = (value) -> propagated2 = yes
  binding1 = bind n, target1
  binding2 = bind n, target2
  t.equal propagated1, no
  t.equal propagated2, no

  n 43
  t.equal propagated1, yes
  t.equal propagated2, yes

  propagated1 = no
  propagated2 = no
  unbind [ binding1, binding2 ]
  n 44
  t.equal propagated1, no
  t.equal propagated2, no

test 'bind', (t) ->
  width = atom 2
  height = atom 6
  area = 0
  binding = bind width, height, (w, h) -> area = w * h
  t.equal area, 0

  width 7
  t.equal area, 42

  unbind binding
  width 2
  t.equal area, 42

test 'to', (t) ->
  width = atom 2
  height = atom 6
  area = atom 0
  binding = to area, width, height, (w, h) -> w * h
  t.equal area(), 12

  width 7
  t.equal area(), 42

  unbind binding
  width 2
  t.equal area(), 42

test 'from', (t) ->
  width = atom 2
  height = atom 6
  area = from width, height, (w, h) -> w * h
  t.equal area(), 12

  width 7
  t.equal area(), 42


