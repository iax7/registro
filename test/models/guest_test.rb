require 'test_helper'

class GuestTest < ActiveSupport::TestCase

  def setup
    @adult = guests(:adult)
    @child = guests(:child)

    @event_full_price = 100
    @event_no_price = 0
    @food_full_price = 50
    @food_half_price = 25
    @lodging_full_price = 100
    @lodging_half_price = 50
    @transport_full_price= 100
    @transport_half_price= 50
  end

  test "Name is titlesize" do
    @adult.validate
    assert_equal @adult.name, @adult.name.titleize.strip.squish.freeze
    assert_equal @adult.lastname, @adult.lastname.titleize.strip.squish.freeze
    assert_equal @adult.nick, @adult.nick.titleize.strip.squish.freeze
  end

  test "age is correct" do
    assert_equal true, @adult.adult?
    assert_equal false, @child.adult?
  end

  test "cost of services are correct" do
    assert_equal @event_full_price, @adult.costs_per_service(:assist)
    assert_equal @food_full_price, @adult.costs_per_service(:food)
    assert_equal @lodging_full_price, @adult.costs_per_service(:lodging)
    assert_equal @transport_full_price, @adult.costs_per_service(:transport)

    assert_equal @event_no_price, @child.costs_per_service(:assist)
    assert_equal @food_half_price, @child.costs_per_service(:food)
    assert_equal @lodging_half_price, @child.costs_per_service(:lodging)
    assert_equal @transport_half_price, @child.costs_per_service(:transport)
  end

  test "assist cost is correct" do
    assert_equal @event_full_price, @adult.assist_cost
  end

  test "food cost is correct" do
    food_attr = @adult.attributes.select { |k,_| k.to_s.match(/^f_[vsdl]\d$/) }
    requested = food_attr.select { |_,v| v }
    assert_equal 12, food_attr.size
    assert_equal 12, requested.size
    assert_equal (@food_full_price * 12), @adult.food_cost
  end

  test "lodging cost is correct" do
    lodging_attr = @adult.attributes.select { |k,_| k.to_s.match(/^l_[vsdl]$/) }
    requested = lodging_attr.select { |_,v| v }
    assert_equal 4, lodging_attr.size
    assert_equal 4, requested.size
    assert_equal (@lodging_full_price * 4), @adult.lodging_cost
  end

  test "transport cost is correct" do
    trans_attr = @adult.attributes.select { |k| k.to_s.match(/^t_[vsdl]\d$/) }
    requested = trans_attr.select { |_,v| v }
    assert_equal 8, trans_attr.size
    assert_equal 8, requested.size
    assert_equal (@transport_full_price * 8), @adult.transport_cost
  end

  test "total cost is correct" do
    assert_equal 1900, @adult.total
  end
end
