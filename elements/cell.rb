# frozen_string_literal: true

require_relative 'element'

# Cell element for table rows
#
# Example:
#
#   t.row do |r|
#     r.cell 'Col A'
#     r.cell 'Col B'
#   end
# or
#   t.row do |r|
#     r.cell do |c|
#         c.add Table.new do |t1|
#           t1.row do |r1|
#             r1.cell 'Inner Cell 1'
#             r1.cell 'Inner Cell 2'
#           end
#         end
#       end
#     end
#   end
#
class Cell
  # Add a cell to the row
  #
  # @param [String, NilClass] content
  # @param [Object<ElementBase>] parent
  # @param [Hash] properties
  # @param [Proc] block
  def self.create(content = nil, parent: nil, **properties, &block)
    tag = parent.is_a?(Header) ? :th : :td
    element = Element.new(tag, content, parent:, **properties, &block)

    return unless parent

    parent.add element

    return unless (table = parent.parent) && (table.respond_to?(:cols) && table.cols.positive?)

    parent.cols_counter += 1
  end
end
