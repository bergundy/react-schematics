React = require('react/addons')

c = require('../common.coffee')

BaseField = require('./base.coffee').BaseField

ObjectField = React.createClass
    mixins: [BaseField]
    render: ->
        <div>
            <div>
                {@props.label}
                {@renderPropertySelection(k, @shouldRenderProperty k) for k of @props.schema.properties}
            </div>
            {@renderProperty k, v for [k, v] in @getPropertiesToRender()}
        </div>

    isRequired: (k) ->
        @props.schema.required?.indexOf(k) > -1

    getPropertiesToRender: ->
        schema = @props.schema
        patternCandidates = (k for k of @state.instance when not schema.properties[k]?)
        patternProperties = ([k, @getPatternSchema k] for k in patternCandidates)

        ret = (
            [k, v] for k, v of schema.properties when @shouldRenderProperty k
        ).concat(
            [k, v] for [k, v] in patternProperties
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
        <label key=key>
            <input type='checkbox' disabled=@isRequired(key) checkedLink=link />
            {key}
        </label>

    linkExists: (key, selected) ->
        value: selected
        requestChange: (selected) =>
            instance = switch
                when selected
                    c.dict(([k, v] for k, v of @state.instance).concat([[key, undefined]]))
                else
                    c.dict([k, v] for k, v of @state.instance when k isnt key)
            @props.proxy.set instance
            @setState
                instance: instance

BaseField.registerClass 'object', ObjectField
