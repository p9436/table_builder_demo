# frozen_string_literal: true

require_relative 'element_base'
require_relative 'element'
require_relative 'cell'

# Row element for table rows.
class Row < ElementBase
  self.tag = :tr

  attr_accessor :cols_counter

  # Add a row to the table.
  #
  # @param [Hash] properties
  # @param [Proc] block
  def self.create(content = nil, parent: nil, **properties, &block)
    parent.add Row.new(content, parent:, **properties, &block)

    return unless parent.rows&.positive?

    parent.rows_counter ? parent.rows_counter += 1 : parent.rows_counter = 1
  end

  # @param [Object<BaseElement>] parent
  # @param [NilClass] content
  # @param [Hash] properties
  def initialize(content = nil, parent: nil, **properties)
    @cols_counter = 0

    super
  end

  private

  # Callback after initialization
  # Check if the row contains the correct number of cols as defined in the table property
  #
  # rubocop:disable Metrics/CyclomaticComplexity
  def do_after
    return unless parent&.cols&.positive? && parent&.cols != cols_counter

    err = "Row #{parent&.rows_counter.to_i} contains #{cols_counter} cols, but #{parent&.cols.to_i} required"
    raise ElementTableWrongColsSize, err
  end
  # rubocop:enable Metrics/CyclomaticComplexity
end
