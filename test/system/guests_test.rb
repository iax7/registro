require "application_system_test_case"

class GuestsTest < ApplicationSystemTestCase
  setup do
    @guest = guests(:one)
  end

  test "visiting the index" do
    visit guests_url
    assert_selector "h1", text: "Guests"
  end

  test "creating a Guest" do
    visit guests_url
    click_on "New Guest"

    fill_in "Age", with: @guest.age
    fill_in "F D1", with: @guest.f_d1
    fill_in "F D2", with: @guest.f_d2
    fill_in "F D3", with: @guest.f_d3
    fill_in "F L1", with: @guest.f_l1
    fill_in "F L2", with: @guest.f_l2
    fill_in "F L3", with: @guest.f_l3
    fill_in "F S1", with: @guest.f_s1
    fill_in "F S2", with: @guest.f_s2
    fill_in "F S3", with: @guest.f_s3
    fill_in "F V1", with: @guest.f_v1
    fill_in "F V2", with: @guest.f_v2
    fill_in "F V3", with: @guest.f_v3
    fill_in "Is Male", with: @guest.is_male
    fill_in "Is Medicated", with: @guest.is_medicated
    fill_in "Is Pregnant", with: @guest.is_pregnant
    fill_in "L D", with: @guest.l_d
    fill_in "L L", with: @guest.l_l
    fill_in "L Room", with: @guest.l_room
    fill_in "L S", with: @guest.l_s
    fill_in "L V", with: @guest.l_v
    fill_in "Lastname", with: @guest.lastname
    fill_in "Name", with: @guest.name
    fill_in "Nick", with: @guest.nick
    fill_in "Registry", with: @guest.registry_id
    fill_in "Relation", with: @guest.relation
    fill_in "T D1", with: @guest.t_d1
    fill_in "T D2", with: @guest.t_d2
    fill_in "T L1", with: @guest.t_l1
    fill_in "T L2", with: @guest.t_l2
    fill_in "T S1", with: @guest.t_s1
    fill_in "T S2", with: @guest.t_s2
    fill_in "T V1", with: @guest.t_v1
    fill_in "T V2", with: @guest.t_v2
    click_on "Create Guest"

    assert_text "Guest was successfully created"
    click_on "Back"
  end

  test "updating a Guest" do
    visit guests_url
    click_on "Edit", match: :first

    fill_in "Age", with: @guest.age
    fill_in "F D1", with: @guest.f_d1
    fill_in "F D2", with: @guest.f_d2
    fill_in "F D3", with: @guest.f_d3
    fill_in "F L1", with: @guest.f_l1
    fill_in "F L2", with: @guest.f_l2
    fill_in "F L3", with: @guest.f_l3
    fill_in "F S1", with: @guest.f_s1
    fill_in "F S2", with: @guest.f_s2
    fill_in "F S3", with: @guest.f_s3
    fill_in "F V1", with: @guest.f_v1
    fill_in "F V2", with: @guest.f_v2
    fill_in "F V3", with: @guest.f_v3
    fill_in "Is Male", with: @guest.is_male
    fill_in "Is Medicated", with: @guest.is_medicated
    fill_in "Is Pregnant", with: @guest.is_pregnant
    fill_in "L D", with: @guest.l_d
    fill_in "L L", with: @guest.l_l
    fill_in "L Room", with: @guest.l_room
    fill_in "L S", with: @guest.l_s
    fill_in "L V", with: @guest.l_v
    fill_in "Lastname", with: @guest.lastname
    fill_in "Name", with: @guest.name
    fill_in "Nick", with: @guest.nick
    fill_in "Registry", with: @guest.registry_id
    fill_in "Relation", with: @guest.relation
    fill_in "T D1", with: @guest.t_d1
    fill_in "T D2", with: @guest.t_d2
    fill_in "T L1", with: @guest.t_l1
    fill_in "T L2", with: @guest.t_l2
    fill_in "T S1", with: @guest.t_s1
    fill_in "T S2", with: @guest.t_s2
    fill_in "T V1", with: @guest.t_v1
    fill_in "T V2", with: @guest.t_v2
    click_on "Update Guest"

    assert_text "Guest was successfully updated"
    click_on "Back"
  end

  test "destroying a Guest" do
    visit guests_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Guest was successfully destroyed"
  end
end
