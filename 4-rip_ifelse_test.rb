require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

# You code stars here:


# Your code ends here.

class RipIfelseTest < Minitest::Test
  def test_if_true
    a = 1
    true.if_true { a = 9 }
    assert_equal 9, a
  end

  def test_if_false
    a = 1
    false.if_false { a = 10 }
    true.if_false { a = 9 }
    assert_equal 10, a
  end

  def test_truthiness
    a = 1
    "sdlkf".if_true { a = 19 }
    "sdlkf".if_false { a = 2 }
    assert_equal 19, a
  end

  def test_falseness
    a = 1
    nil.if_false { a = 4 }
    nil.if_true { a = 99 }
    assert_equal 4, a
  end

  def test_chaining
    a = 1

    (2 == 3).
      if_false { a = 99 }.
      if_true { a = 2 }

    assert_equal 99, a
  end

  def test_no_redundancy
    refute_includes FalseClass.instance_methods(false), :if_true
    refute_includes FalseClass.instance_methods(false), :if_false

    refute_includes TrueClass.instance_methods(false), :if_true
    refute_includes FalseClass.instance_methods(false), :if_false
  end
end
