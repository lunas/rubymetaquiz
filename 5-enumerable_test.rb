require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

# Rules
# -----
#
#   1. Only use for/while/until or recursion for iteration
#
# You code stars here:


# Your code ends here.

class EnumerableTest < MiniTest::Test
  def test_all
    assert %w[ant bear cat]._all? { |word| word.length >= 3 }
    refute %w[ant bear cat]._all? { |word| word.length >= 4 }
    refute [nil, true, 99]._all?
    assert []._all?
  end

  def test_any
    assert %w[ant bear cat]._any? { |word| word.length >= 3 }
    assert %w[ant bear cat]._any? { |word| word.length >= 4 }
    assert [nil, true, 99]._any?
    refute []._any?
  end

  def test_collect
    actual = (1..4)._map { |i| i*i }
    expected = [1, 4, 9, 16]
    assert_equal expected, actual

    actual = (1..4)._collect { "cat"  }
    expected = %w(cat cat cat cat)
    assert_equal expected, actual
  end

  def test_count
    ary = [1, 2, 4, 2]
    assert_equal ary._count, 4
    assert_equal ary._count(2), 2
    assert_equal ary._count{ |x| x%2==0 }, 3
  end

  def test_detect
    assert_nil (1..10)._detect { |i| i % 5 == 0 and i % 7 == 0 }
    assert_nil (1..10)._find { |i| i % 5 == 0 and i % 7 == 0 }

    actual = (1..100)._detect { |i| i % 5 == 0 and i % 7 == 0 }
    expected = 35
    assert_equal expected, actual

    actual = (1..100)._find { |i| i % 5 == 0 and i % 7 == 0 }
    expected = 35
    assert_equal expected, actual
  end

  def test_drop
    a = [1, 2, 3, 4, 5, 0]
    assert_equal [4, 5, 0], a._drop(3)
  end

  def test_drop_while
    a = [1, 2, 3, 4, 5, 0]
    actual = a._drop_while { |i| i < 3 }
    assert_equal [3, 4, 5, 0], actual
  end

  def test_each_cons
    results = []
    (1..10)._each_cons(3) { |a| results << a }
    assert_equal [1, 2, 3], results[0]
    assert_equal [2, 3, 4], results[1]
    assert_equal [3, 4, 5], results[2]
    assert_equal [4, 5, 6], results[3]
    assert_equal [5, 6, 7], results[4]
    assert_equal [6, 7, 8], results[5]
    assert_equal [7, 8, 9], results[6]
    assert_equal [8, 9, 10], results[7]
  end
end