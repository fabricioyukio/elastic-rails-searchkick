class PageController < ApplicationController
  def home
    @prompts = Prompt.all.take(10)
    @minimal_search = ENV['MINIMUM_SIZE_SEARCH'].to_i || 3
  end

  def about
  end

  def contact
  end
end