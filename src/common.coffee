React = require('react')


getDefaultInstance = (s) ->
    if 'default' of s
        return s.default
    if s.enum?
        return s.enum[0]
    type = getType(s)
    switch type
        when 'null' then null
        when 'boolean' then false
        when 'integer' then 0
        when 'number' then 0
        when 'string' then ''
        when 'array' then []
        when 'object' then {}


getType = (s) ->
    if s.type?
        s.type
    else if s.items?
        'array'
    else if s.properties? or s.patternProperties?
        'object'


module.exports =
    isArray: Array.isArray
    isObject: (x) -> x.toString() is '[object Object]'
    print: console.log.bind console
    getDefaultInstance: getDefaultInstance
    getType: getType
    dict: (items) -> new ->
        @[k] = v for [k, v] in items
        @

