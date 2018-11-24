require "application_system_test_case"

class RegistriesTest < ApplicationSystemTestCase
  setup do
    @registry = registries(:one)
  end

  test "visiting the index" do
    visit registries_url
    assert_selector "h1", text: "Registries"
  end

  test "creating a Registry" do
    visit registries_url
    click_on "New Registry"

    fill_in "Amount Debt", with: @registry.amount_debt
    fill_in "Amount Offering", with: @registry.amount_offering
    fill_in "Amount Paid", with: @registry.amount_paid
    fill_in "Comments", with: @registry.comments
    fill_in "Event", with: @registry.event_id
    fill_in "Is Confirmed", with: @registry.is_confirmed
    fill_in "Is Notified", with: @registry.is_notified
    fill_in "Is Present", with: @registry.is_present
    fill_in "User", with: @registry.user_id
    click_on "Create Registry"

    assert_text "Registry was successfully created"
    click_on "Back"
  end

  test "updating a Registry" do
    visit registries_url
    click_on "Edit", match: :first

    fill_in "Amount Debt", with: @registry.amount_debt
    fill_in "Amount Offering", with: @registry.amount_offering
    fill_in "Amount Paid", with: @registry.amount_paid
    fill_in "Comments", with: @registry.comments
    fill_in "Event", with: @registry.event_id
    fill_in "Is Confirmed", with: @registry.is_confirmed
    fill_in "Is Notified", with: @registry.is_notified
    fill_in "Is Present", with: @registry.is_present
    fill_in "User", with: @registry.user_id
    click_on "Update Registry"

    assert_text "Registry was successfully updated"
    click_on "Back"
  end

  test "destroying a Registry" do
    visit registries_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Registry was successfully destroyed"
  end
end
