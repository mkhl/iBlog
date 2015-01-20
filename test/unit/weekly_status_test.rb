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

  test 'markdown rendering' do
    status = WeeklyStatus.new
    assert status.respond_to?('md_to_html'), 'should respond to md_to_html()'
    assert status.md_to_html('# Headline').include? '<h1>Headline</h1>'
  end
end
