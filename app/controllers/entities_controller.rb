class EntitiesController < ApplicationController

  def index
    @entities = HypertextManager.load_all
  end

end