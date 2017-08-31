TestRail Swagger Spec
---------------------

[Swagger](http://swagger.io) is an API-documentation format that can generate REST clients.

The scripts in this folder can create the Swagger spec for a specific TestRail installation (including all its custom case fields and result fields), which can then be converted to a client library in (as of this writing) any of the following languages:

> ActionScript, Apex, Bash, C# (.net 2.0, 4.0 or later), C++ (cpprest, Qt5, Tizen), Clojure, Dart, Elixir, Eiffel, Go, Groovy, Haskell, Java (Jersey1.x, Jersey2.x, OkHttp, Retrofit1.x, Retrofit2.x, Feign, RestTemplate, RESTEasy, Vertx), Kotlin, Lua, Node.js (ES5, ES6, AngularJS with Google Closure Compiler annotations) Objective-C, Perl, PHP, PowerShell, Python, Ruby, Rust, Scala, Swift (2.x, 3.x, 4.x), Typescript (Angular1.x, Angular2.x, Fetch, jQuery, Node)


Requirements
------------

You will need the following command line tools:

* `ruby` (version 2.0 or higher)
* `swagger-codegen` (e.g. `brew install swagger-codegen`)


Execution
----------

You will need to export the environment variables
* `TESTRAIL_API_USER` - a testrail username
* `TESTRAIL_API_KEY` - an auth key for that username (or the actual password, if you don't care about security)

In this example, we'll create a ruby API for an imaginary installation at https://example.testrail.net/index.php?/api/v2

```
# Generate the yaml file directly from TestRail
ruby generate-testrail-swagger.rb https://example.testrail.net/index.php?/api/v2 > my-spec.yaml

# Create the language-specific API
swagger-codegen generate -i my-spec.yaml -l ruby
```

You may find it useful to use some language specific configuration options with `swagger-codegen`.  E.g., in ruby you would specify the gem name, module name, gem description, etc.
