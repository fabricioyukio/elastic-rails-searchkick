class PageController < ApplicationController
  def home
    @prompts = Prompt.all.page params[:page] || 0
    @minimal_search = ENV['MINIMUM_SIZE_SEARCH'].to_i || 3
  end

  def about
  end

  def contact
  end
end