require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class WeeklyStatusTest < ActiveSupport::TestCase
  test 'should save entry with valid attributes' do
    status = WeeklyStatus.new(status: 'my current status')
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
    status = WeeklyStatus.create(status: 'My awesome weekly status with **strong** test')

    # attribute conversion should be triggered on `save`
    status.save
    assert status.status_html.include?('<p>My awesome weekly status with <strong>strong</strong> test</p>')
  end
end
