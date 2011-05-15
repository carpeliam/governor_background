module GovernorBackground
  module Resque
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