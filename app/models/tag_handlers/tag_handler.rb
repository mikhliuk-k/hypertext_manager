class TagHandler

  attr_reader :tag_name, :params, :body
  attr_accessor :children

  # @param parameters [String, nil]
  # @param body [String, nil]
  def initialize(parameters = nil, body = nil, children: [], skip_validate: false)
    @tag_name = self.tag_name
    @params = parse_parameters(parameters)
    @body = body
    @children = children

    validate unless skip_validate
  end

  # @return [String]
  def as_html
    @children.map(&:as_html).join
  end

  def as_text
    @children.map(&:as_text).join
  end

  # @return [Symbol]
  def self.tag_name
    raise NotImplementedError, "Method #{__method__} doesn't implemented."
  end

  def tag_name
    self.class.tag_name
  end

  def validate
    # Can be defined in inherited classes.
  end

  private

  # @param text [String, nil]
  # @return [Hash]
  def parse_parameters(text)
    return {} unless text
    parts = text.scan(/([\w-]+)\s*=\s*["'](.*?)["']/)
    parts.map {|name, value| [name.to_sym, value] }.to_h
  end

end