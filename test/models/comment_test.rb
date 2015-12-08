require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class CommentTest < ActiveSupport::TestCase
  setup do
    @author = Author.for_handle 'rumpelstielzchen'
    @blog = Blog.new(name: 'sample blog')
    @blog.author = @author
    @blog.save
    @entry = Entry.new.tap do |e|
      e.blog = @blog
      e.title = 'Sample PPP'
      e.progress = 'Sample progress...'
      e.author = @author
      e.save
    end
  end

  test 'should save comment with valid attributes' do
    comment = Comment.new(content: 'Sample comment')
    comment.owner = @entry
    comment.owner_type = @entry.class
    comment.author = Author.for_handle 'sample_commenter'

    assert comment.save
  end

  test 'should not save comment with invalid attributes' do
    comment = Comment.new
    refute comment.save, 'Saved comment with invalid attributes'
  end

  test 'attribute markdown conversion' do
    comment = Comment.new(content: '# My comment')
    comment.regenerate_html

    assert comment.content_html.include?('<h1>My comment</h1>')
  end

  test 'automatic attribute markdown conversion' do
    comment = Comment.new(content: 'Comment with **strong** text')
    comment.owner = @entry
    comment.owner_type = @entry.class
    comment.author = Author.for_handle 'another_opinionated_author'

    # attribute conversion should be triggered on `save`
    comment.save
    
    assert comment.content_html.include?('<p>Comment with <strong>strong</strong> text</p>')
  end
end
