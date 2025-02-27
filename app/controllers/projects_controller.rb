class ProjectsController < ApplicationController
  load_and_authorize_resource
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authorize_manager, only: [:new, :create, :edit, :update, :destroy]

  def index
    @projects = current_user.projects
  end

  def show; end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      @project.user_ids = (params[:project][:user_ids] || []) + [current_user.id] # Ensure manager is added
      redirect_to projects_path, notice: "Project created successfully"
    else
      flash[:alert] = @project.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit; end

  def update
    if @project.update(project_params)
      @project.user_ids = (params[:project][:user_ids] || []) + [current_user.id] 
      redirect_to projects_path, notice: "Project updated successfully"
    else
      flash[:alert] = @project.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project deleted successfully."
  end

  private

  def authorize_manager
    redirect_to projects_path, alert: "Access denied!" unless current_user.manager?
  end

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, user_ids: [])
  end
end
