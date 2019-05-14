# frozen_string_literal: true

require "optparse"
require "pathname"

module ZdFinder
  # Options based CLI Class to perform searches over resources
  class Cli
    def call
      option_parser.parse!

      validate_resource_class!(@query[:resource])
      validate_field!(@query[:field])

      search = ZdFinder::Search.call(@query)

      output "search_result", search: search
    rescue OptionParser::MissingArgument,
           OptionParser::InvalidArgument,
           OptionParser::InvalidOption => e
      warn e, option_parser
      exit 1
    end

    private

    # Disabled some of the metrics here since I don't think that using
    # OptionParser's DSL inside the same method / block creates too much
    # complexity, nor it's harder to read.
    def option_parser # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      @option_parser ||=
        OptionParser.new do |parser| # rubocop:disable Metrics/BlockLength
          @query = {}

          parser.banner = "Welcome to ZD Finder. Usage: zd_finder [options]"

          parser.on("-h", "--help", "Prints this help") do
            puts parser
            exit
          end

          parser.separator("")

          parser.on("-l", "--list-fields",
                    "Show all available searchable fields for each resource") do
            output "searchable_fields",
                   resource_classes: ZdFinder::Search.resource_classes
            exit
          end

          parser.separator("")

          parser.on("-r", "--resource resource", String,
                    "Select the resource you want to find. Must be one of: " \
                    "#{ resource_slugs.join(' ') }") do |resource|
            @query[:resource] = resource
          end

          parser.on("-f", "--field field", String,
                    "The field that will be used for filtering.") do |field|
            @query[:field] = field
          end

          parser.on("-v", "--value [value]", String,
                    "The expected value of the field. Leave it empty to " \
                    "search for empty values") do |value|
            @query[:value] = value
          end
        end
    end

    def validate_resource_class!(resource)
      if resource_classes_with_slugs.keys.include?(resource)
        @query[:resource_class] = resource_classes_with_slugs.fetch(resource)
      else
        raise(
          OptionParser::InvalidOption,
          "Invalid resource `#{ resource }`. You must choose one of: "\
          "#{ resource_classes_with_slugs.keys.join(' ') }"
        )
      end
    end

    def validate_field!(field)
      resource_class = @query[:resource_class]

      return if resource_class.properties.include?(field.to_sym)

      raise(
        OptionParser::InvalidOption,
        "The field `#{ field }` does not belong to `#{ resource_class.slug }`. "\
        "You must choose one of: `#{ resource_class.properties.to_a.join(' ') }`"
      )
    end

    def resource_slugs
      @resource_slugs ||= resource_classes_with_slugs.keys
    end

    def resource_classes_with_slugs
      @resource_classes_with_slugs ||= begin
        ZdFinder::Search.resource_classes.each_with_object({}) do |klass, hash|
          hash[klass.slug] = klass
        end
      end
    end

    def output(template, variables)
      puts ZdFinder::View.render(template, variables)
    end
  end
end
