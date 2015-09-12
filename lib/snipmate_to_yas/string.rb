## Custom string extensions
class String
  # Remove leading white spaces from a HERE document
  def strip_heredoc
    gsub(/^#{scan(/^\s*/).min_by(&:length)}/, '')
  end
end
