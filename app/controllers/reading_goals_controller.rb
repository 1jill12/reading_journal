class ReadingGoalsController < ApplicationController
  before_action :set_goal, only: [:update, :destroy]

  def index
    @active_goals    = current_user.reading_goals.active.recent
    @completed_goals = current_user.reading_goals.completed.recent.limit(10)
    @abandoned_goals = current_user.reading_goals.where(status: 'abandoned').recent.limit(5)
    @new_goal        = ReadingGoal.new(year: Date.current.year, month: Date.current.month)
  end

  def create
    @goal = current_user.reading_goals.new(goal_params)

    if @goal.save
      redirect_to reading_goals_path, notice: "Goal created!"
    else
      @active_goals    = current_user.reading_goals.active.recent
      @completed_goals = current_user.reading_goals.completed.recent.limit(10)
      @abandoned_goals = current_user.reading_goals.where(status: 'abandoned').recent.limit(5)
      @new_goal        = @goal
      render :index, status: :unprocessable_entity
    end
  end

  def update
    if @goal.goal_type == 'custom' && params[:increment]
      new_progress = [(@goal.current_progress + params[:increment].to_i), @goal.target].min
      @goal.update(current_progress: new_progress)
    elsif params[:status]
      @goal.update(status: params[:status])
    else
      @goal.update(goal_params)
    end
    redirect_to reading_goals_path
  end

  def destroy
    @goal.destroy
    redirect_to reading_goals_path, notice: "Goal removed."
  end

  private

  def set_goal
    @goal = current_user.reading_goals.find(params[:id])
  end

  def goal_params
    params.require(:reading_goal).permit(:goal_type, :title, :target, :year, :month, :current_progress)
  end
end
