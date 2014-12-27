React = require('react/addons')

isArray = require('../common.coffee').isArray

BaseField = require('./base.coffee').BaseField

ArrayField = React.createClass
    mixins: [BaseField, React.addons.LinkedStateMixin]
    render: ->
        <div>
            {@props.label}
            {@renderItem(i, schema) for [i, schema] in @getItemsToRender()}
            <AddItemInput clickHandler=@addItem disabled=@isFull() />
        </div>

    getItemsToRender: ->
        [i, @getItemSchema i] for i of @state.instance

    getItemSchema: (i) ->
        itemsSchema = @props.schema.items
        if isArray itemsSchema
            return @props.schema.items[i]
        else if itemsSchema?
            return @props.schema.items
        else
            # TODO: no items schema

    renderItem: (i, schema) ->
        Class = @getClass schema

        <div key=i>
            <Class schema=schema proxy=@createProxy(i) />
        </div>

    addItem: ->
        instance = @state.instance.concat [undefined]
        @props.proxy.set instance
        @setState instance: instance

    isFull: ->
        # TODO: implement
        false


AddItemInput = React.createClass
    render: ->
        <div>
            <input type='button' value='add' disabled=@props.disabled onClick=@props.clickHandler />
        </div>


BaseField.registerClass 'array', ArrayField
module.exports =
    ArrayField: ArrayField
    AddItemInput: AddItemInput
