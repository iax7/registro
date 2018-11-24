require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @event = events(:one)
  end

  test "should get index" do
    get events_url
    assert_response :success
  end

  test "should get new" do
    get new_event_url
    assert_response :success
  end

  test "should create event" do
    assert_difference('Event.count') do
      post events_url, params: { event: { f_d1: @event.f_d1, f_d2: @event.f_d2, f_d3: @event.f_d3, f_l1: @event.f_l1, f_l2: @event.f_l2, f_l3: @event.f_l3, f_s1: @event.f_s1, f_s2: @event.f_s2, f_s3: @event.f_s3, f_v1: @event.f_v1, f_v2: @event.f_v2, f_v3: @event.f_v3, l_d: @event.l_d, l_l: @event.l_l, l_s: @event.l_s, l_v: @event.l_v, name: @event.name, t_d: @event.t_d, t_l: @event.t_l, t_s: @event.t_s, t_v: @event.t_v } }
    end

    assert_redirected_to event_url(Event.last)
  end

  test "should show event" do
    get event_url(@event)
    assert_response :success
  end

  test "should get edit" do
    get edit_event_url(@event)
    assert_response :success
  end

  test "should update event" do
    patch event_url(@event), params: { event: { f_d1: @event.f_d1, f_d2: @event.f_d2, f_d3: @event.f_d3, f_l1: @event.f_l1, f_l2: @event.f_l2, f_l3: @event.f_l3, f_s1: @event.f_s1, f_s2: @event.f_s2, f_s3: @event.f_s3, f_v1: @event.f_v1, f_v2: @event.f_v2, f_v3: @event.f_v3, l_d: @event.l_d, l_l: @event.l_l, l_s: @event.l_s, l_v: @event.l_v, name: @event.name, t_d: @event.t_d, t_l: @event.t_l, t_s: @event.t_s, t_v: @event.t_v } }
    assert_redirected_to event_url(@event)
  end

  test "should destroy event" do
    assert_difference('Event.count', -1) do
      delete event_url(@event)
    end

    assert_redirected_to events_url
  end
end
