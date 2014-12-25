React = require('react')
BaseField = require('./base.coffee').BaseField

BooleanField = React.createClass
    mixins: [BaseField]
    render: ->
        <label>
            {@props.label}
            <input type='checkbox' checked=@state.instance onChange=@onChange />
        </label>

    getNewValue: (e) ->
        e.target.checked

BaseField.registerClass 'boolean', BooleanField
module.exports = BooleanField: BooleanField
