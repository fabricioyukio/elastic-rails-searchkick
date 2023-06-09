class PromptsController < ApplicationController
  before_action :set_prompt, only: %i[ show edit update destroy ]

  # GET /prompts or /prompts.json
  def index
    @prompts = Prompt.all
  end

  # GET /prompts/1 or /prompts/1.json
  def show; end

  # GET /prompts/new
  def new
    @prompt = Prompt.new
  end

  # GET /prompts/1/edit
  def edit; end

  # POST /prompts or /prompts.json
  def create
    @prompt = Prompt.new(original_index: params[:prompt][:original_index].to_i, content: params[:prompt][:content])
    respond_to do |format|
      if @prompt.save
        format.html { redirect_to root_url, flash: { success: 'Prompt was successfully created.' } }
        format.json { render :show, status: :created, location: @prompt }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @prompt.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /prompts/1 or /prompts/1.json
  def update
    respond_to do |format|
      updated = params[:prompt]
      if @prompt.update(original_index: updated[:original_index].to_i, content: updated[:content])
        format.html { redirect_to root_url, notice: 'Prompt was successfully updated.' }
        format.json { render :show, status: :ok, location: @prompt }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @prompt.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prompts/1 or /prompts/1.json
  def destroy
    @prompt.destroy

    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Prompt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_prompt
    @prompt = Prompt.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def prompt_params
    params.fetch(:prompt, {})
  end
end
