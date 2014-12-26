React = require('react/addons')

c = require('../common.coffee')

BaseField = require('./base.coffee').BaseField

ObjectField = React.createClass
    mixins: [BaseField, React.addons.LinkedStateMixin]
    render: ->
        <div>
            <div>
                {@props.label}
                {@renderPropertySelection(k, @shouldRenderProperty k) for k of @props.schema.properties}
                {@renderNonPropertySelection(k) for k in @getNonPropertiesToRender()}
                {@renderAddPropertyInput()}
            </div>
            <div className='property-list'>
                {@renderProperty k, v for [k, v] in @getPropertiesToRender()}
            </div>
        </div>

    isRequired: (k) ->
        @props.schema.required?.indexOf(k) > -1

    getInstancePatternCandidates: ->
        (k for k of @state.instance when not @props.schema.properties[k]?)

    getNonPropertiesToRender: ->
        @getInstancePatternCandidates().concat(@requiredNonProperties())

    requiredNonProperties: ->
        required = @props.schema.required or []
        (k for k in required when not @props.schema.properties?[k]?)

    getPropertiesToRender: ->
        patternProperties = ([k, @getPatternSchema k] for k in @getInstancePatternCandidates())

        ret = (
            [k, v] for k, v of @props.schema.properties when @shouldRenderProperty k
        ).concat(
            [k, v] for [k, v] in patternProperties
        ).concat(
            [k, @getPatternSchema k] for k in @requiredNonProperties()
        )
        ret

    shouldRenderProperty: (k) ->
        @isRequired(k) or k of @state.instance

    getPatternSchema: (k) ->
        for pattern, schema of @props.schema.patternProperties or {}
            if new RegExp(pattern).test k
                return schema
        return undefined

    renderProperty: (key, schema) ->
        Class = @getClass schema

        <div key=key>
            <Class schema=schema label=key proxy=@createProxy(key) />
        </div>

    renderPropertySelection: (key, selected) ->
        link = @linkExists key, selected
        <PropertySelection key=key property=key link=link required=@isRequired(key) />

    renderNonPropertySelection: (key) ->
        onClick = => @onPropertiesChanged key, false
        <NonPropertySelection clickHandler=onClick required=@isRequired(key) property=key key=key />

    renderAddPropertyInput: ->
        <AddPropertyInput addProperty=@addProperty link=@linkState('newPropertyKey') />

    addProperty: (e) ->
        e.preventDefault()
        key = @state.newPropertyKey
        schema = @getPatternSchema key
        if not key or key of @state.instance or (not schema? and not @props.schema.additionalProperties)
            # TODO: reflect in UI
            c.print "can't add new property: #{key}"
        else
            @onPropertiesChanged key, true
            @setState newPropertyKey: ''

    onPropertiesChanged: (key, selected) ->
        instance = switch
            when selected
                c.dict(([k, v] for k, v of @state.instance).concat([[key, undefined]]))
            else
                c.dict([k, v] for k, v of @state.instance when k isnt key)
        @props.proxy.set instance
        @setState instance: instance

    linkExists: (key, selected) ->
        value: selected
        requestChange: (selected) =>
            @onPropertiesChanged key, selected


PropertySelection = React.createClass
    render: ->
        <div>
            <input type='checkbox' disabled=@props.required checkedLink=@props.link />
            {@props.property}
        </div>

NonPropertySelection = React.createClass
    render: ->
        <div>
            {@props.property}
            <input type='button' value='X' disabled=@props.required onClick=@props.clickHandler />
        </div>

AddPropertyInput = React.createClass
    render: ->
        <form onSubmit=@props.addProperty>
            <input type='text' valueLink=@props.link />
            <input type='submit' value='add' />
        </form>

BaseField.registerClass 'object', ObjectField
module.exports =
    ObjectField: ObjectField
    PropertySelection: PropertySelection
    NonPropertySelection: NonPropertySelection
    AddPropertyInput: AddPropertyInput
