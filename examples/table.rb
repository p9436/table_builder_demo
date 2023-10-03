# frozen_string_literal: true

require_relative '../elements/table'

table = Table.new(border: 1, cellpadding: 8, cellspacing: 2, rows: 2, cols: 3, width: '100%') do
  header do
    cell 'Col A', class: 'first'
    cell 'Col B'
    cell 'Col C'
  end
  row(style: 'background: white') do
    cell 'Cell 1-1'
    cell 'Cell 1-2'
    cell 'Cell 1-3', style: 'background: yellow'
  end
  row do
    properties.append style: 'background: gray'
    cell do
      table(border: 1) do
        row do
          properties.append class: 'innerData'
          cell 'Inner Cell 2-1', style: 'color: blue'
          cell 'Inner Cell 2-2', style: 'color: yellow'
        end
      end
    end
    cell '2-2', class: 'mid'
    cell '2-3', class: 'last', style: 'background: blue'
  end
end

puts table.to_html
