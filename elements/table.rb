# frozen_string_literal: true

require_relative '../errors'
require_relative 'element_base'
require_relative 'element'
require_relative 'header'
require_relative 'row'

# Table element for creating tables
class Table < ElementBase
  self.tag = :table

  attr_accessor :rows, :rows_counter, # Number of rows in table
                :cols                 # Number of cols in table

  # Add a row to the table.
  #
  # @param [Hash] properties
  # @param [Proc] block
  def self.create(content = nil, parent: nil, **properties, &block)
    parent.add Table.new(content, parent:, **properties, &block)
  end

  def initialize(content = nil, parent: nil, **properties, &block)
    @rows_counter = 0
    super
  end

  # Modify properties on initialization step
  def assign_properties(props)
    @rows = props.delete(:rows).to_i
    @cols = props.delete(:cols).to_i
    props[:width]  ||= 'auto'
    props[:height] ||= 'auto'
  end

  private

  # Callback after initialization
  # Check if the table contains the correct number of rows as defined in the table property
  def do_after
    return unless @rows.positive? && @rows_counter != @rows

    err = "Table contains  #{@rows_counter.to_i} rows, but #{@rows} rows required"
    raise ElementTableWrongRowsSize, err
  end
end
