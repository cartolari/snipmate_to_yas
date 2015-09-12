require 'test_helper'

class StringTest < MiniTest::Test
  def test_it_removes_trailing_white_spaces_from_here_documetns
    here_doc = <<-EOF.strip_heredoc
    some string
    EOF

    assert_equal 'some string', here_doc.chomp
  end
end
