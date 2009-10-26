module Sunspot #:nodoc:
  module Rails #:nodoc:
    # 
    # This module provides Sunspot Adapter implementations for ActiveRecord
    # models.
    #
    module Adapters
      class ActiveRecordInstanceAdapter < Sunspot::Adapters::InstanceAdapter
        # 
        # Return the primary key for the adapted instance
        #
        # ==== Returns
        # 
        # Mixed:: Database ID of model
        #
        def id
          @instance.send( @instance.class.primary_key )
        end
      end

      class ActiveRecordDataAccessor < Sunspot::Adapters::DataAccessor
        # options for the find
        attr_accessor :include
        
        # 
        # Get one ActiveRecord instance out of the database by ID
        #
        # ==== Parameters
        #
        # id<String>:: Database ID of model to retreive
        #
        # ==== Returns
        #
        # ActiveRecord::Base:: ActiveRecord model
        # 
        def load(id)
          id = id.to_i if numeric_primary_key?
          @clazz.find(id, :include => (@include || []))
        end

        # 
        # Get a collection of ActiveRecord instances out of the database by ID
        #
        # ==== Parameters
        #
        # ids<Array>:: Database IDs of models to retrieve
        #
        # ==== Returns
        #
        # Array:: Collection of ActiveRecord models
        #
        def load_all(ids)
          ids = ids.map { |id| id.to_i } if numeric_primary_key?
          @clazz.find(ids, :include => (@include || []))
        end
        
        
        protected
        
        def numeric_primary_key?
          Sunspot::Rails::Util.numeric_primary_key?( @clazz )
        end
      end
    end
  end
end
