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

    def run(&block)
      # use instance_eval to execute the block
      # in the context of this ItBlock instance
      # i.e. `self` will be the ItBlock instance
      instance_eval( &block )
      # the & above is crucial: it converts the block to a Proc (?)
    end
  end


  def filter(&block)
    tmp = []
    for item in self do
      it_block = ItBlock.new(item)

      tmp << item if it_block.run(&block)
    end

    tmp
  end

end

Array.include ArrayIt

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
