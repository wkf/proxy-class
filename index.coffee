class Proxy
  constructor: (klass, wrap = @wrap) ->
    _constructor = @_buildProxyConstructor(klass, wrap)

    eval """
      this.klass = function #{klass.name}() { _constructor.apply(this, arguments) }
    """

    @_wrapClassMethods(klass, wrap)

    return @klass

  _buildProxyConstructor: (klass, wrap) ->
    ->
      for own name, value of klass::
        if value instanceof Function
          value = wrap.bind context: @, wrapped: value, name: name
        @[name] = value

      wrap.apply(
        {context: @, wrapped: klass, name: 'constructor'}, arguments)

  _wrapClassMethods: (klass, wrap) ->
    for own name, value of klass
      if value instanceof Function
        value = wrap.bind
          context: @klass,
          wrapped: value,
          name: "@#{name}",
          constructor: @constructor
      @klass[name] = value

  wrap: ->
    @wrapped.apply(@context, arguments)

module.exports = Proxy
