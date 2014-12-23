class SearchesController < ApplicationController

  def index
    if params[:id].present?
      @page = params[:page] || 0
      @result = Search.for(params[:id], @page * 10)
    end
  end

  def show
    @result = Search.find(params[:id])
  end

end
