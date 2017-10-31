require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

# Rules
# -----
#
#   1. No use of aliases
#   2. No use of #each, #select or other higher order functions, i.e. only use
#      for/while/until or recursion for iteration
#
#
# Notes
# -----
#
#   - Tip: Don't try to fix them all at once
#   - Extending core classes is bad practice and can result in nasty side
#     effects. This test is only here to help you reason about methods taking
#     blocks and extending existing classes.
#
#
# You code stars here:

module ArrayOnSteroid

  def project(&block)
    tmp = []
    for item in self do
      tmp << block.call(item)
    end

    tmp
  end

  def filter(&block)
    tmp = []
    for item in self do
      tmp << item if block.call(item)
    end

    tmp
  end
end

class Array
  include ArrayOnSteroid
end

# Your code ends here.

class WarmupTest < Minitest::Test
  def test_project_is_the_new_map
    array = ['hi', 'there']
    assert_equal ['HI', 'THERE'], array.project { |el| el.upcase }
  end

  def test_filter_is_the_new_select
    array = [1, 2, 3]
    assert_equal [2], array.filter(&:even?)
  end

  def test_filter_is_the_new_select_2
    array = %w(foo Bar baz)
    the_character_b = 'b'
    assert_equal %w(baz), array.filter { |el| el.start_with? the_character_b }
  end

  def test_bad_monkey
    methods = Array.instance_methods(false)
    refute_includes methods, :project
    refute_includes methods, :filter
  end
end
