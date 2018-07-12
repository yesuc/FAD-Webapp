require 'rails_helper'
require 'spec_helper'
RSpec.describe SessionsController, type: :controller do
  before do
   request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
 end

  describe "#create" do
    it "should successfully create a user" do
      get :create
      expect(response).to have_http_status(:redirect)
    end
  end

  describe "GET #destroy" do
    it "returns http success" do
      get :destroy
      expect(response).to have_http_status(:redirect)
    end
  end

end
