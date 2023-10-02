# frozen_string_literal: true

module Renderer
  # Render element as html
  class Html
    # @param [Object<ElementBase>] element
    def self.format(element)
      format_element(element)
    end

    class << self
      private

      def format_element(element)
        out = [format_open_tag(element)]
        out << element.content

        element.children.each do |child|
          out << format_element(child)
        end

        out << format_close_tag(element)

        out.join
      end

      def format_open_tag(element)
        ['<', element.tag.to_s, format_properties(element), '>'].join
      end

      def format_properties(element)
        return '' unless element.properties.any?

        [' ', element.properties.to_html].join
      end

      def format_close_tag(element)
        ['</', element.tag.to_s, '>'].join
      end
    end
  end
end
