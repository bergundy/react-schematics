React = require('react/addons')
update = React.addons.update

c = require('../common.coffee')

BaseField = require('./base.coffee').BaseField
fields =
    BooleanField: require('./boolean.cjsx').BooleanField
    StringField: require('./string.cjsx').StringField


module.exports =
    ObjectField: React.createClass
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
            CompName = fields[c.getClass(schema)]

            <div key=key>
                <CompName schema=schema label=key proxy=@createProxy(key) />
            </div>

        renderPropertySelection: (key, selected) ->
            <label key=key>
                <input type='checkbox' disabled=@isRequired(key) checked=selected onChange=@onChange />
                {key}
            </label>

        getNewValue: (e) ->
            key = e.target.parentNode.textContent
            selected = e.target.checked

            switch
                when selected
                    c.dict(([k, v] for k, v of @state.instance).concat([[key, undefined]]))
                else
                    c.dict([k, v] for k, v of @state.instance when k isnt key)
