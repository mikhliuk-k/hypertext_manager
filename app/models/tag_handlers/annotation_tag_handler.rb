class AnnotationTagHandler < TagHandler

  def self.tag_name
    :annotation
  end

  # @return [String]
  def as_html
    super
  end

end