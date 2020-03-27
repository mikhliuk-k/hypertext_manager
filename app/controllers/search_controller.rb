class SearchController < ApplicationController

  def show
    @search_results = params[:query].blank? ? [] : SearchEngine.new(params[:query]).search
  end

  def check
    SearchEngine.new(params[:query]) unless params[:query].blank?
    render_ajax_ok
  end

end