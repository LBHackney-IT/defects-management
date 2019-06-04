class Staff::CommentsController < Staff::BaseController
  def new
    @defect = Defect.find(defect_id)
    @comment = Comment.new
  end

  def create
    @defect = Defect.find(defect_id)
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @comment.defect = @defect

    if @comment.valid?
      @comment.save
      flash[:success] = I18n.t('generic.notice.create.success', resource: 'comment')
      redirect_to property_defect_path(@defect.property, @defect)
    else
      render :new
    end
  end

  def edit
    @defect = Defect.find(defect_id)
    @comment = Comment.find(id)
  end

  def update
    @defect = Defect.find(defect_id)
    @comment = Comment.find(id)
    @comment.assign_attributes(comment_params)

    if @comment.valid?
      @comment.save
      flash[:success] = I18n.t('generic.notice.update.success', resource: 'comment')
      redirect_to property_defect_path(@defect.property, @defect)
    else
      render :edit
    end
  end

  private

  def id
    params[:id]
  end

  def defect_id
    params[:defect_id]
  end

  def comment_params
    params.require(:comment).permit(:message)
  end
end
