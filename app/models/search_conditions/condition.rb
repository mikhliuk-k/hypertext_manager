class Condition

  def initialize(raw_text)
    @from_entity, @rel_entity, @to_entity = nil
    parse_condition(raw_text)
  end

  def check(entity_name)
    entity = HypertextManager.load(entity_name)

    if @from_entity.nil?
      puts "(#{entity.identifier}) -> [#{@rel_entity.identifier}] -> (#{@to_entity.identifier})"
      entity.has_relation? @rel_entity, to: @to_entity
    else
      puts "(#{@from_entity.identifier}) -> [#{@rel_entity.identifier}] -> (#{entity.identifier})"
      @from_entity.has_relation? @rel_entity, to: entity
    end
  end

  private

  def parse_condition(raw_text)
    parts = raw_text.scan(/\((.*?)\)\s*(=>|<=)\s*\[(.*?)\]\s*(=>|<=)\s*\((.*?)\)/).first.map(&:strip)

    from, sign1, rel, sign2, to =
      if parts[1] == '=>' && parts[3] == '=>'
        parts
      elsif parts[1] == '<=' && parts[3] == '<='
        parts.reverse
      else
        raise "Incorrect equation `#{raw_text}`"
      end

    raise "Only one `?` allowed in condition `#{raw_text}`" if from == '?' && to == '?'
    raise "Lack of condition in equation `#{raw_text}`" if from != '?' && to != '?'

    @from_entity = from == '?' ? nil : HypertextManager.load(from)
    @to_entity = to == '?' ? nil : HypertextManager.load(to)
    @rel_entity = HypertextManager.load(rel)
  end

end