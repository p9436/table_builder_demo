# frozen_string_literal: true

require_relative '../properties'
require_relative 'renderer/html'
require_relative 'renderer/tree'

# Element Base class
class ElementBase
  attr_accessor :children,
                :content,
                :parent,
                :properties

  class << self
    # Class-level tag setter.
    #
    # @param [Symbol] name
    # @return [Symbol]
    def tag=(name)
      @tag_name = name.to_sym
    end

    # Class-level tag getter. Raises an error if not defined.
    #
    # @return [Symbol]
    def tag
      # raise ElementTagNotDefinedError, '+' unless @tag_name

      @tag_name
    end
  end

  # Initializes an element with optional content and properties.
  # The +tag+ must be defined in child class
  #
  # @param [String, Numeric, NilClass] content
  # @param [Hash] properties
  def initialize(content = nil, parent: nil, **properties)
    raise ElementTagNotDefinedError unless tag

    @children   = []
    @content    = content
    @parent     = parent

    init_properties(**properties)
    yield(self) if block_given?
    do_after
  end

  # Initializes properties. Can be redefined in an element class to customize properties.
  # Example:
  # class Table
  #   def assign_properties(**props)
  #     props[:width] ||= 'auto'
  #   end
  # end
  #
  # @param [Hash] _properties
  def assign_properties(_properties); end

  # Callback after initialization
  def do_after; end

  # Adds a child element to this element.
  #
  # @param [Object<ElementBase>] element
  def add(element)
    children.push element
    yield(element) if block_given?
  end

  def method_missing(method_name, *args, **props, &block)
    klass_name = method_name.to_s.split('_').map(&:capitalize).join
    if Object.const_defined?(klass_name)
      klass = Object.const_get(klass_name)
      return klass.create(args, parent: self, **props, &block) if defined?(klass)
    end

    raise NoMethodError, "undefined method '#{method_name}' for #{self}:#{self.class}", caller
  end

  def respond_to_missing?(method_name, _include_private = false)
    method_name == :header
  end

  # Generates text representation of the element hierarchy.
  #
  def to_tree
    ::Renderer::Tree.format(self)
  end

  # Generates HTML representation of the element and its children.
  #
  # @return [String]
  def to_html
    ::Renderer::Html.format(self)
  end

  # Tag name for instance
  #
  # @return [Symbol]
  def tag
    self.class.tag
  end

  private

  # Initializes properties
  # Use +assign_properties+ to customize in element class
  #
  # @param [Hash] properties
  def init_properties(**properties)
    assign_properties(properties)
    @properties = Properties.new(**properties)
  end
end
