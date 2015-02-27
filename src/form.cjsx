React = require('react')
BaseField = require('./fields/base.coffee').BaseField
require('./fields/boolean.cjsx')
require('./fields/string.cjsx')
require('./fields/object.cjsx')
require('./fields/array.cjsx')
require('./fields/oneof.cjsx')
c = require('./common.coffee')

module.exports =
    Form: React.createClass
        getInitialState: ->
            instance: @props.instance

        render: ->
            schema = @props.schema
            Class = BaseField.getClass schema
            <Class schema=schema proxy=@proxy() />

        proxy: ->
            get: => @state.instance
            set: (v) => @setState(instance: v)
