require 'test_helper'

class GuestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @guest = guests(:one)
  end

  test "should get index" do
    get guests_url
    assert_response :success
  end

  test "should get new" do
    get new_guest_url
    assert_response :success
  end

  test "should create guest" do
    assert_difference('Guest.count') do
      post guests_url, params: { guest: { age: @guest.age, f_d1: @guest.f_d1, f_d2: @guest.f_d2, f_d3: @guest.f_d3, f_l1: @guest.f_l1, f_l2: @guest.f_l2, f_l3: @guest.f_l3, f_s1: @guest.f_s1, f_s2: @guest.f_s2, f_s3: @guest.f_s3, f_v1: @guest.f_v1, f_v2: @guest.f_v2, f_v3: @guest.f_v3, is_male: @guest.is_male, is_medicated: @guest.is_medicated, is_pregnant: @guest.is_pregnant, l_d: @guest.l_d, l_l: @guest.l_l, l_room: @guest.l_room, l_s: @guest.l_s, l_v: @guest.l_v, lastname: @guest.lastname, name: @guest.name, nick: @guest.nick, registry_id: @guest.registry_id, relation: @guest.relation, t_d1: @guest.t_d1, t_d2: @guest.t_d2, t_l1: @guest.t_l1, t_l2: @guest.t_l2, t_s1: @guest.t_s1, t_s2: @guest.t_s2, t_v1: @guest.t_v1, t_v2: @guest.t_v2 } }
    end

    assert_redirected_to guest_url(Guest.last)
  end

  test "should show guest" do
    get guest_url(@guest)
    assert_response :success
  end

  test "should get edit" do
    get edit_guest_url(@guest)
    assert_response :success
  end

  test "should update guest" do
    patch guest_url(@guest), params: { guest: { age: @guest.age, f_d1: @guest.f_d1, f_d2: @guest.f_d2, f_d3: @guest.f_d3, f_l1: @guest.f_l1, f_l2: @guest.f_l2, f_l3: @guest.f_l3, f_s1: @guest.f_s1, f_s2: @guest.f_s2, f_s3: @guest.f_s3, f_v1: @guest.f_v1, f_v2: @guest.f_v2, f_v3: @guest.f_v3, is_male: @guest.is_male, is_medicated: @guest.is_medicated, is_pregnant: @guest.is_pregnant, l_d: @guest.l_d, l_l: @guest.l_l, l_room: @guest.l_room, l_s: @guest.l_s, l_v: @guest.l_v, lastname: @guest.lastname, name: @guest.name, nick: @guest.nick, registry_id: @guest.registry_id, relation: @guest.relation, t_d1: @guest.t_d1, t_d2: @guest.t_d2, t_l1: @guest.t_l1, t_l2: @guest.t_l2, t_s1: @guest.t_s1, t_s2: @guest.t_s2, t_v1: @guest.t_v1, t_v2: @guest.t_v2 } }
    assert_redirected_to guest_url(@guest)
  end

  test "should destroy guest" do
    assert_difference('Guest.count', -1) do
      delete guest_url(@guest)
    end

    assert_redirected_to guests_url
  end
end
