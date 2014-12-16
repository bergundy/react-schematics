React = require('react')
ObjectField = require('./fields/object.cjsx').ObjectField

schema =
    required: ['b']
    properties:
        a:
            type: 'string'
            enum: ['a', 'b', 'c']
        b:
            type: 'boolean'
            default: true

proxy =
    get: -> global.window.instance
    set: (v) -> global.window.instance = v

comp = <ObjectField schema=schema proxy=proxy />
React.render comp, document.querySelector 'body'


#    Form: c.C
#        render: ->
#            schema = @props.schema
#            c.E getClass(schema), {schema: schema, instance: @props.instance or getDefaultInstance(schema)}
