require "application_system_test_case"

class InterlinksTest < ApplicationSystemTestCase
  setup do
    @interlink = interlinks(:one)
  end

  test "visiting the index" do
    visit interlinks_url
    assert_selector "h1", text: "Interlinks"
  end

  test "creating a Interlink" do
    visit interlinks_url
    click_on "New Interlink"

    fill_in "Apply count", with: @interlink.apply_count
    fill_in "Keyword", with: @interlink.keyword
    fill_in "Slot", with: @interlink.slot
    fill_in "Url", with: @interlink.url
    click_on "Create Interlink"

    assert_text "Interlink was successfully created"
    click_on "Back"
  end

  test "updating a Interlink" do
    visit interlinks_url
    click_on "Edit", match: :first

    fill_in "Apply count", with: @interlink.apply_count
    fill_in "Keyword", with: @interlink.keyword
    fill_in "Slot", with: @interlink.slot
    fill_in "Url", with: @interlink.url
    click_on "Update Interlink"

    assert_text "Interlink was successfully updated"
    click_on "Back"
  end

  test "destroying a Interlink" do
    visit interlinks_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Interlink was successfully destroyed"
  end
end
