# frozen_string_literal: true
RSpec.describe GroupsController do
  let(:user) { create(:user) }

  describe "GET index" do
    subject { get :index }

    it "action and response expected" do
      group = create(:group)

      subject

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)

      expect(assigns(:groups)).to eq([group])
    end
  end

  describe "GET new" do
    let(:new_group) { Group.new }
    subject { get :new }

    before do
      allow(Group).to receive(:new).and_return(new_group)
      sign_in(user)
    end

    it "get new group and response expected" do
      subject

      expect(assigns(:group)).to eq(new_group)

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:new)
    end
  end

  describe "POST create" do
    let(:group_params) do
      {
        title: "title",
        description: "description"
      }
    end
    subject { post :create, params: { group: group_params } }

    before { sign_in(user) }

    it "response expected" do
      subject

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(groups_path)
    end

    it "create and join the group" do
      expect { subject }.to change { user.groups.count }.from(0).to(1) &
                            change { user.participated_groups.count }.from(0).to(1)
    end
  end

  describe "GET edit" do
    let(:group) { create(:group, owner: user) }
    subject { get :edit, params: { id: group.id } }

    before { sign_in(user) }

    it "get the group response expected" do
      subject

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:edit)
    end
  end

  describe "PUT update" do
    let(:group) { create(:group, owner: user) }
    let(:group_params) { { description: "updated description" } }
    subject { put :update, params: { id: group.id, group: group_params } }

    before { sign_in(user) }

    it "update the group response expected" do
      subject

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(groups_path)
      expect(group.reload.description).to eq("updated description")
    end
  end

  describe "DELETE destroy" do
    let(:group) { create(:group, owner: user) }
    subject { delete :destroy, params: { id: group.id } }

    before do
      group
      sign_in(user)
    end

    it "delete the group response expected" do
      expect { subject }.to change { user.groups.count }.from(1).to(0)

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(groups_path)
    end
  end
end
