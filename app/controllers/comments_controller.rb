class CommentsController < ApplicationController
  before_action :set_post
  before_action :set_comment, only: %i[ destroy ]

  # POST /posts/:post_id/comments
  def create
    @comment = @post.comments.new(comment_params)

    if @comment.save
      redirect_to @post, notice: "Comment was successfully added."
    else
      redirect_to @post, alert: @comment.errors.full_messages.to_sentence
    end
  end

  # DELETE /posts/:post_id/comments/:id
  def destroy
    @comment.destroy!
    redirect_to @post, notice: "Comment was successfully removed.", status: :see_other
  end

  private

  def set_post
    @post = Post.find(params[:post_id])
  end

  def set_comment
    @comment = @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :author_name)
  end
end
