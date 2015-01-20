require File.join(File.expand_path(File.dirname(__FILE__)), '../integration_test_helper')

class UserBlogTest < ActionDispatch::IntegrationTest
  test 'blog creation' do
    visit new_blog_path
    assert_content 'Neues Blog'

    fill_in 'Name', :with => ''
    click_button 'Blog erstellen'
    assert_content 'Das Blog konnte nicht gespeichert werden.'

    fill_in 'Name', :with => 'John Doe blog'
    fill_in 'Title', :with => 'blog-title'
    fill_in 'Owner', :with => 'jd'
    fill_in 'Description', :with => 'blog-description'

    click_button 'Blog erstellen'
    assert_content 'Das Blog wurde gespeichert.'

    visit blogs_path

    assert_content 'Blogs alle'
    assert_content 'John Doe'
    assert_content 'blog-description'

    click_link 'Bearbeiten'
    assert_content 'Blog bearbeiten'

    fill_in 'Name', :with => 'John Doe blog'
    click_button 'Blog aktualisieren'
    assert_content 'Das Blog wurde gespeichert.'
    assert_content 'John Doe blog'
  end
end
