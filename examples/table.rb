# frozen_string_literal: true

require_relative '../elements/table'

table = Table.new(border: 1, cellpadding: 8, cellspacing: 2, rows: 2, cols: 3, width: '100%') do |t|
  t.header do |h|
    h.cell 'Col A', class: 'first'
    h.cell 'Col B'
    h.cell 'Col C'
  end
  t.row(style: 'background: blue') do |r|
    r.cell 'Cell 1-1'
    r.cell 'Cell 1-2'
    r.cell 'Cell 1-3'
  end
  t.row do |r|
    r.properties.append style: 'background: yellow'
    r.cell do |c|
      c.add Table.new(border: 1) do |t1|
        t1.row do |r1|
          r1.properties.append class: 'innerData', style: 'background: yellow, color: blue'
          r1.cell 'Inner Cell 2-1'
          r1.cell 'Inner Cell 2-2'
        end
      end
    end
    r.cell '2-2', class: 'mid'
    r.cell '2-3', class: 'last'
  end
end

puts table.to_html
