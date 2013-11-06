proxy-class
===========

A Proxy Class for wrapping javascript/coffeescript classes and adding functionality.


Example:

class LogProxy extends Proxy
  wrap: ->
    console.log("Calling #{@name}")
    super

class A
  constructor: ->
    @property = 'world'

  hello: -> @property

_A = new LogProxy(A)

a  = new _A # outputs 'Calling constructor'
a.hello()   # outputs 'Calling hello', returns 'world'
