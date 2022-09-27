# frozen_string_literal: true

RSpec.describe User do
  describe "#is_member_of?" do
    let(:user) { create(:user) }
    let(:group) { create(:group) }
    subject { user.is_member_of?(group) }

    it "return truthy if user has join group" do
      user.join!(group)
      expect(subject).to be_truthy
    end
  end

  describe "#join!" do
    let(:user) { create(:user) }
    let(:group) { create(:group) }
    subject { user.join!(group) }

    it "relate group to user" do
      expect { subject }.to change { user.participated_groups.count }.from(0).to(1)
    end
  end

  describe "#quit!" do
    let(:user) { create(:user) }
    let(:group) { create(:group) }
    subject { user.quit!(group) }

    it "disrelate group to user" do
      user.join!(group)
      expect { subject }.to change { user.participated_groups.count }.from(1).to(0)
    end
  end
end
