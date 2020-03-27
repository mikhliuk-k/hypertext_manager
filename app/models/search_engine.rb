class SearchEngine

  def initialize(raw_text)
    raise "Search text can't be empty." if raw_text.blank?

    @raw_text = raw_text.strip.downcase
    @conditions = []

    parse_query
  end

  def search
    HypertextManager.load_all.select &method(:check)
  end

  # @param entity [String, Symbol, HypertextManager]
  # return [Boolean]
  def check(entity)
    eval @conditions.map { |c| c.is_a?(Condition) ? c.check(entity).to_s : c.to_s }.join(' ')
  end

  private

  def parse_query
    conditions = @raw_text.scan(/[&|^]|[^&|^]*/).to_a.map(&:strip).reject(&:blank?)

    conditions.each_with_index do |condition, index|
      @conditions << ((index + 1).odd? ? Condition.new(condition) : condition)
    end
  end

end