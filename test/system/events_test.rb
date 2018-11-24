require "application_system_test_case"

class EventsTest < ApplicationSystemTestCase
  setup do
    @event = events(:one)
  end

  test "visiting the index" do
    visit events_url
    assert_selector "h1", text: "Events"
  end

  test "creating a Event" do
    visit events_url
    click_on "New Event"

    fill_in "F D1", with: @event.f_d1
    fill_in "F D2", with: @event.f_d2
    fill_in "F D3", with: @event.f_d3
    fill_in "F L1", with: @event.f_l1
    fill_in "F L2", with: @event.f_l2
    fill_in "F L3", with: @event.f_l3
    fill_in "F S1", with: @event.f_s1
    fill_in "F S2", with: @event.f_s2
    fill_in "F S3", with: @event.f_s3
    fill_in "F V1", with: @event.f_v1
    fill_in "F V2", with: @event.f_v2
    fill_in "F V3", with: @event.f_v3
    fill_in "L D", with: @event.l_d
    fill_in "L L", with: @event.l_l
    fill_in "L S", with: @event.l_s
    fill_in "L V", with: @event.l_v
    fill_in "Name", with: @event.name
    fill_in "T D", with: @event.t_d
    fill_in "T L", with: @event.t_l
    fill_in "T S", with: @event.t_s
    fill_in "T V", with: @event.t_v
    click_on "Create Event"

    assert_text "Event was successfully created"
    click_on "Back"
  end

  test "updating a Event" do
    visit events_url
    click_on "Edit", match: :first

    fill_in "F D1", with: @event.f_d1
    fill_in "F D2", with: @event.f_d2
    fill_in "F D3", with: @event.f_d3
    fill_in "F L1", with: @event.f_l1
    fill_in "F L2", with: @event.f_l2
    fill_in "F L3", with: @event.f_l3
    fill_in "F S1", with: @event.f_s1
    fill_in "F S2", with: @event.f_s2
    fill_in "F S3", with: @event.f_s3
    fill_in "F V1", with: @event.f_v1
    fill_in "F V2", with: @event.f_v2
    fill_in "F V3", with: @event.f_v3
    fill_in "L D", with: @event.l_d
    fill_in "L L", with: @event.l_l
    fill_in "L S", with: @event.l_s
    fill_in "L V", with: @event.l_v
    fill_in "Name", with: @event.name
    fill_in "T D", with: @event.t_d
    fill_in "T L", with: @event.t_l
    fill_in "T S", with: @event.t_s
    fill_in "T V", with: @event.t_v
    click_on "Update Event"

    assert_text "Event was successfully updated"
    click_on "Back"
  end

  test "destroying a Event" do
    visit events_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Event was successfully destroyed"
  end
end
