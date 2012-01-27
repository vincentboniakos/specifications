class CommentsController < ApplicationController
  before_filter :authenticate
  def create
  	@userstory = Userstory.find(params[:userstory_id])
    @comment = @userstory.comments.build(params[:comment])
    @comment.user_id = current_user.id
    if @comment.save
      respond_to do |format|
        format.html do
          if request.xhr?
            render :partial => "comments/comment", :locals => { :comment => @comment }, :layout => false, :status => :created
          end
        end
      end
    else
      respond_to do |format|
        format.html do
          if request.xhr?
            render :json => @comment.errors, :status => :unprocessable_entity
          end
        end
      end
    end
  end

  def destroy
  	@comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id 
      @comment.destroy
      render :status => :accepted
    else
      render :status => :forbidden
    end
  end

end
