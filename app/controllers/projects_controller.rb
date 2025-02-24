class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :authorize_manager, only: [:new, :create, :edit, :update, :destroy]

  def index
    if current_user.manager?
      @projects = Project.all
    else
      @projects = current_user.projects # Developers & QAs only see assigned projects
    end
  end
  

  def show
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)

    if @project.save
      assign_users_to_project
      redirect_to projects_path, notice: "Project created successfully and users assigned."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @project.update(project_params)
      assign_users_to_project
      redirect_to projects_path, notice: "Project updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: "Project deleted."
  end

  private

  def authorize_manager
    redirect_to projects_path, alert: "Access denied!" unless current_user.manager?
  end
  
  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description)
  end

  def assign_users_to_project
    # Remove existing project assignments to avoid duplicates
    @project.project_users.destroy_all
  
    # Assign QA users
    qa_users = User.where(id: params[:project][:qa_ids])
    qa_users.each do |qa|
      ProjectUser.create(user: qa, project: @project)
    end
  
    # Assign Developer users
    developer_users = User.where(id: params[:project][:developer_ids])
    developer_users.each do |dev|
      ProjectUser.create(user: dev, project: @project)
    end
  end
  
end
