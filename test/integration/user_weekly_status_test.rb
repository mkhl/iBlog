# encoding: UTF-8

require File.join(File.expand_path(File.dirname(__FILE__)), '../integration_test_helper')

class UserWeeklyStatusTest < ActionDispatch::IntegrationTest
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

  test 'weekly status by author' do
    st_status = WeeklyStatus.new(status: 'sts current status').tap do |w|
      w.author = 'st'
      w.save
    end

    visit weekly_statuses_by_author_path(st_status.author)
    assert_content 'sts current status'
  end
end
