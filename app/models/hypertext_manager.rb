class HypertextManager

  TAG_NAME_PTRN = '(\\\\\w+)'
  PARAMS_PTRN = '(\[(?:[^\[\]]|\g<2>)*\])?'
  BODY_PTRN = '({(?:[^{}]|\g<3>)*})'
  TAG_PTRN = "#{TAG_NAME_PTRN}\\s*#{PARAMS_PTRN}\\s*#{BODY_PTRN}"
  TEXT_PTRN = '([^\\\\]+)' # TODO: Pattern doesn't capture backslashes
  FULL_PTRN = /#{TAG_PTRN}|#{TEXT_PTRN}/
  ENTITIES_PATH = Rails.root.join('storage', 'entities')

  attr_reader :tags

  # @param raw_text [#to_s]
  def initialize(raw_text, skip_validate: false)
    @raw_text = raw_text
    @tag_handlers = get_handlers
    @skip_validate = skip_validate
    @tags = text_to_tags(raw_text)
  end

  def identifier
    get_tag(:name).params[:identifier]
  end

  # @return [String]
  def as_html
    map_tag(&:as_html).join
  end

  # @return [String]
  def as_raw
    @raw_text
  end

  def get_tag(tag_name)
    find_tag { |tag| tag.tag_name == tag_name.to_sym }
  end

  def get_tags(*tag_names)
    tag_names.map! &:to_sym
    select_tags { |tag| tag.tag_name.in? tag_names }
  end

  def get_linked_hypertexts
    entities = get_tags(:link).map { |l| l.params[:entity] }.compact
    self.class.load(*entities)
  end

  # @param block [Proc]
  # @yieldparam tag [TagHandler]
  def each_tag(tags = nil, &block)
    (tags || @tags).each do |tag|
      block.call(tag)
      each_tag(tag.children, &block)
    end
  end

  # @param block [Proc]
  # @yieldparam tag [TagHandler]
  def map_tag(tags = nil, &block)
    (tags || @tags).map do |tag|
      map_tag(tag.children, &block)
      block.call(tag)
    end
  end

  # @param block [Proc]
  # @yieldparam tag [TagHandler]
  def find_tag(tags = nil, &block)
    result_tag = nil

    (tags || @tags).each do |tag|
      if block.call(tag)
        result_tag = tag
        break
      end

      result_tag ||= find_tag(tag.children, &block)
      break if result_tag
    end

    result_tag
  end

  # @param block [Proc]
  # @yieldparam tag [TagHandler]
  def select_tags(tags = nil, &block)
    result_tags = []

    (tags || @tags).each do |tag|
      result_tags << tag if block.call(tag)
      result_tags += select_tags(tag.children, &block)
    end

    result_tags
  end

  def save
    name_tag = @tags.find { |t| t.tag_name == :name }
    raise "Tag `name` doesn't found in this article." unless name_tag
    raise "Tag `name` doesn't have `identifier` parameter." if name_tag.params[:identifier].blank?

    save_entity(name_tag.params[:identifier])
  end

  def ==(another_text)
    identifier == another_text.identifier
  end

  def has_relation?(rel_entity, to:)
    rel_entity = self.class.load(rel_entity)
    to_entity = self.class.load(to)

    get_tags(:rel).any? do |rel_tag|
      rel_tag.params[:type] == rel_entity.identifier && rel_tag.params[:to] == to_entity.identifier
    end
  end

  # @param entity_names [String, Symbol, HypertextManager]
  def self.load(*entity_names)
    texts = entity_names.map do |entity_name|
      return entity_name if entity_name.is_a? self
      entity_path = Rails.root.join(ENTITIES_PATH, entity_name + '.entity')
      file = File.read entity_path rescue nil
      raise "Entity `#{entity_name}` not found." unless file

      new(file, skip_validate: true)
    end

    texts.count == 1 ? texts.first : texts
  end

  def self.has?(entity_name)
    !!(load(entity_name) rescue nil)
  end

  def self.load_all
    entities = Dir[Rails.root.join(ENTITIES_PATH, '*.entity')]
    entities.map { |entity| new File.read(entity) }
  end

  private

  # @param raw_text [String]
  # @return [<TagHandler>]
  def text_to_tags(raw_text)
    text_parts = raw_text.scan(FULL_PTRN).reject { |parts| parts.all?(&:blank?) }

    text_parts.map do |tag_name, params, body, text|
      tag_name = tag_name.strip[/\\(.*)/m, 1].strip rescue nil
      params = params.strip[/^\[(.*?)\]$/m, 1].strip rescue nil
      body = body.strip[/^{(.*)}$/m, 1].strip rescue nil

      if text
        TextTagHandler.new(nil, text, skip_validate: @skip_validate)
      else
        tag_handler = @tag_handlers[tag_name.to_sym]
        raise "Unknown tag #{tag_name}." unless tag_handler

        tag_handler.new(params, body, children: body ? text_to_tags(body) : [], skip_validate: @skip_validate)
      end
    end
  end

  # @return [Hash]
  def get_handlers
    Dir[Rails.root.join(*%w[app models tag_handlers *])].each(&method(:require))
    @tag_handlers = TagHandler.descendants.map { |h| [h.tag_name, h] }.to_h
  end

  def save_entity(name)
    entity_path = Rails.root.join(ENTITIES_PATH, name + '.entity')
    index_path = Rails.root.join(ENTITIES_PATH, name + '.index')

    File.write(entity_path, @raw_text)
    File.write(index_path, "stub")
  end

  def entity_exists?(name)
    entities = Dir[Rails.root.join(ENTITIES_PATH, '*')].map { |a| [File.basename(a, '.*'), true] }.to_h
    entities[name]
  end

  def snake_case(string)
    string.gsub(/\W+/, '_').strip.downcase
  end

end