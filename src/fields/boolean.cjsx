React = require('react')
BaseField = require('./base.coffee').BaseField


module.exports =
    BooleanField: React.createClass
        mixins: [BaseField]
        render: ->
            <label>
                {@props.label}
                <input type='checkbox' checked=@state.instance onChange=@onChange />
            </label>

        getNewValue: (e) ->
            e.target.checked
