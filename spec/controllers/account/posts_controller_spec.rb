# frozen_string_literal: true
RSpec.describe Account::PostsController do
  let(:user) { create(:user) }
  let(:user_post) { create(:post, user: user) }

  before { sign_in(user) }

  describe "GET index" do
    subject { get :index }

    it "action and response expected" do
      subject

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)

      expect(assigns(:posts)).to eq([user_post])
    end
  end

  describe "GET edit" do
    subject { get :edit, params: { id: user_post.id } }

    it "get the post response expected" do
      subject

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT update" do
    let(:post_params) { { content: "updated content" } }
    subject { put :update, params: { id: user_post.id, post: post_params } }

    it "update the group response expected" do
      subject

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(account_posts_path)
      expect(user_post.reload.content).to eq("updated content")
    end
  end

  describe "DELETE destroy" do
    subject { delete :destroy, params: { id: user_post.id } }

    it "delete the group response expected" do
      user_post
      expect { subject }.to change { user.posts.count }.from(1).to(0)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(account_posts_path)
    end
  end
end
