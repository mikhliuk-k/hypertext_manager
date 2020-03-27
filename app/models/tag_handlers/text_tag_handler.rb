class TextTagHandler < TagHandler

  def self.tag_name
    :text
  end

  # @return [String]
  def as_html
    @body.gsub(/\n/, '<br>')
  end

  # @return [String]
  def as_text
    @body
  end

end