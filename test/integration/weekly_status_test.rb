# encoding: UTF-8

require File.join(File.expand_path(File.dirname(__FILE__)), '../integration_test_helper')

class WeeklyStatusTest < ActionDispatch::IntegrationTest
  test 'weekly status creation' do
    visit new_weekly_status_path

    assert_content 'Wochenstatus erstellen'
    click_button 'Speichern'

    assert_content 'Der Eintrag konnte nicht gespeichert werden.'
    fill_in 'Status', :with => 'my weekly status'
    click_button 'Speichern'

    assert_content 'Der Eintrag wurde gespeichert.'
    assert_content 'my weekly status'

    click_link 'Bearbeiten'
    fill_in 'Status', :with => 'my awesome weekly status'
    click_button 'Speichern'

    assert_content 'Der Eintrag wurde geändert.'
    assert_content 'my awesome weekly status'
  end
end
