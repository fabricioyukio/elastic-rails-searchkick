class SearchController < ApplicationController
  def search
    @search = Search.new(params[:search])
    @results = @search.results
  end
end