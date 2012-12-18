#gandalf.js 
“These forms shall not pass!”

#Dead simple declarative form validation library
gandalf.js was designed to do one thing and one thing only - Make sure the values in your inputs are what you need them to be. It makes no assumptions about the setup of the inputs. It takes a set of inputs, runs the defined validators against them, and calls a callback with the results. This allows for extreme flexibility in how you set up your forms. 

##Features
-	Asynchronous from the ground up - gandalf was designed to be asynchronous, so it can handle any type of validation code you need.
- Lightweight - gandalf clocks in at just under 50 lines of coffeescript, and less than 1.23KB compiled source. 
- Flexible - gandalf makes no assumptions about your forms and project structure, it simply runs the inputs given against a set of validators. 

##Dependancies 
Currently gandalf is a [jQuery](http://jquery.com/) plugin, but besides that there are no requirements.