# frozen_string_literal: true

require_relative 'element_base'

# Create an element with a specified tag
class Element < ElementBase
  def initialize(tag, content = nil, parent: nil, **properties, &block)
    @tag_name = tag
    super(content, parent:, **properties, &block)
  end

  def tag
    @tag_name
  end
end
