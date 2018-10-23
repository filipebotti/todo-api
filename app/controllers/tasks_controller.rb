class TasksController < ApplicationController

  before_action :set_task, only: [:show, :update, :destroy]
  before_action :is_owner, only: [:show, :update, :destroy]
  # GET /tasks
  def index

    if params[:status].present? && (params[:status] == "all" || params[:status] == "discarded")
      @tasks = Task.all_tasks(@current_user) if params[:status] == "all"
      @tasks = Task.discarded(@current_user) if params[:status] == "discarded"
    else
      @tasks = Task.user_tasks(@current_user)
    end
    render json: @tasks
  end

  # GET /tasks/1
  def show
    render json: @task
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tasks/1
  def destroy
    @task.discard

    head :ok
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    def is_owner      
      render(json: { "error": "Unauthorized" }, status: :unauthorized) unless @current_user.id == @task.user_id
    end

    # Only allow a trusted parameter "white list" through.
    def task_params
      params.require(:task).permit(:description, :user_id)
    end
end
