react-schematics is a WIP library which generates HTML forms out of JSON Schema.
JSON Schema is a great standard and is implemented in most popular programming langauges.
It allows us to build validation layers in both the client and the server.

This project's goals are to be fully compatible with the JSON Schema V4 spec and to provide extensible theming capabilities.
We're using React for it's performance and the way it encourages you to structure your code.


### Basic example

```cjsx
React = require('react')
Form = require('react-schematics').Form
theme = require('react-schematics-theme-bootstrap3').theme

userSchema =
    required: ['name']
    properties:
        name:
            type: 'string'
        age:
            type: 'integer'

user =
    name: "Vova"


comp = <Form schema=userSchema instance=user theme=theme />
React.render comp, document.querySelector 'body'
```

### Themes (not yet implemented)
react-schematics can be themed by passing a theme in the constructor.

```cjsx
myCustomBooleanTheme = _.extend someBaseTheme,  # or we'd have to implement all types
    boolean:
        render(component): ->
            <label>
                # the label property can be a key in a parent object of the boolean schema
                {component.props.label}
                # component.onChange is a helper but requires us to implement getNewValue (below)
                <input type='checkbox' checked=component.instance onChange=component.onChange />
            </label>

        getNewValue: (e) ->
            # getNewValue receives an event and should return the new value for the instance
            e.target.checked

comp = <Form schema=schema instance=instance theme=myCustomBooleanTheme/>
React.render comp, document.querySelector 'body'
```


#### TODO
* actually implement themes - separate base themes from the component code
* rewrite the unittests so they test components with a mock theme
* integrate a validator library and implement validation (perhaps pass the error into the component's props)
* implement integer, float, null
* implement additionalProperties for object component
* finish the oneOf implementation
* implement allOf
* create a non-ugly theme
