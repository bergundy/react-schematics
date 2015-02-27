React = require('react')
Form = require('./form.cjsx').Form

schema =
    required: ['b', 'main2']
    properties:
        a:
            oneOf: [
                type: 'string'
                enum: ['a', 'b', 'c']
            ,
                type: 'boolean'
            ]
        b:
            type: 'boolean'
            default: true
        c:
            type: 'array'
            items:
                type: 'string'
            default: ['a', 'b']
    patternProperties:
        '^main\\d+':
            type: 'boolean'

global.window.instance =
    main1: true


comp = <Form schema=schema instance=global.window.instance />
global.window.rndr = React.render comp, document.querySelector 'body'
