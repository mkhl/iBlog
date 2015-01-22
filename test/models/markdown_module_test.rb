require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class MarkdownModuleTest < ActiveSupport::TestCase
  test 'markdown rendering availbility' do
    # classes with markdown conversion capability
    entity_types = [Entry, Comment, WeeklyStatus]

    entity_types.each do |klass|
      entity = klass.new
      assert entity.respond_to?('md_to_html'), 'should respond to md_to_html()'
      assert entity.md_to_html('# Headline').include? '<h1>Headline</h1>'
    end
  end
end
