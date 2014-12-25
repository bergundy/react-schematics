React = require('react')
BaseField = require('./base.coffee').BaseField

StringField = React.createClass
    mixins: [BaseField]
    render: ->
        <label>
            {@props.label}
            {@renderInput(@state.instance)}
        </label>

    renderInput: (instance) ->
        if @props.schema.enum?
            <select onChange=@onChange defaultValue=instance>
                {@renderOption(opt) for opt in @props.schema.enum}
            </select>
        else
            <input type="text" value=instance onChange=@onChange />

    renderOption: (opt) ->
        <option key=opt value=opt>{opt}</option>

    getNewValue: (e) ->
        e.target.value

BaseField.registerClass 'string', StringField
module.exports = StringField: StringField
