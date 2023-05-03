class SearchController < ApplicationController
  def search
    page = (params[:page] || 1).to_i
    size = (ENV['DEFAULT_PAGE_SIZE'] || 25).to_i
    offset = (page - 1) * size

    # OR operator: any of the search terms
    # AND operator: all of the search terms
    @prompts = Prompt.search(params[:search],
                            fields: [:content],
                            operator: "and",
                            page: page,
                            per_page: size)
    @prompts = Prompt.search('*',
                            page: page,
                            per_page: size) if params[:search].blank?

    render turbo_stream: turbo_stream.update('prompts',
            partial: 'prompts/partials/list',
            locals: { prompts: @prompts })
  end
end