require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

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
