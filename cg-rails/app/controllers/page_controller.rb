class PageController < ApplicationController
  def home
    prompts = Prompt.all.take(10)
  end

  def about
  end

  def contact
  end
end