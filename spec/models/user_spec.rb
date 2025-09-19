require 'rails_helper'

RSpec.describe User, type: :model do
  context "with a valid user" do
    # let is used to lazily declare a variable that is accessible in tests.
    # To eagerly run it before the test, use let!
    # FactoryBot's `create` will create a record in the database based off of the factory.
    # `build` will create a record in memory, but not save it to the database.
    let(:user) { create(:user) }

    it "is valid with valid attributes" do
      expect(user).to be_valid
    end

    it "is not valid without an email" do
      user.email = nil
      expect(user).to be_invalid

      # You can also use FactoryBot methods directly in the tests, and you may
      # pass in the attributes as a hash.
      # expect(build(:user, email: nil)).to be_invalid
    end
  end
end
