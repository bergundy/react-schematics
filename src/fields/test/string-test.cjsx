React = require('react/addons')
c = require('../../common.coffee')
StringField = require('../string.cjsx').StringField
TestUtils = React.addons.TestUtils


describe 'String field', ->
    beforeEach =>
        @instance = undefined
        @schema =
            type: 'string'
        @proxy =
            get: => @instance
            set: (v) => @instance = v

    render = =>
        TestUtils.renderIntoDocument <StringField schema=@schema proxy=@proxy label='test' />

    it 'Initializes with library default', =>
        label = render()
        expect(@instance).toBe ''

    it 'Initializes with schema default', =>
        @schema.default = 'test-default'
        label = render()
        expect(@instance).toBe @schema.default

    it 'Initializes with text input when no enum in schema', =>
        @instance = 'test-default'
        label = render()
        textbox = TestUtils.findRenderedDOMComponentWithTag label, 'input'
        expect(textbox.props.value).toBe(@instance)

    it 'Initializes with select box when enum in schema', =>
        @instance = 'go'
        @schema.enum = ['hey', 'ho', 'lets', 'go']
        label = render()
        select = TestUtils.findRenderedDOMComponentWithTag label, 'select'
        expect(select.props.defaultValue).toBe(@instance)
        options = TestUtils.scryRenderedDOMComponentsWithTag label, 'option'
        values = (option.props.value for option in options)
        expect(values).toEqual(@schema.enum)

    it 'Changes state on input', =>
        label = render()
        textbox = TestUtils.findRenderedDOMComponentWithTag label, 'input'
        TestUtils.Simulate.change textbox, {target: {value: 'changed'}}
        expect(@instance).toBe 'changed'
