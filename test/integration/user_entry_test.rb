require File.join(File.expand_path(File.dirname(__FILE__)), '../integration_test_helper')

class UserEntryTest < ActionDispatch::IntegrationTest
  test 'entry creation' do
    blog = Blog.create(name: 'guest blog', owner: 'guest')

    visit new_entry_path
    click_button 'PPP-Eintrag erstellen'
    assert_content 'Der Eintrag konnte nicht gespeichert werden.'

    select 'guest blog', :from => 'Blog'
    fill_in 'Titel', :with => 'guest-ppp-entry'
    fill_in 'Erreicht', :with => 'guest-progress'
    fill_in 'Geplant', :with => 'guest-plans'
    fill_in 'Probleme', :with => 'guest-problems'
    fill_in 'Tags', :with => 'tag1'
    click_button 'PPP-Eintrag erstellen'

    assert_content 'Der Eintrag wurde gespeichert.'
    assert_content 'guest-ppp-entry'
    assert_content 'guest-progress'
    assert_content 'guest-plans'
    assert_content 'guest-problems'
    assert_content 'tag1'

    click_link 'Bearbeiten'
    fill_in 'Titel', :with => 'awesome-guest-ppp-entry'
    fill_in 'Erreicht', :with => 'awesome-guest-progress'
    fill_in 'Geplant', :with => 'awesome-guest-plans'
    fill_in 'Probleme', :with => 'awesome-guest-problems'
    fill_in 'Tags', :with => 'awesome-tag1'

    click_button 'PPP-Eintrag aktualisieren'
    assert_content 'Der Eintrag wurde gespeichert.'
    assert_content 'awesome-guest-ppp-entry'
    assert_content 'awesome-guest-progress'
    assert_content 'awesome-guest-plans'
    assert_content 'awesome-guest-problems'
    assert_content 'awesome-tag1'
  end

  test 'entries by author' do
    blog = Blog.create(name: 'sts blog')
    entry = Entry.new(title: 'sts sample ppp', progress: 'sts sample progress').tap do |e|
      e.author = 'st'
      e.blog = blog
      e.save
    end

    visit blog_entries_by_author_path(entry.author)
    assert_content 'sts sample ppp'
  end

end
