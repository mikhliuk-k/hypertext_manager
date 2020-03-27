class StyleTagHandler < TagHandler

  def self.tag_name
    :style
  end

  # @return [String]
  def as_html
    color_params = @params.map { |k, v| "#{k}: #{v}" }.join('; ')
    "<span style=\"#{color_params}\"> #{super} </span>"
  end

end