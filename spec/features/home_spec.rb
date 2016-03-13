require 'spec_helper'

feature 'home page', vcr:true do
  #As a user, I want to see a welcome heading on the home page
  scenario 'users visit home page and feel welcome' do
    visit '/'
    expect(page).to have_content('Welcome to the Comic Finder')
  end
end
