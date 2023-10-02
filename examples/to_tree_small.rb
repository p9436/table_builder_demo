# frozen_string_literal: true

require_relative '../elements/table'

# Output

table = Table.new rows: 1, cols: 2 do |t|
  t.header do |h|
    h.cell 'Col A'
    h.cell 'Col B'
  end
  t.row do |r|
    r.cell 'Cell 1-1'
    r.cell 'Cell 1-2'
  end
end

puts table.to_tree
