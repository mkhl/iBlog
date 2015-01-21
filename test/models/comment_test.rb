require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class CommentTest < ActiveSupport::TestCase
  test 'markdown rendering' do
    comment = Comment.new
    assert comment.respond_to?('md_to_html'), 'respond to md_to_html()'
    assert comment.md_to_html('# Headline').include? '<h1>Headline</h1>'
  end
end
