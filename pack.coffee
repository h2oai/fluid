{ print, atom, from } = require './fluid.coffee'

[ life, universe, everything ] = [1 .. 3].map -> atom 0

answer = from life, universe, everything, (m, x, c) -> m * x + c

life 20
universe 2
everything 2

print answer()


