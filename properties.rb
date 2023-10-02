# frozen_string_literal: true

# A list of properties for each table element
#
class Properties
  # @param [Hash] properties
  def initialize(**properties)
    @properties = properties.map { |name, value| Property.new(name, value) }
  end

  def any?
    @properties.any?
  end

  # Create new or override existing property value
  #
  # @param [Symbol, String] name
  # @param [Object] value
  def add(name, value)
    if (property = find(name))
      property.value = value
    else
      @properties << Property.new(name, value)
    end
  end

  def append(**new_properties)
    new_properties.each { |k, v| add k.to_sym, v }
  end

  # Find property by name
  #
  # @param [Symbol, String] name
  # @return [Property, NilClass]
  def find(name)
    name = Property.transform_key_name(name)
    @properties.find { |a| a.name == name }
  end

  # Transform properties to html-compatible format
  #
  # @return [String]
  def to_html
    @properties.map(&:to_html).join(' ')
  end
end

# A single key-value element of Properties list
#
class Property
  attr_reader   :name
  attr_accessor :value

  # Transform property name to html-compatible format
  #
  # @param [Symbol, String] name
  # @return [String]
  def self.transform_key_name(name)
    name.to_s.gsub('_', '-').freeze
  end

  # @param [Symbol, String] name
  # @param [Object] value
  def initialize(name, value)
    @name  = self.class.transform_key_name(name)
    @value = value
  end

  # @return [String (frozen)]
  def to_html
    "#{@name}=\"#{@value}\""
  end
end
