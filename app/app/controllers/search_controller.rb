class SearchController < ApplicationController
  def search

    puts "\n\n\n\tSEARCH #{params[:search]}\n\n\n"
    page = (params[:page] || 1).to_i
    size = (ENV['DEFAULT_PAGE_SIZE'] || 25).to_i
    offset = (page - 1) * size
    puts "\n\n\noffset: #{offset}"
    puts "\n\n\nQUERY: #{params[:search]}"
    puts "\n\n\n"
    @prompts = Prompt.search(params[:search],
                            fields: [:content],
                            operator: "or")
    @prompts = Prompt.search('*') if params[:search].blank?

    render turbo_stream: turbo_stream.update('prompts',
            partial: 'prompts/partials/list',
            locals: { prompts: @prompts })
    # respond_to do |format|
    #   format.html  { render :index }
    #   format.turbo_stream do

    #   end
    # end
  end
end