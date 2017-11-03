require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

# Rules
# -----
#
#   1. Only use for/while/until or recursion for iteration
#
# You code starts here:

module Elukerable

  def _all?(&block)
    return true if count == 0

    if test(first, block)
      tail._all?(&block)
    else
      false
    end
  end

  def _any?(&block)
    return false if count == 0

    if test(first, block)
      true
    else
      tail._any?(&block)
    end
  end

  def _map(&block)
    return [] if count == 0

    [ block.call(first) ] + tail._map(&block)
  end

  alias_method :_collect, :_map

  def _count(n = 1, &block)
    __internal_count(0, 0, n, block)
  end

  # Could make this private to hide it and then use `send` here, but that looks ugly.
  def __internal_count(iteration_counter, counter, n, block)
    return counter if count == 0

    new_counter = if iteration_counter % n == 0 && test(first, block)
                    counter + 1
                  else
                    counter
                  end
    tail.__internal_count( iteration_counter + 1, new_counter, n, block)
  end

  def _detect(&block)
    return nil if count == 0

    if test(first, block)
      first
    else
      tail._detect(&block)
    end
  end

  def _drop(n)
    raise ArgumentError.new("Can't drop negative number") if n < 0

    if n == 0
      self
    else
      tail._drop(n - 1)
    end
  end

  def _drop_while(&block)
    return [] if count == 0
    if test(first, block)
      tail._drop_while(&block)
    else
      _map{|i| i}  # convert self to an array
    end
  end

  def _each_cons(n, &block)
    if n <= count
      yield _take(n)
      tail._each_cons(n, &block)
    end
  end

  def _take(n)
    return [] if n == 0 || count == 0

    raise ArgumentError.new("Can't take negative number") if n < 0

    [first] + tail._take(n - 1)
  end

  alias_method :_find, :_detect

  private

  def test(item, block = nil)
    if block
      block.call(item)
    else
      item
    end
  end

  def tail
    # Cheating:
    # drop(1)
    # or, to cheat somewhat less:
    # self[1, -1]
    # otherwise:
    tmp = []
    index = 0
    for item in self do
      tmp << item if index > 0
      index += 1
    end
    tmp
  end
end

Object.include Elukerable

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
    assert_equal 4, ary._count
    assert_equal 2, ary._count(2)
    assert_equal 3, ary._count{ |x| x%2==0 }
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
    assert_equal [], a._drop(6)
    assert_equal a, a._drop(0)
    assert_raises(ArgumentError) { a._drop(-1) }
  end

  def test_drop_while
    a = [1, 2, 3, 4, 5, 0]
    actual = a._drop_while { |i| i < 3 }
    assert_equal [3, 4, 5, 0], actual
    assert_equal [], a._drop_while { true }
    assert_equal a, a._drop_while { false }
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

  def test_take
    a = [1, 2, 3, 4, 5]
    assert_equal [1, 2, 3], a._take(3)
    assert_equal [1], a._take(1)
    assert_equal [], a._take(0)
    assert_equal a, a._take(7000)
    assert_equal a, a._take(5)
    assert_raises(ArgumentError) { a._take(-1) }
  end
end
