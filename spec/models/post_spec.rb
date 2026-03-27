require 'rails_helper'

RSpec.describe Post, type: :model do
  subject(:post) { build(:post) }

  describe "associations" do
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:body) }
    it { is_expected.to validate_length_of(:title).is_at_most(255) }
  end

  describe "scopes" do
    let!(:published_post)   { create(:post, :published) }
    let!(:unpublished_post) { create(:post, published: false) }

    describe ".published" do
      it "returns only published posts" do
        expect(Post.published).to contain_exactly(published_post)
      end

      it "excludes unpublished posts" do
        expect(Post.published).not_to include(unpublished_post)
      end
    end

    describe ".search" do
      let!(:ruby_post)   { create(:post, title: "Ruby on Rails", body: "A web framework") }
      let!(:python_post) { create(:post, title: "Python basics", body: "A scripting language") }

      it "returns posts matching the title" do
        expect(Post.search("Ruby")).to include(ruby_post)
        expect(Post.search("Ruby")).not_to include(python_post)
      end

      it "returns posts matching the body" do
        expect(Post.search("scripting")).to include(python_post)
        expect(Post.search("scripting")).not_to include(ruby_post)
      end

      it "is case-insensitive" do
        expect(Post.search("ruby")).to include(ruby_post)
      end
    end
  end

  describe "factory" do
    it "is valid with default attributes" do
      expect(build(:post)).to be_valid
    end

    it "produces a published post with the :published trait" do
      expect(build(:post, :published).published).to be true
    end
  end
end
