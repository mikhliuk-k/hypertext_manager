class ToolboxController < ApplicationController

  def show
    @all_entities = HypertextManager.load_all
  end

  def find
    source_hypertext = HypertextManager.load(params.require :source_entity)
    dest_hypertext = HypertextManager.load(params.require :dest_entity)
    @path = HypertextGraphSearcher.find_shortest_path(source_hypertext, dest_hypertext)
    render layout: false if request.xhr?
  end
end