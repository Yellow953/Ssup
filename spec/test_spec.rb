require 'rails_helper'

RSpec.describe "Welcome", type: :feature do
  scenario 'index page' do
    visit root_path
    expect(page).to have_content('Login')  
  end

  it " Room test" do
    expect(Room.new(name: "test")).to be_valid
  end

  it " User test" do
    expect(User.new(email: "test@test.com", password:"qwe123" ,password_confirmation:"qwe123", name:"test")).to be_valid
  end
end