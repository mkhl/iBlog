require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class WeeklyStatusTest < ActiveSupport::TestCase
  test 'should save entry with valid attributes' do
    author = Author.for_handle 'muchwriter'
    status = WeeklyStatus.new(status: 'my current status')
    status.author = author
    assert status.save, 'Saved entry with valid attributes'
  end

  test 'should not save status with invalid attributes' do
    status = WeeklyStatus.new
    refute status.save
  end

  test 'attribute markdown conversion' do
    status = WeeklyStatus.new(status: '# My weekly status')
    status.regenerate_html

    assert status.status_html.include?('<h1>My weekly status</h1>')
  end

  test 'automatic attribute markdown conversion' do
    author = Author.for_handle 'opinionnatedwriter'
    status = WeeklyStatus.new(status: 'My awesome weekly status with **strong** test')
    status.author = author
    status.save

    # attribute conversion should be triggered on `save`
    status.save
    assert status.status_html.include?('<p>My awesome weekly status with <strong>strong</strong> test</p>')
  end
end
