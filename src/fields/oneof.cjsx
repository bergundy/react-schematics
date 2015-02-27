React = require('react/addons')

c = require('../common.coffee')

BaseField = require('./base.coffee').BaseField

OneOfField = React.createClass
    mixins: [BaseField, React.addons.LinkedStateMixin]

    getInitialState: ->
        selectedIndex: @getDefaultIndex()

    render: ->
        options = @props.schema.oneOf
        <div>
            <div>
                {@props.label}
                <select valueLink=@linkState('selectedIndex')>
                    {@renderOption(i, schema) for i, schema of options}
                </select>
            </div>
            <div>
                {@renderSelected()}
            </div>
        </div>

    getSelectedSchema: ->
        @props.schema.oneOf[@state.selectedIndex]

    getDefaultIndex: ->
        options = @props.schema.oneOf
        for i, schema of options
            if false # TODO: json-schema validate (@state.instance)
                return i

        return 0

    renderSelected: ->
        schema = @getSelectedSchema()
        Class = @getClass schema

        <Class schema=schema proxy=@props.proxy />

    renderOption: (index, schema) ->
        type = c.getType(schema)
        <option key=index value=index>{type}</option>


BaseField.registerClass 'oneOf', OneOfField
module.exports =
    OneOfField: OneOfField
