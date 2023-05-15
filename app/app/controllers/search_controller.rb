class SearchController < ApplicationController
  def search
    page = (params[:page] || 0).to_i
    size = (ENV['DEFAULT_PAGE_SIZE'] || 25).to_i
    offset = (page - 1) * size

    search = params[:search] || nil
    if search.nil?
      render :index
    elsif search.length < (ENV['MINIMUM_SIZE_SEARCH'] || 3).to_i
      render turbo_stream: turbo_stream.update('prompts',
                partial: 'prompts/partials/not_allowed')
    else
      # OR operator: any of the search terms
      # AND operator: all of the search terms
      @prompts = Prompt.search(params[:search],
                              fields: [:content],
                              operator: "and",
                              page: page,
                              per_page: size)

      # MultiplePromptIndexerWorker.perform_async(search)
      Prompt.reindex
      render turbo_stream: turbo_stream.update('prompts',
              partial: 'prompts/partials/list',
              locals: { prompts: @prompts })

    end
  end
end