class EditorController < ApplicationController

  def show
    @hypertext = HypertextManager.load(params[:entity]) if params[:entity]
  end

  def preview
    render json: {result: HypertextManager.new(params[:text]).as_html}
  end

  def update
    raise "Text can't be empty." if params[:text].empty?
    HypertextManager.new(params[:text]).save
  end

  private

  def parse_text

  end

end