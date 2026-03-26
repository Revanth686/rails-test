require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject(:comment) { build(:comment) }

  describe "associations" do
    it { is_expected.to belong_to(:post) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_presence_of(:author_name) }
    it { is_expected.to validate_length_of(:author_name).is_at_most(100) }
  end

  describe "factory" do
    it "is valid with default attributes" do
      expect(build(:comment)).to be_valid
    end
  end
end
