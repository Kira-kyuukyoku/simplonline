class QcmsController < ApplicationController

  def show
    @qcm = Qcm.find(params[:id])
    @lesson = @qcm.lesson
    @questions = @qcm.questions.order(:position)
  end

  def index
    @qcms = Qcm.all
  end

  def new
    @lesson = Lesson.find(params[:lesson_id])
    @available_authors = User.authors
  end

  def create
    lesson = Lesson.find(params[:lesson_id])
    qcm = lesson.qcms.new
    qcm.update_attributes(qcm_params)
    qcm.save!
    redirect_to new_lesson_qcm_question_path(lesson, qcm)
  end

  def edit
    @qcm = Qcm.find(params[:id])
    @lesson = @qcm.lesson
    @available_authors = User.authors
  end

  def update
    qcm = Qcm.find(params[:id])
    qcm.update_attributes(qcm_params)
    redirect_to lesson_qcm_path(qcm.lesson, qcm)
  end

  def destroy
    lesson = Lesson.find(params[:lesson_id])
    if lesson.online?
      flash[:notice] = I18n.t('notice.cant_delete_online_qcm')
    else
      qcm = lesson.qcms.find(params[:id])
      qcm.delete
    end
    redirect_to lesson_path(lesson)
  end

  private

  def qcm_params
    params.require(:qcm).permit(:title, :desc, author_ids: [])
  end
end
