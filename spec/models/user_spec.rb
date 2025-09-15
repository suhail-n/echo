require 'rails_helper'

RSpec.describe User, type: :model do
  context "with a valid user" do
    let(:user) { create(:user) }

    it "is valid with valid attributes" do
      expect(user).to be_valid
    end
  end
end
