#Validation Plugin. Takes inputs, uses data attributes to validate them from a list of functions.
(($) ->
  $.fn.extend gandalf: (options) ->
    default_options =
      attribute: "validators"
      validators:
        required: () -> (value, cb) ->
          err = if (not ($.trim(value).length > 0)) then "This field is required." else null
          cb err
        length: (length=1) -> (value, cb) ->
          err = if (not ($.trim(value).length >= length)) then "Must be at least #{length} character#{if length > 1 then 's' else ''} long." else null
          cb err
        email: (email_regex=/^\S+@\S+\.\S+$/) -> (value, cb) ->
          err = if email_regex.test(value) then null else "Invalid email."
          cb err
    options = $.extend true,{}, default_options, options
    return throw "gandalf.js expects a callback" if not options.callback? or typeof options.callback isnt "function"
    errors = []
    count = 0
    total_count = 0
    @each ->
      validators = $(this).data(options.attribute)?.split(" ") or []
      for validator in validators
        continue if not !!validator
        total_count++
    @each ->
      $this = $(this)
      validators = $this.data(options.attribute)?.split(" ") or []
      validator_fns = []
      errors.push
        input: $this
        errors: []
      for validator in validators
        continue if not !!validator
        matches = validator.match /([\w\-\_]+)\[(.*)\]/
        name = matches[1]
        throw "gandalf.js couldn't find any validators with name '#{name}'" if not options.validators[name]?
        params = (matches[2].length and matches[2]?.split(',')) or []
        validator_fns.push options.validators[name].apply $this, params
      if validator_fns.length is 0
        options.callback([])
        return @
      for fn in validator_fns
        fn $this.val(), (err) ->
          count++
          errors[errors.length - 1].errors.push err if err
          if count is total_count
            options.callback(errors)
) jQuery