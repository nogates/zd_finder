# frozen_string_literal: true

module ZdFinder
  # This class defines the main Search interface to be used to find resources
  # the class provides a class method (#call) that ensures all the resources'
  # data have been loaded and returns an instance of the search with the
  # found resources and the possible errors that have been generated during the
  # search. This acts as the root aggregate object that can be used to render
  # all the information about the search.
  class Search
    DATA_FOLDER = Pathname.new(__dir__).join("../../data")

    class << self
      def call(options)
        ensure_resources_are_loaded!

        new(options).tap(&:call)
      end

      def resource_classes
        [
          ZdFinder::Resource::Ticket,
          ZdFinder::Resource::Organization,
          ZdFinder::Resource::User
        ]
      end

      def ensure_resources_are_loaded!
        return if @resources_loaded

        load_resources!
      end

      def load_resources!
        resource_classes.each do |resource_class|
          file_path = DATA_FOLDER.join("#{ resource_class.slug }.json")

          JSON.parse(File.read(file_path)).each do |entry|
            resource_class.new(entry)
          end
        end
        @resources_loaded = true
      end
    end

    attr_reader :error, :resources, :resource_class

    def initialize(options)
      @resource_class = options.fetch(:resource_class)
      @field = options.fetch(:field)
      @value = options.fetch(:value, "")
    end

    def call
      @resources = resource_class.where(@field, @value)
    rescue StandardError => e
      @error = e
    end
  end
end
