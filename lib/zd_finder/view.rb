# frozen_string_literal: true

require "erb"
require "pathname"
require "colorize"

module ZdFinder
  # Module that encapsulates all view logic / helpers.
  module View
    class << self
      VIEW_FOLDER = Pathname.new(__dir__).join("views")

      def render(template, variables = {})
        build_template(template, variables)
      end

      def colorize_boolean(value)
        value ? value.to_s.green.bold : value.to_s.red.bold
      end

      private

      def build_template(template, vars)
        template_binding = binding
        template_content = File.read(VIEW_FOLDER.join("#{ template }.txt.erb"))
        vars.each { |key, value| template_binding.local_variable_set(key, value) }

        ERB.new(template_content).result(template_binding)
      end
    end
  end
end
