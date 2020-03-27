class HeaderTagHandler < TagHandler

  def self.tag_name
    :header
  end

  # @return [String]
  def as_html
    level = @params[:level]&.to_i
    raise "Incorrect parameter #{@tag_name}.level" unless level
    raise "Level must be in range (1..6)" unless level.in? (1..6)

    "<h#{level}>#{super}</h#{level}>"
  end

end