c = require('../common.coffee')

registry = {}

module.exports =
    BaseField:
        registerClass: (t, c) ->
            registry[t] = c

        getClass: (s) ->
            registry[c.getType(s)]

        componentWillMount: ->
            instance = @props.proxy.get()
            if instance is undefined
                instance = c.getDefaultInstance @props.schema
                @props.proxy.set instance
            @setState
                instance: instance

        onChange: (e) ->
            value = @getNewValue e
            @props.proxy.set value
            @setState
                instance: value

        createProxy: (k) ->
            get: => @state.instance[k]
            set: (v) => @state.instance[k] = v
