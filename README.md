# Capistrano::Aws::Hosts

Provides an interface to retrieve host inventory from AWS for deployment to a dynamic range of targets.

This depends on EC2 hosts being tagged with the Role tag (e.g. Role=Dashboard)

This plugin is for Capistrano 3 - sorry, no love for version 2...

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
    gem 'capistrano-aws-hosts'
end
```

And then add the following to your Capfile:

```ruby
require 'capistrano/aws/hosts'
```

Add defaults to your config/deploy.rb file:

```ruby
set :aws_hosts_filter, 'Dashboard'
set :aws_region, 'ap-southeast-2'
```

Finally, in your config/deploy/environment_name.rb files:

```ruby
set :aws_profile, 'sandbox' # Optional
hosts = fetch_aws_hosts.map(&:private_ip)
role :web, hosts
role :app, hosts
role :worker, hosts
role :db,  hosts.first
```

## Usage

The call to `fetch_aws_hosts` will return an array of Structs with the following values:

```ruby
    private_ip: '10.0.0.1'
    instance_id: 'i-abc123de456bb'
    name: 'PROD-PRIVATE-DASHBOARD-A'
```

## Testing
This has been manually tested specifically to our AWS environment, and while this should work across other AWS environments I cannot guarantee this will be the case. 

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/capistrano-aws-hosts. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
