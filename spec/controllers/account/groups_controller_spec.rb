# frozen_string_literal: true
RSpec.describe Account::GroupsController do
  let(:user) { create(:user) }
  let(:group) { create(:group) }

  before do
    sign_in(user)
    user.join!(group)
  end

  describe "GET index" do
    subject { get :index }

    it "action and response expected" do
      subject

      expect(response).to have_http_status(:success)
      expect(response).to render_template(:index)

      expect(assigns(:groups)).to eq([group])
    end
  end
end
