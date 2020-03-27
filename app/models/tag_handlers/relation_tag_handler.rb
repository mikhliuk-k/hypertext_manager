class RelationTagHandler < TagHandler

  def self.tag_name
    :rel
  end

  def validate
    raise "Missing required parameter `type`." unless @params[:type]
    raise "Missing required parameter `to`." unless @params[:to]
    raise "Entity `#{@params[:type]}` doesn't exists." unless HypertextManager.has? @params[:type]
    raise "Entity `#{@params[:to]}` doesn't exists." unless HypertextManager.has? @params[:to]
  end

end