#gandalf.js
“These forms shall not pass!”

#Dead simple declarative form validation library
Gandalf.js was designed to do one thing and one thing only - Make sure the values in your inputs are what they need to be. It makes no assumptions about the setup of the inputs. It takes a set of inputs, runs the defined validators against them, and calls a callback with the results. This allows for extreme flexibility in how you setup and handle your forms.

##Features
- Asynchronous from the ground up - gandalf was designed to be asynchronous, so it can handle any type of validation code you need.
- Lightweight - gandalf clocks in at just under 50 lines of coffeescript, and around 1.5KB of compiled source.
- Flexible - gandalf makes no assumptions about your forms or project structure, it simply runs the inputs given against a set of validators.

##Installation 
Include script *after* the jQuery library (unless you are packaging scripts somehow else):

```html
<script src="/path/to/gandalf.js"></script>
```

## Basic Usage
Gandalf is called on inputs with a data attribute specifying which validators to check the values against. When the validation has completed, it runs the passed callback.

In the most simple usage gandalf is called on a set of inputs. It checks the value of the inputs againt the validator functions listed in the `data-validators` attributes. Validators are in the form `name[param,anothr_param,...]` and are seperated by spaces. Gandalf provides several default validators and you can provide custom validators as well. See [advanced usage](#advanced-usage) for more info.

```html
<input type="text" value="" data-validators="required[]" />
<input type="text" value="present" data-validators="required[] length[10]" />
<input type="text" value="present" data-validators="required[] length[5]" />
<script type="text/javascript">
  $("input").gandalf({
    callback: function(results) {
      console.log(results);
    }
  });
</script>
```
This example will produce the following results
```json
[
  {
    "errors":[
      "This field is required.",
      "Must be at least 10 characters long."
    ],
    "input": The jQuery input element 
  },{
    "errors":[
      "Must be at least 10 characters long."
    ],
    "input": The jQuery input element 
  },{
    "errors":[]
    "input": The jQuery input element     
  }
]
```
###Results
The results are an array, with each element corresponding to one input element in the set. Each element in the array has two properties.
- errors - This is an array of the error messages associated with the input. If there are none the length is 0.
- input - This is the jQuery element to which the errors belong. This allows you to do something like `error.input.addClass('error')` in your callback. 

##Advanced Usage
###Default Validators
Gandalf includes several default validators, with the ability to add more as they are needed. The default validators are:

- ####required[]
Tests to ensure the input has a non-whitespace value. 

- ####length[min-length]
Tests to ensure the input is the minimum length or longer. 
```html
<input type="text" value="" data-validators="length[4]" />
```
would pass `hello` or `bazz` but fail `foo`. 

- ####email[]
Tests that the input matches the following regex `/^\S+@\S+\.\S+$/`

###Custom Validators
In addition to the default validators gandalf makes it easy to pass in custom validators. This is done using the `validators` option.

```javascript
$("input").gandalf({
  validators: {
    //custom validators
  },callback: function(results) {
    console.log(results);
  }
});
```

Validators are function factories, returning a function that takes 2 parameters - the input value and the callback. When the validator is done checking the value, it returns the callback with the error, or null for success. 

```javascript
$("input").gandalf({
  validators: {
    is_number: function(number) {
      return function(value, cb) {
        var err = null;
        if(value != number){
          err = "The value is not " + number;
        }
        return cb(err);
      }
    }
  },callback: function(results) {
    console.log(results);
  }
});
```

You can then use your custom validators just like you would a default validator 
```html
<input type="text" value="5" data-validators="is_number[10]" /> <!-- Fail -->
<input type="text" value="10" data-validators="is_number[10]" /> <!-- Succeed -->
```

###Custom Attribute
By using the `attribute` option gandalf allows you to specify a custom data attribute to draw the validators from. This allows you to avoid namespace conflicts, but also to use a different set of validators for different calls. 

For example the following example would cause gandalf to use the `data-value-rules` attribute instead. 

```javascript
$("input").gandalf({
  attribute: "value-rules"
  callback: function(results) {
    console.log(results);
  }
});
```

The default attriibute is `validators`, which causes gandalf to look in the `data-validators` attribute. 

## Development
Development is done in [coffeescript](http://coffeescript.org/). You can view the development source in the `src` directory. 

After making any changes, please add or run any required tests. Tests are located in the `test/spec.coffee` file, and can be run via npm:
```
npm test
``` 

After testing any changes, you can compile the production version by running 
```
npm run-script build
```

- Source hosted at [GitHub](https://github.com/templaedhel/gandalf.js)
- Report issues, questions, feature requests on [GitHub Issues](https://github.com/templaedhel//gandalf.js/issues)

Pull requests are welcome! Please ensure your patches are well tested. Please create seperate branches for seperate features/patches.

## Authors

[Cosmo Wolfe](http://templaedhel.com)