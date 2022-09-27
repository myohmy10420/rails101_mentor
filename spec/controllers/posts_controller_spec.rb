# frozen_string_literal: true
RSpec.describe PostsController do
  let(:user) { create(:user) }
  let(:group) { create(:group) }

  describe "GET new" do
    let(:new_post) { Post.new }
    subject { get :new, params: { group_id: group.id } }

    before do
      allow(Post).to receive(:new).and_return(new_post)
      sign_in(user)
    end

    it "get new group and response expected" do
      subject

      expect(assigns(:post)).to eq(new_post)

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    let(:params) do
      {
        group_id: group.id,
        post: { content: "content" }
      }
    end
    subject { post :create, params: params }

    before { sign_in(user) }

    it "response expected" do
      subject

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(group_path(group))
    end

    context "when save post" do
      before { params.merge!(commit: "Save") }

      it "the created post is pending" do
        subject

        expect(assigns(:post).status).to eq("pending")
      end
    end

    context "when submit post" do
      before { params.merge!(commit: "Submit") }

      it "the created post is verifying" do
        subject

        expect(assigns(:post).status).to eq("verifying")
      end
    end
  end

  describe "GET edit" do
    let(:user_post) { create(:post, author: user, group: group) }
    subject { get :edit, params: { group_id: group.id, id: user_post.id } }

    before { sign_in(user) }

    it "get the group response expected" do
      subject

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT update" do
    let(:user_post) { create(:post, author: user, group: group) }
    let(:post_params) { { content: "updated content" } }
    subject { put :update, params: { group_id: group.id, id: user_post.id, post: post_params } }

    before { sign_in(user) }

    it "update the group response expected" do
      subject

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(group_path(group))
      expect(user_post.reload.content).to eq("updated content")
    end
  end

  describe "DELETE destroy" do
    let(:user_post) { create(:post, author: user, group: group) }
    subject { delete :destroy, params: { group_id: group.id, id: user_post.id } }

    before do
      user_post
      sign_in(user)
    end

    it "delete the group response expected" do
      expect { subject }.to change { user.posts.count }.from(1).to(0)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(group_path(group))
    end
  end
end
