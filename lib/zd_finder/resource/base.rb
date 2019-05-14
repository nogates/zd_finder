# frozen_string_literal: true

module ZdFinder
  module Resource
    # Base Resource class. It provides all the common code that can be shared
    # between resources, such as the search methods and the hashie definitions
    class Base < Hashie::Dash
      include Hashie::Extensions::Dash::PropertyTranslation
      include Hashie::Extensions::IndifferentAccess

      class << self
        attr_reader :slug

        # initialize by default all the class variables required to store
        # the indexed data in memory, so it's faster to retrieve records
        # and their relations
        def inherited(subclass)
          super
          subclass.instance_variable_set("@collection", {})
          subclass.instance_variable_set("@indexed_fields", [])
          subclass.instance_variable_set("@indexes", {})
        end

        # retrieve a record by its primary id
        def find(id)
          @collection[id.to_s]
        end

        # perform different types of search depending on whether the field is
        # the pk (_id) or is part of an index. This allows us to perform the
        # searches a bit faster
        def where(field, value)
          field = field.to_sym
          value = value.to_s

          if field == :_id
            [ find(value) ].compact
          elsif @indexed_fields.include?(field)
            (@indexes.dig(field, value) || []).map { |id| find(id) }
          else
            find_in_collection(field, value)
          end
        end

        # find_in_collection iterates over the whole resource collection and
        # returns the records that match the field value
        def find_in_collection(field, value)
          @collection.values.select do |item|
            field_value = item.public_send(field)

            if field_value.is_a?(Array)
              field_value.include?(value)
            else
              field_value.to_s == value
            end
          end
        end

        # add the record to the main collection index and to all the other indexes
        # that have been defined in the class
        def index_record(entry)
          @collection[entry._id.to_s] = entry

          @indexed_fields.each do |field|
            value = entry.public_send(field).to_s

            @indexes[field] ||= {}
            @indexes[field][value] ||= []
            @indexes[field][value] << entry._id.to_s
          end
        end
      end

      def initialize(*args)
        super
        self.class.index_record(self)
      end
    end
  end
end
