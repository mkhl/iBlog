require File.join(File.expand_path(File.dirname(__FILE__)), '../test_helper')

class UpdateAuthorsTest < ActiveSupport::TestCase

  setup do
    @update_task = Rake::Task['authors:update']
    # This only works when rake has been started at the root directory
    @testfile = "file://#{@update_task.application.original_dir}/test/integration/update_authors_test.data"
  end

  def make(handle, name, uri)
    a = Author.for_handle handle
    a.name = name
    a.avatar_uri = uri
    a.save
  end

  def check(handle, name, uri)
    a = Author.for_handle handle
    assert_equal name, a.name
    if uri.present?
      assert_equal uri, a.avatar_uri, "avatar uri for handle #{handle.inspect}"
    else
      assert_equal uri.present?, a.avatar_uri.present?, "Avatar URI should have been absent for #{a.handle}, was #{a.avatar_uri.inspect}"
    end
  end
  
  test 'hello world' do

    # Same data here and in the file, no change.
    make 'same_guy', 'Sebastian Same', 'https://example.com/sebastian_same.png'

    # No picture here, but have it in the file.
    make 'new_picture', 'Nadja Newpicture', 'http://old.picture'

    # Picture removed
    make 'no_picture', 'Simon Shy', 'http://papparazi.org/illegal_shot.jpg'

    # Name and avatar both changed
    make 'new_name', 'Julia Single', 'http://lonely.hearts/'

    # Left the company - no longer in the data at all
    make 'no_longer', 'Lukas Nolonger', 'http://old.hands/lukas.gif'

    @update_task.execute Rake::TaskArguments.new(['list_uri'], [@testfile])

    check 'same_guy', 'Sebastian Same', 'https://example.com/sebastian_same.png'
    check 'new_author', 'Anton Newauthor', 'https://norbert.new.picture/blah.jpg'
    check 'new_picture', 'Nadja Newpicture', 'https://example.com/nadja_newpicture'
    check 'no_picture', 'Simon Shy', nil
    check 'no_longer', 'Lukas Nolonger', nil
    check 'new_name', 'Justus Justmarried', 'https://lifechange.unorg/love.jpg'
  end
end
