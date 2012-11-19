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
        email: (email_regex=/^\S+@\S+$/) -> (value, cb) ->
          err = if email_regex.test(value) then null else "Invalid email."
          cb err
        matches: (selector) -> (value, cb) ->
          if value isnt $(selector).val()
            err = "The passwords don't match." 
          else 
            err = null
          cb err
    options = $.extend true,{}, default_options, options
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
      for validator in validators
        continue if not !!validator
        matches = validator.match /([\w\-\_]+)\[(.*)\]/
        name = matches[1]
        params = (matches[2].length and matches[2]?.split(',')) or []
        validator_fns.push options.validators[name].apply $this, params
      for fn in validator_fns
        fn $this.val(), (err) ->
          count++
          errors.push
            input: $this
            error: err
          if count is total_count
            options.callback(errors)
) jQuery