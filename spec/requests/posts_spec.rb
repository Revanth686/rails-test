require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let!(:post_record) { create(:post, :published) }

  describe "GET /posts" do
    it "returns 200 OK" do
      get posts_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /posts/:id" do
    it "returns 200 OK for an existing post" do
      get post_path(post_record)
      expect(response).to have_http_status(:ok)
    end

    it "returns 404 for a missing post" do
      get post_path(id: 0)
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET /posts/new" do
    it "returns 200 OK" do
      get new_post_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /posts" do
    context "with valid params" do
      let(:valid_params) { { post: { title: "Hello World", body: "Some content here.", published: true } } }

      it "creates a new post and redirects" do
        expect { post posts_path, params: valid_params }
          .to change(Post, :count).by(1)
        expect(response).to redirect_to(Post.last)
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { post: { title: "", body: "" } } }

      it "does not create a post and returns unprocessable_entity" do
        expect { post posts_path, params: invalid_params }
          .not_to change(Post, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /posts/:id" do
    context "with valid params" do
      it "updates the post and redirects" do
        patch post_path(post_record), params: { post: { title: "Updated Title" } }
        expect(post_record.reload.title).to eq("Updated Title")
        expect(response).to redirect_to(post_record)
      end
    end

    context "with invalid params" do
      it "returns unprocessable_entity" do
        patch post_path(post_record), params: { post: { title: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /posts/:id" do
    it "destroys the post and redirects to index" do
      expect { delete post_path(post_record) }
        .to change(Post, :count).by(-1)
      expect(response).to redirect_to(posts_path)
    end
  end
end
