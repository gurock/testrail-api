# TestRail::Kit

TestRail::Kit provide client for TestRail by Ruby.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'testrail-kit', :git => 'git@github.com:daipresents/testrail-kit.git'
```

And then execute:

    $ bundle install


Setting environmental values like this:

```
$ export TESTRAIL_URL=https://yourdomain.testrai.io/
$ export TESTRAIL_USER=${EMAIL}
$ export TESTRAIL_PASSWORD=${API_KEY}
```

If you want to test this library, you need these environmental variables. Sorry, now I don't provide local testing.

## Usage

Please check spec files. You can see the usage of this library like this:

```ruby
client = TestRail::Client.new
plan = client.add_plan(payload)
```

You can set your values. url, user, password. 

```ruby
client = TestRail::Client.new('url', 'user', 'password')
```

For running test cases like this:

```
$ bundle exec rspec spec/lib/*_spec.rb
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/daipresents/testrail-kit.

## About TestRail

TestRail API Binding for Ruby
-----------------------------
 
You can learn more about TestRail's API and how to use the Ruby binding here:

http://docs.gurock.com/testrail-api2/start

http://docs.gurock.com/testrail-api2/bindings-ruby


For questions, suggestions, or other requests, please reach out to us through our support channels:

https://www.gurock.com/testrail/support
