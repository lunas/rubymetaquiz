require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'pry'

# Resources
# ---------
#
#   - https://ruby-doc.org/core-2.4.2/Module.html#method-i-included
#   - https://ruby-doc.org/core-2.4.2/Module.html#method-i-define_method
#   - https://ruby-doc.org/core-2.4.2/Object.html#method-i-define_singleton_method
#   - https://ruby-doc.org/core-2.4.2/Object.html#method-i-instance_variable_get
#   - https://ruby-doc.org/core-2.4.2/Object.html#method-i-instance_variable_set
#   - https://ruby-doc.org/core-2.4.2/Object.html#method-i-send
#
# You code stars here:


# Your code ends here.

module Magic

  module ClassMethods

    def prop(attr_name, attr_type, opts = {} )

      options = ({readonly: false, default: ->{ nil }}).merge(opts)

      define_method(attr_name) do
        instance_variable_get("@#{attr_name}") || options[:default].call
      end

      define_method("#{attr_name}=") do |value|
        if value.kind_of? attr_type
          instance_variable_set("@#{attr_name}", value)
        else
          raise TypeError.new("#{value} is not an instance of #{attr_type}")
        end
      end

      if options[:readonly]
        private "#{attr_name}="
      end
    end

    def method(method_name, &block)
      define_method(method_name, &block)
    end

    def class_method(method_name, &block)
      define_singleton_method(method_name) do
        yield block
      end
    end
  end

  def self.included(klass)
    klass.extend ClassMethods
  end

  def initialize(args = {})
    args.each do |key, value|
      send("#{key}=", value)
    end
  end
end

class Dog
  include Magic

  prop :name, String
  prop :age, Integer, readonly: true
  prop :breed, String, default: -> { 'Street Doggo' }

  method :bark do
    "Wuff, my name is #{name} and I'm a #{breed}"
  end

  method :add do |x, y|
    x + y
  end

  class_method :name do
    'DOGGO'
  end


end


class DslTest < Minitest::Test
  def setup
    @dog = Dog.new name: 'Fido', age: 7, breed: 'Border Collie'
  end

  def test_readers
    assert_equal 'Fido', @dog.name
    assert_equal 7, @dog.age
  end

  def test_bark
    assert_equal "Wuff, my name is Fido and I'm a Border Collie", @dog.bark
  end

  def test_add
    assert_equal 42, @dog.add(13, 29)
  end

  def test_class_method
    assert_equal 'DOGGO', Dog.name
  end

  def test_readonly_props
    refute_respond_to @dog, :age=
  end

  def test_default_value_for_props
    dog = Dog.new

    assert_nil dog.age
    assert_nil dog.name

    assert_equal 'Street Doggo', dog.breed
  end

  def test_type_checking
    assert_raises(TypeError) do
      @dog.name = 123
    end

    assert_raises(TypeError) do
      Dog.new(name: 'felix', age: 12.9999)
    end
  end
end
