require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class EntryTest < ActiveSupport::TestCase
  setup do
    @author = Author.for_handle 'someone'
    @blog = Blog.new(name: 'sample blog')
    @blog.author = @author
    @blog.save
  end

  test 'should save entry with valid attributes' do
    entry = Entry.new(title: 'Test-PPP', progress: 'My progress...')
    entry.blog = @blog
    entry.author = @blog.author
    assert entry.save
  end

  test 'should not save entry with invalid attributes' do
    entry = Entry.new
    refute entry.save, 'Saved entry with invalid attributes'
  end

  test 'attribute markdown conversion' do
    # required attributes
    entry = Entry.new(title: 'Test-PPP', progress: '# My progress')
    entry.regenerate_html

    assert entry.progress_html.include?('<h1>My progress</h1>')

    # add optional attributes
    entry.plans = 'My plans...'
    entry.problems = '* problem 1'
    entry.regenerate_html

    assert entry.plans_html.include?('<p>My plans...</p>')
    assert entry.problems_html.include?("<ul>\n<li>problem 1</li>\n</ul>\n")
  end

  test 'automatic attribute markdown conversion' do
    entry = Entry.new.tap do |e|
      e.title = 'Test-PPP'
      e.progress = '# My progress'
      e.plans = 'My plans...'
      e.problems = '* problem 1'
      e.blog = @blog
    end
    entry.author = Author.for_handle 'someone_with_a_problem'

    # attribute conversion should be triggered on `save`
    entry.save

    assert entry.progress_html.include?('<h1>My progress</h1>')
    assert entry.plans_html.include?('<p>My plans...</p>')
    assert entry.problems_html.include?("<ul>\n<li>problem 1</li>\n</ul>\n")
  end
end
