class LinkTagHandler < TagHandler

  def self.tag_name
    :link
  end

  # @return [String]
  def as_html
    href = params[:entity] ? "href=\"/editor?entity=#{params[:entity]}\"" : ''
    "<a #{href}>#{super}</a>"
  end

end