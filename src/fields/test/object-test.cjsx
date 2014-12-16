React = require('react/addons')
c = require('../../common.coffee')
ObjectField = require('../object.cjsx').ObjectField
TestUtils = React.addons.TestUtils


describe 'Object field', ->
    beforeEach =>
        @schema =
            properties:
                a:
                    type: 'boolean'
            patternProperties:
                '^test\\d$':
                    type: 'string'

        @instance = {}
        @proxy =
            get: => @instance
            set: (v) => @instance = v

    render = =>
        TestUtils.renderIntoDocument <ObjectField proxy=@proxy schema=@schema label='test' />

    it 'Renders no fields by default', =>
        form = render()
        inputs = TestUtils.scryRenderedDOMComponentsWithTag form, 'input'
        expect(inputs.length).toBe 1

    it 'Renders property when required', =>
        @schema.required = ['a']
        form = render()
        inputs = TestUtils.scryRenderedDOMComponentsWithTag form, 'input'
        expect(inputs.length).toBe 2

    it 'Renders property when in instance', =>
        @instance.a = false
        form = render()
        inputs = TestUtils.scryRenderedDOMComponentsWithTag form, 'input'
        expect(inputs.length).toBe 2
        expect(inputs[1].props.type).toBe 'checkbox'

    it 'Renders pattern property when in instance', =>
        @instance.test1 = 'test-string'
        form = render()
        inputs = TestUtils.scryRenderedDOMComponentsWithTag form, 'input'
        expect(inputs.length).toBe 2
        expect(inputs[1].props.type).toBe 'text'

    it 'Renders an unchecked checkbox for property selection by default', =>
        form = render()
        inputs = TestUtils.scryRenderedDOMComponentsWithTag form, 'input'
        expect(inputs.length).toBe 1
        expect(inputs[0].props.type).toBe 'checkbox'
        expect(inputs[0].props.checked).toBe false

    it 'Renders a checked checkbox for property selection when property in instance', =>
        @instance.a = false
        form = render()
        inputs = TestUtils.scryRenderedDOMComponentsWithTag form, 'input'
        expect(inputs.length).toBe 2
        expect(inputs[0].props.type).toBe 'checkbox'
        expect(inputs[0].props.checked).toBe true

    it 'Changes state on click', =>
        @schema.required = ['a']
        form = render()
        inputs = TestUtils.scryRenderedDOMComponentsWithTag form, 'input'
        input = inputs[1]
        TestUtils.Simulate.change input, {target: {checked: true}}
        expect(@instance.a).toBe true

    it 'Adds a property when selecting the checkbox', =>
        form = render()
        inputs = TestUtils.scryRenderedDOMComponentsWithTag form, 'input'
        expect(inputs.length).toBe 1
        
        TestUtils.Simulate.change inputs[0], {target: {checked: true, parentNode: {textContent: 'a'}}}

        inputs = TestUtils.scryRenderedDOMComponentsWithTag form, 'input'
        expect(inputs.length).toBe 2
        expect(inputs[1].props.type).toBe 'checkbox'
