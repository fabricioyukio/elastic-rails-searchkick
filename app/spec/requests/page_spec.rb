# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Page', type: :request do
  describe 'Home' do
    # pending "discover why works on NGROK but not on docker"
    it 'successfully renders the index template on GET /' do
      get root_path

      expect(response).to be_successful
      expect(response).to render_template(:home)
    end
  end
  describe 'About' do
    it 'access without errors' do
      get about_path
      expect(response).to have_http_status(:success)
      expect(response).to render_template(:about)
    end
  end
end
