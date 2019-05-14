# frozen_string_literal: true

require "io/console"

module ZdFinder
  # Interactive CLI Class to perform searches over resources
  class Cli
    def call
      output "banner"

      # supresses `echo` until user hits `enter`
      STDIN.noecho { read_user_input }

      start_search
    end

    private

    def start_search
      output "main_menu"

      case (value = read_user_input)
      when "1" then select_resource
      when "2"
        output "searchable_fields", resource_classes: resource_classes
      else
        output "invalid_option",
               option: value, available_options: %w[1 2 quit]
        start_search
      end
    end

    def select_resource
      output "resource_menu",
             selectable_resource_classes: selectable_resource_classes
      case (value = read_user_input)
      when *selectable_resource_classes.keys
        resource_class = selectable_resource_classes.fetch(value)
        select_resource_field(resource_class)
      else
        output "invalid_option",
               option: value,
               available_options: selectable_resource_classes.keys + %w[quit]
        select_resource
      end
    end

    def select_resource_field(resource_class)
      output "field_menu"

      field = read_user_input

      if resource_class.properties.include?(field.to_sym)
        search_data(resource_class, field)
      else
        output "invalid_option",
               option: field,
               available_options: resource_class.properties.to_a + %w[quit]

        select_resource_field(resource_class)
      end
    end

    def search_data(resource_class, field)
      output "value_menu"

      search = ZdFinder::Search.call(
        resource_class: resource_class,
        field: field,
        value: read_user_input
      )

      output "search_result", search: search
    end

    def read_user_input
      $stdin.gets.chomp.tap { |value| exit if value == "quit" }
    end

    def resource_classes
      @resource_classes ||= ZdFinder::Search.resource_classes
    end

    def selectable_resource_classes
      @selectable_resource_classes ||=
        resource_classes.each_with_object({})
                        .with_index(1) do |(klass, options), index|
          options[index.to_s] = klass
        end
    end

    def output(template, variables = {})
      puts ZdFinder::View.render(template, variables)
    end
  end
end
