require File.join(File.expand_path(File.dirname(__FILE__)), '../integration_test_helper')

class UserCommentTest < ActionDispatch::IntegrationTest
  test 'weekly status comment creation' do
    status = WeeklyStatus.new(status: 'pgs current status').tap do |w|
      w.author = Author.for_handle 'pg'
      w.save
    end

    visit weekly_status_path(status)
    assert_content 'pgs current status'
    assert_content 'Kommentare: 0'

    fill_in 'comment_content', with: 'comment on pgs current status'
    click_button 'Kommentar abgeben'

    assert_content 'Der Kommentar wurde gespeichert.'
    assert_content 'comment on pgs current status'

    visit weekly_statuses_path
    assert_content 'pgs current status'
    assert_content 'Kommentare: 1'
  end

  test 'entry comment creation' do
    pg = Author.for_handle 'pg'
    blog = Blog.new(name: 'pgs blog')
    blog.author = pg
    blog.save
    entry = Entry.new(title: 'pgs sample ppp', progress: 'pgs sample progress')
    entry.author = pg
    entry.tap do |e|
      e.author == pg
      e.blog = blog
      e.save
    end

    visit blog_entry_path(blog, entry)
    assert_content 'pgs sample ppp'
    assert_content 'pgs sample progress'
    assert_content 'Kommentare: 0'
    fill_in 'comment_content', with: 'comment on pgs sample progress'
    click_button 'Kommentar abgeben'

    assert_content 'Der Kommentar wurde gespeichert.'
    assert_content 'pgs sample ppp'
    assert_content 'Kommentare: 1'
    assert_content 'comment on pgs sample progress'
  end
end
