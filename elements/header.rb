# frozen_string_literal: true

require_relative 'element_base'
require_relative 'element'

# Header element for table rows.
class Header < ElementBase
  self.tag = :tr

  attr_accessor :cols_counter

  def self.create(content = nil, parent: nil, **properties, &block)
    parent.add Element.new(:thead) do |thead|
      thead.add Header.new(content, parent:, **properties, &block)
    end
  end

  def initialize(content = nil, parent: nil, **properties)
    @cols_counter = 0

    super
  end

  # Add a cell to the header.
  #
  # @param [Object] content
  # @param [Hash] properties
  # @param [Proc] block
  def cell(content, **properties, &block)
    add Element.new(:th, content, parent: self, **properties, &block)

    @cols_counter += 1 if @parent&.cols&.positive?
  end

  private

  # Callback after initialization
  # Check if the header contains the correct number of cols as defined in the table property
  #
  def do_after
    return unless parent&.cols&.positive? && parent&.cols != @cols_counter

    err = "Header contains #{@cols_counter} cols, but #{parent&.cols.to_i} required"
    raise ElementTableWrongColsSize, err
  end
end
