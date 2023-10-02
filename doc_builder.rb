# frozen_string_literal: true

# Table builder
#
# # Usage
# builder = DocBuilder.new(border: 1, cellpadding: 8, cellspacing: 2, class: 'tbl') do |t|
#   t.header do |h|
#     h.cell 'Col A'
#     h.cell 'Col B'
#   end
#   t.row do |r|
#     r.properties.append style: 'background: blue'
#     r.cell 'Cell 1'
#     r.cell 'Cell 2'
#   end
#   t.row do |r|
#     r.properties.append style: 'background: yellow'
#     r.cell do |c|
#       c.add Table.new(border: 1) do |t1|
#         t1.row do |r1|
#           r1.properties.append class: 'innerData', style: 'background: yellow, color: blue'
#           r1.cell 'Inner Cell 1'
#           r1.cell 'Inner Cell 2'
#         end
#       end
#     end
#     r.cell 4, class: 'green'
#   end
# end
#
# puts builder.to_tree
# puts builder.to_html
#

require_relative 'elements/table'

# TableBuilder class for building HTML tables.
class DocBuilder
  attr_reader :root_element

  # Initialize the table builder with the table element on the top of structure
  #
  def initialize(**properties, &block)
    @root_element = Table.new(**properties, &block)
  end

  # Generate HTML representation of the table and its elements.
  def to_html
    ['<!DOCTYPE html><html><body>', @root_element.to_html, '</body></html>'].join
  end

  # Generate text representation of the table hierarchy.
  def to_tree
    ['<pre>', @root_element.to_tree, '</pre>'].join
  end
end
