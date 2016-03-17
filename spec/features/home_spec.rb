require 'spec_helper'

feature 'home page', vcr:true do
  #As a user, I want to see a welcome heading on the home page
  scenario 'users visit home page and feel welcome' do
    visit '/'
    expect(page).to have_content('Welcome to the Comic Finder')
  end
end

feature 'home page', vcr:true do
  #As a user, I want to be able to click a link that takes me to a search page
  scenario 'user clicks link on home page' do
    visit '/'
    click_link 'Search For Comics'
    expect(page).to have_content('Search By Publisher')
    expect(page).to have_content('Search By Date Range')
    expect(page).to have_content('Search By Character')
  end
end
