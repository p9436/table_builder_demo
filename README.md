# DSL for Building HTML Tables

This DSL (Domain-Specific Language) allows you to easily create HTML tables with headers and rows. 
It simplifies the process of generating table structures by providing a more
intuitive and structured way to define tables in your Ruby code.

## Example

Here's a basic example of how to create an HTML table using the DSL:

```ruby
# Include the DSL file
require_relative 'element_base'

# Create a table
table = Table.new(border: 1, cellpadding: 8, cellspacing: 2, rows: 2, cols: 3, width: '100%') do
  header do
    cell 'Col A', class: 'first'
    cell 'Col B'
    cell 'Col C'
  end
  row(style: 'background: blue') do
    cell 'Cell 1-1'
    cell 'Cell 1-2'
    cell 'Cell 1-3'
  end
  row do
    properties.append style: 'background: yellow'
    cell do 
      table(border: 1) do
        row do
          properties.append class: 'innerData', style: 'background: yellow, color: blue'
          cell 'Inner Cell 2-1'
          cell 'Inner Cell 2-2'
        end
      end
    end
    cell '2-2', class: 'mid'
    cell '2-3', class: 'last'
  end
end

puts table.to_html
```

This code creates an HTML table with headers, rows, and various properties.

## DSL Syntax

The DSL provides a simple and intuitive syntax for creating tables:

- `Table.new(properties)`: Create a new table builder instance. You can specify properties for the entire 
  table, such as `border`, `cellpadding`, `cellspacing`, and others. 
  Additionally, you can specify the number of rows and cols. 
  The builder will raise an error if the number of rows and cols does not match the specified values.

- `header`: Define the table's header. You can add header cells within the block.

- `row(properties)`: Define a table row. You can add row cells within the block and specify row-level properties.

- `cell(content, properties)`: Define a cell within a row. You can set the cell's content and properties, 
  and even nest tables or other elements inside cells.

- `properties` You can specify element properties as an argument, such as `t.row(class: 'gray')`, or as a method:
  ```ruby
  t.row do |r|
    r.properties.append class: 'gray'
  end
  ```

## Examples

You can find more examples in the [examples](./examples) directory, including complex table structures 
and customizations.

To run the examples, use 

```shell
ruby ./examples/document_builder.rb > out.html && open out.html
ruby ./examples/table.rb > out.html && open out.html
```

## Tests

To run tests, use
```shell
ruby ./examples/document_builder.rb > examples/document_builder.html
```
