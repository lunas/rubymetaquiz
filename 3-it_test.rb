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


# Your code ends here.

class ItTest < Minitest::Test
  def test_it_block
    array = %w(foo Bar baz)
    the_character_b = 'b'
    assert_equal %w(baz), array.filter { it.start_with? the_character_b }
  end

  def test_it_outside_block
    assert_raises(NameError) { it }
  end
end
