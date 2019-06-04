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
$ export TESTRAIL_URL=https://yourdomain.testrai.io/'
$ export TESTRAIL_USER=${EMAIL}'
$ export TESTRAIL_PASSWORD=${API_KEY}'
$ export TESTRAIL_PROJECT_ID=${NUMBER}'
```

## Usage

Please check spec files. You can see the usage of this library like this:

```ruby
client = TestRail::Client.new(ENV['TESTRAIL_URL'])
plan = client.add_plan('Clientでつくったやーつ', '説明もかけます')
```

If you want to set your value for user, password, project_id, 

```ruby
client = TestRail::Client.new('https://daipresents.com')
client.initialize_all_param(new_user, new_password, new_project_id)
```

Run test case.

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
