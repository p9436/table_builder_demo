# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../doc_builder' # Update the require path

# Tests for Element base class
#
# rubocop:disable Layout/LineLength
# rubocop:disable Metrics/MethodLength
class ElementBaseTest < Minitest::Test
  def test_initialize_base_element
    assert_raises(ElementTagNotDefinedError) do
      ElementBase.new('Content', class: 'example')
    end
  end
end

# Tests for Element class
#
class ElementTest < Minitest::Test
  def test_initialize
    element = Element.new(:div, 'Content', class: 'example', style: 'color: red')
    assert_equal :div, element.send(:tag)
    assert_equal 'Content', element.content
    assert_equal [], element.children
    assert_equal true, element.properties.any?
  end

  def test_to_html
    element = Element.new(:div, 'Content', class: 'example', style: 'color: red')
    result = '<div class="example" style="color: red">Content</div>'
    assert_equal result, element.to_html
  end

  def test_add_child
    parent = Element.new(:div, prop: 'parent')
    child = Element.new(:p, 'Content', prop: 'child')
    parent.add(child)
    assert_includes parent.children, child
    result = '<div prop="parent"><p prop="child">Content</p></div>'
    assert_equal result, parent.to_html
  end

  def test_add_child_block
    parent = Element.new(:div, prop: 'parent') do |e|
      e.add Element.new(:p, 'Content', prop: 'child')
    end
    result = '<div prop="parent"><p prop="child">Content</p></div>'
    assert_equal result, parent.to_html
  end

  def test_add_child_block_deep
    parent = Element.new(:div, prop: 'parent') do |e|
      e.add Element.new(:p, prop: 'child') do |e1|
        e1.add Element.new(:b, 'Content')
      end
    end
    result = '<div prop="parent"><p prop="child"><b>Content</b></p></div>'
    assert_equal result, parent.to_html
  end
end

# Tests for Table class
#
class ElementTableTest < Minitest::Test
  def test_initialize
    element = Table.new(class: 'example', style: 'color: red')

    assert_equal :table, element.send(:tag)
    assert_nil element.content
    assert_equal [], element.children
    assert_equal true, element.properties.any?
  end

  def test_to_html
    element = Table.new(class: 'example', style: 'color: red')

    result = '<table class="example" style="color: red" width="auto" height="auto"></table>'
    assert_equal result, element.to_html
  end

  def test_table_props
    element = Table.new(border: 1, cellpadding: 2, cellspacing: 4, width: '100%')

    result = '<table border="1" cellpadding="2" cellspacing="4" width="100%" height="auto"></table>'
    assert_equal result, element.to_html
  end

  def test_table_dimension_fail
    assert_raises(ElementTableWrongRowsSize) do
      Table.new rows: 1, cols: 2
    end

    assert_raises(ElementTableWrongColsSize) do
      Table.new rows: 1, cols: 2 do |t|
        t.row do |r|
          r.cell 'c1'
        end
      end
    end
  end

  def test_table_dimension_ok
    element = Table.new rows: 1, cols: 2 do |t|
      t.row do |r|
        r.cell 'c1'
        r.cell 'c2'
      end
    end

    result = '<table width="auto" height="auto"><tr><td>c1</td><td>c2</td></tr></table>'
    assert_equal result, element.to_html
  end

  def test_table_header_block
    element = Table.new do |t|
      t.header class: 'prop-h' do |h|
        h.cell 'col A'
        h.cell 'col B'
      end
    end
    result = '<table width="auto" height="auto"><thead><tr class="prop-h"><th>col A</th><th>col B</th></tr></thead></table>'
    assert_equal result, element.to_html
  end

  def test_table_row_block
    element = Table.new do |t|
      t.row class: 'row-1' do |r|
        r.cell '1-1'
        r.cell '1-2'
      end
      t.row class: 'row-2' do |r|
        r.cell '2-1'
        r.cell '2-2'
      end
    end
    result = '<table width="auto" height="auto"><tr class="row-1"><td>1-1</td><td>1-2</td></tr><tr class="row-2"><td>2-1</td><td>2-2</td></tr></table>'
    assert_equal result, element.to_html
  end
end
# rubocop:enable Layout/LineLength
# rubocop:enable Metrics/MethodLength
