require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "GET #new" do
    it "renders :new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "logs user in" do
        post :create, params: { user: attributes_for(:user) }
        expect(session[:session_token]).to eq(User.last.session_token)
      end

      it "redirects to user show" do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to redirect_to(user_url(User.last))
      end

      it "sets the success flash" do
        post :create, params: { user: attributes_for(:user) }
        expect(flash[:success]).to eq("Welcome!")
      end
    end

    context "with invalid params" do
      it "redirects to :new" do
        post :create, params: { user: { username: "Sam" } }
        expect(response).to redirect_to(new_user_url)
      end

      it "sets the failure flash" do
        post :create, params: { user: { username: "Sam" } }
        expect(flash[:failure]).to_not be nil
      end
    end
  end

  describe "GET #show" do
    context "with valid params" do
      it "renders :show template" do
        create :user
        get :show, params: {id: User.last.id}
        expect(response).to render_template(:show)
      end
    end

    context "with invalid params" do
      it "raises an error" do
        expect do
          get :show, params: {id: 1000000000}
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
  end
end

