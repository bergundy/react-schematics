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
                {@renderPatternCandidateSelection(k) for k in @getNonPropertiesToRender()}
                {@renderNewPropertyInput()}
            </div>
            {@renderProperty k, v for [k, v] in @getPropertiesToRender()}
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
        <div key=key>
            <input type='checkbox' disabled=@isRequired(key) checkedLink=link />
            {key}
        </div>

    renderPatternCandidateSelection: (key) ->
        onClick = => @onPropertiesChanged key, false
        <div key=key>
            {key}
            <input type='button' value='X' disabled=@isRequired(key) onClick=onClick />
        </div>

    renderNewPropertyInput: ->
        <form onSubmit=@addProperty>
            <input type='text' valueLink=@linkState('newPropertyKey') />
            <input type='submit' value='add' />
        </form>

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

BaseField.registerClass 'object', ObjectField
module.exports = ObjectField: ObjectField
