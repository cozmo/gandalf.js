(function() {

  (function($) {
    return $.fn.extend({
      gandalf: function(options) {
        var count, default_options, errors, total_count;
        default_options = {
          attribute: "validators",
          validators: {
            required: function() {
              return function(value, cb) {
                var err;
                err = !($.trim(value).length > 0) ? "This field is required." : null;
                return cb(err);
              };
            },
            length: function(length) {
              if (length == null) {
                length = 1;
              }
              return function(value, cb) {
                var err;
                err = !($.trim(value).length >= length) ? "Must be at least " + length + " character" + (length > 1 ? 's' : '') + " long." : null;
                return cb(err);
              };
            },
            email: function(email_regex) {
              if (email_regex == null) {
                email_regex = /^\S+@\S+$/;
              }
              return function(value, cb) {
                var err;
                err = email_regex.test(value) ? null : "Invalid email.";
                return cb(err);
              };
            },
            matches: function(selector) {
              return function(value, cb) {
                var err;
                if (value !== $(selector).val()) {
                  err = "The passwords don't match.";
                } else {
                  err = null;
                }
                return cb(err);
              };
            }
          }
        };
        options = $.extend(true, {}, default_options, options);
        errors = [];
        count = 0;
        total_count = 0;
        this.each(function() {
          var validator, validators, _i, _len, _ref, _results;
          validators = ((_ref = $(this).data(options.attribute)) != null ? _ref.split(" ") : void 0) || [];
          _results = [];
          for (_i = 0, _len = validators.length; _i < _len; _i++) {
            validator = validators[_i];
            if (!!!validator) {
              continue;
            }
            _results.push(total_count++);
          }
          return _results;
        });
        return this.each(function() {
          var $this, fn, matches, name, params, validator, validator_fns, validators, _i, _j, _len, _len1, _ref, _ref1, _results;
          $this = $(this);
          validators = ((_ref = $this.data(options.attribute)) != null ? _ref.split(" ") : void 0) || [];
          validator_fns = [];
          for (_i = 0, _len = validators.length; _i < _len; _i++) {
            validator = validators[_i];
            if (!!!validator) {
              continue;
            }
            matches = validator.match(/([\w\-\_]+)\[(.*)\]/);
            name = matches[1];
            params = (matches[2].length && ((_ref1 = matches[2]) != null ? _ref1.split(',') : void 0)) || [];
            validator_fns.push(options.validators[name].apply($this, params));
          }
          _results = [];
          for (_j = 0, _len1 = validator_fns.length; _j < _len1; _j++) {
            fn = validator_fns[_j];
            _results.push(fn($this.val(), function(err) {
              count++;
              errors.push({
                input: $this,
                error: err
              });
              if (count === total_count) {
                return options.callback(errors);
              }
            }));
          }
          return _results;
        });
      }
    });
  })(jQuery);

}).call(this);
