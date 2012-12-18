test:
	NODE_ENV=test node_modules/mocha/bin/mocha --compilers coffee:coffee-script test/spec.coffee  --ignore-leaks
