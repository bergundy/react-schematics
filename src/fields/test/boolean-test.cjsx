React = require('react/addons')
c = require('../../common.coffee')
BooleanField = require('../boolean.cjsx').BooleanField
TestUtils = React.addons.TestUtils


describe 'Boolean field', ->
    beforeEach =>
        @instance = undefined
        @schema =
            type: 'boolean'
        @proxy =
            get: => @instance
            set: (v) => @instance = v

    render = =>
        TestUtils.renderIntoDocument <BooleanField schema=@schema proxy=@proxy label='test' />

    it 'Initializes with library default', =>
        label = render()
        expect(@instance).toBe false

    it 'Initializes with schema default', =>
        @schema.default = true
        label = render()
        expect(@instance).toBe true

    it 'Changes state on click', =>
        label = render()
        checkbox = TestUtils.findRenderedDOMComponentWithTag label, 'input'
        TestUtils.Simulate.change checkbox, {target: {checked: true}}
        expect(@instance).toBe true
