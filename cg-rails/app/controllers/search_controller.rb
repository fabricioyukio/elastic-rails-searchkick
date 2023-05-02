class SearchController < ApplicationController
  def search
    @prompts = Prompt.search(params[:search])

    render turbo_stream:
      turbo_stream.update('prompts', partial: 'prompts/partials/list', locals: { prompts: @prompts })

  end
end