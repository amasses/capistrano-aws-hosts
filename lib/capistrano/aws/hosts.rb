require "capistrano/aws/hosts/version"
require 'aws-sdk-ec2'
module Capistrano
  module Aws
    module Hosts
      # Fetches the hosts from AWS, filtering based on the tag 'Role' values (wildcarded)
      #
      # @return [Array<Struct(private_ip, instance_id, name>] array of instance records
      def fetch_aws_hosts
        role_name = fetch(:aws_hosts_filter)
        profile = fetch(:aws_hosts_profile) || ENV['AWS_PROFILE']
        region = fetch(:aws_region) || ENV['AWS_DEFAULT_REGION']
        
        raise 'Region is not specified - please set :aws_region or export AWS_DEFAULT_REGION as an environment variable' unless region.to_s != ''
        # raise "Profile is not specified - please set :aws_region or export AWS_DEFAULT_REGION as an environment variable" unless region.present?
        
        client = ::Aws::EC2::Client.new(region: region, profile: profile)

        instances = client.describe_instances(filters: [
          {name: 'instance-state-name', values: ['running']},
          {name: 'tag-key', values: ['Role']},
          {name: 'tag-value', values: ["*#{role_name}*"]}
        ])

        instances = instances.reservations.collect { |r| r.instances }.flatten
        result = instances.each_with_object([]) do |item, arr|
          arr << OpenStruct.new(
            private_ip: item.private_ip_address,
            instance_id: item.instance_id,
            name: item.tags.select {|t| t.key == 'Name'}.first.value
          )
        end

        print "Target hosts: #{result.map(&:name).join(', ')}\n"
        result
      end
    end
  end
end

include Capistrano::Aws::Hosts
