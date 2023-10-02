# frozen_string_literal: true

module Renderer
  # Render element as hierarchical text tree
  #
  class Tree
    # @param [Object<ElementBase>] element
    def self.format(element)
      format_element(element)
    end

    class << self
      private

      def format_element(element, deep = 0)
        out = []
        out << "\n" unless deep.zero?
        out << ('_' * deep)
        out << element.tag.to_s
        out << ' ' << element.content

        element.children.each do |child|
          out << format_element(child, deep + 2)
        end
        out.join
      end
    end
  end
end
