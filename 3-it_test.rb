require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

# Rules
# -----
#
#   1. No use of aliases
#   2. No use of #each, #select or other higher order functions
#
# You code stars here:

module ArrayIt

  class ItBlock

    attr_reader :it

    def initialize(item)
      @it = item
    end

    def yield_to(&block)
      block.call
    end
  end


  def filter(&block)
    tmp = []
    for item in self do
      # Doesn't work:
      # block.define_singleton_method(:it) do
      #   item
      # end


      Object.class_eval do
        define_method(:it) do
          item
        end
      end

      tmp << item if yield block

      Object.class_eval do
        remove_method(:it)
      end

    end

    tmp
  end

end

class Array
  include ArrayIt
end

# Your code ends here.

class ItTest < Minitest::Test
  def test_it_block
    array = %w(foo Bar baz)
    the_character_b = 'b'
    assert_equal %w(baz), array.filter {
      it.start_with? the_character_b
    }
  end

  def test_it_outside_block
    assert_raises(NameError) { it }
  end
end
