require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:post_record) { create(:post) }

  describe "POST /posts/:post_id/comments" do
    context "with valid params" do
      let(:valid_params) { { comment: { author_name: "Alice", body: "Great post!" } } }

      it "creates a comment and redirects to the post" do
        expect { post post_comments_path(post_record), params: valid_params }
          .to change(Comment, :count).by(1)
        expect(response).to redirect_to(post_record)
      end
    end

    context "with invalid params" do
      let(:invalid_params) { { comment: { author_name: "", body: "" } } }

      it "does not create a comment and redirects with an alert" do
        expect { post post_comments_path(post_record), params: invalid_params }
          .not_to change(Comment, :count)
        expect(response).to redirect_to(post_record)
        follow_redirect!
        expect(response.body).to include("can&#39;t be blank")
      end
    end
  end

  describe "DELETE /posts/:post_id/comments/:id" do
    let!(:comment) { create(:comment, post: post_record) }

    it "destroys the comment and redirects to the post" do
      expect { delete post_comment_path(post_record, comment) }
        .to change(Comment, :count).by(-1)
      expect(response).to redirect_to(post_record)
    end
  end
end
