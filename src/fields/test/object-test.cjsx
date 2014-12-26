React = require('react/addons')
c = require('../../common.coffee')
_object = require('../object.cjsx')
ObjectField = _object.ObjectField
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
                    default: 'test-default'

        @instance = {}
        @proxy =
            get: => @instance
            set: (v) => @instance = v

    render = =>
        @form = TestUtils.renderIntoDocument <ObjectField proxy=@proxy schema=@schema label='test' />

    getPropertiesInputs = =>
        container = TestUtils.findRenderedDOMComponentWithClass @form, 'property-list'
        TestUtils.scryRenderedDOMComponentsWithTag container, 'input'

    getPropertiesSelectionInputs = =>
        selection = TestUtils.scryRenderedComponentsWithType @form, _object.PropertySelection
        (TestUtils.findRenderedDOMComponentWithTag(s, 'input') for s in selection)

    getNonPropertiesSelectionInputs = =>
        selection = TestUtils.scryRenderedComponentsWithType @form, _object.NonPropertySelection
        (TestUtils.findRenderedDOMComponentWithTag(s, 'input') for s in selection)

    getAddPropertyInputs = =>
        container = TestUtils.findRenderedComponentWithType @form, _object.AddPropertyInput
        TestUtils.scryRenderedDOMComponentsWithTag container, 'input'

    it 'Renders no fields by default', =>
        render()
        inputs = getPropertiesInputs()
        expect(inputs.length).toBe 0
        expect(getNonPropertiesSelectionInputs().length).toBe 0
        expect(@instance.a).toBe undefined

    it 'Renders property when required', =>
        @schema.required = ['a']
        render()
        inputs = getPropertiesInputs()
        expect(inputs.length).toBe 1
        expect(inputs[0].props.type).toBe 'checkbox'
        expect(@instance.a).toBe false

    it 'Renders property when in instance', =>
        @instance.a = false
        render()
        inputs = getPropertiesInputs()
        expect(inputs.length).toBe 1
        expect(inputs[0].props.type).toBe 'checkbox'

    it 'Renders pattern property when in instance', =>
        @instance.test1 = 'test-string'
        render()
        inputs = getPropertiesInputs()
        expect(inputs.length).toBe 1
        expect(inputs[0].props.type).toBe 'text'
        expect(inputs[0].props.value).toBe @instance.test1
        expect(inputs[0].props.value).toBe 'test-string'
        expect(getNonPropertiesSelectionInputs().length).toBe 1

    it 'Renders an unchecked checkbox for property selection by default', =>
        render()
        inputs = getPropertiesSelectionInputs()
        expect(inputs.length).toBe 1
        expect(inputs[0].props.type).toBe 'checkbox'
        expect(inputs[0].props.checked).toBe false

    it 'Renders a checked checkbox for property selection when property in instance', =>
        @instance.a = false
        render()
        inputs = getPropertiesSelectionInputs()
        expect(inputs.length).toBe 1
        expect(inputs[0].props.type).toBe 'checkbox'
        expect(inputs[0].props.checked).toBe true

    it 'Adds a property when selecting the checkbox', =>
        render()
        inputs = getPropertiesSelectionInputs()
        expect(getPropertiesInputs().length).toBe 0
        TestUtils.Simulate.change inputs[0], {target: {checked: true, key: 'a'}}
        inputs = getPropertiesInputs()
        expect(getPropertiesInputs().length).toBe 1
        expect(inputs[0].props.type).toBe 'checkbox'
        expect(inputs[0].props.checked).toBe false
        expect(@instance.a).toBe false

    it 'Renders pattern property when added in property selection', =>
        render()
        inputs = getAddPropertyInputs()
        TestUtils.Simulate.change inputs[0], {target: {value: 'test2'}}
        TestUtils.Simulate.submit inputs[1], {}
        inputs = getPropertiesInputs()
        expect(inputs.length).toBe 1
        expect(inputs[0].props.type).toBe 'text'
        expect(inputs[0].props.value).toBe @instance.test2
        expect(@instance.test2).toBe 'test-default'
        inputs = getAddPropertyInputs()
        expect(inputs[0].props.value).toBe ''
        inputs = getNonPropertiesSelectionInputs()
        expect(inputs.length).toBe 1

    it 'Changes state on click', =>
        @schema.required = ['a']
        form = render()
        inputs = getPropertiesInputs()
        input = inputs[0]
        TestUtils.Simulate.change input, {target: {checked: true}}
        expect(@instance.a).toBe true
