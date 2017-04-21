require 'test_helper'

class GetSetHelperTest < Minitest::Test

  class Something
    attr_accessor :value
    def initialize(val)
      self.value = val
    end
  end

  def setup
    @simple_data = {
        alpha: 1,
        bravo: 2,
    }
    @complex_data = {
        alpha: Something.new(1),
        bravo: Something.new(2),
    }
  end

  def test_simple_get_set
    helper = SimpleTk::GetSetHelper.new(self, :@simple_data)

    # should retrieve the correct values
    # and allow setting existing values.
    assert_equal 1, helper[:alpha]
    helper[:alpha] = 'a'
    assert_equal 'a', helper[:alpha]

    assert_equal 2, helper[:bravo]
    helper[:bravo] = :bravo
    assert_equal :bravo, helper[:bravo]

    # should not allow retrieving invalid indexes
    assert_raises IndexError do
      helper[:charlie]
    end

    # should not allow setting invalid indexes
    assert_raises IndexError do
      helper[:charlie] = 3
    end
  end

  def test_complex_get_set_with_method
    helper = SimpleTk::GetSetHelper.new(self, :@complex_data, true, :value, :value=)

    # should retrieve the correct values
    # and allow setting existing values.
    # note that this is returning the value from the 'value' method and setting the value
    # with the 'value=' method.
    assert_equal 1, helper[:alpha]
    helper[:alpha] = 'a'
    assert_equal 'a', helper[:alpha]

    assert_equal 2, helper[:bravo]
    helper[:bravo] = :bravo
    assert_equal :bravo, helper[:bravo]

    # should not allow retrieving invalid indexes
    assert_raises IndexError do
      helper[:charlie]
    end

    # should not allow setting invalid indexes
    assert_raises IndexError do
      helper[:charlie] = 3
    end
  end

  def test_complex_get_set_with_proc
    helper = SimpleTk::GetSetHelper.new(self, :@complex_data, true, ->(val){ val.value }, ->(item,val){ item.value = val })

    # should retrieve the correct values
    # and allow setting existing values.
    # note that this is returning the value from the getter proc and setting the value
    # with the setter proc.
    assert_equal 1, helper[:alpha]
    helper[:alpha] = 'a'
    assert_equal 'a', helper[:alpha]

    assert_equal 2, helper[:bravo]
    helper[:bravo] = :bravo
    assert_equal :bravo, helper[:bravo]

    # should not allow retrieving invalid indexes
    assert_raises IndexError do
      helper[:charlie]
    end

    # should not allow setting invalid indexes
    assert_raises IndexError do
      helper[:charlie] = 3
    end
  end

end