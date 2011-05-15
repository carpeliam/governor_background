module GovernorBackground
  module Resque
    # Provides a way for ActiveRecord objects to be serialized to Resque.
    # ActiveRecord objects can't be sent directly to Resque, as Resque
    # serializes everything to JSON. +Resource+ provides an intermediate step.
    # Resources are serialized to a JSON representation of the resource type
    # (as registered in Governor) and the ID. When resources are deserialized,
    # they are automatically converted into the ActiveRecord objects they
    # represent.
    class Resource
      attr_reader :resource_key, :id
      def initialize(ar_resource)
        @resource_key = ar_resource.class.name.tableize
        @id = ar_resource.id
      end
      
      def to_hash
        self.instance_values.merge('json_class' => self.class.name)
      end
      
      def self.json_create(o)
        Governor.resources[o['resource_key'].to_sym].to.find(o['id'])
      end
    end
  end
end