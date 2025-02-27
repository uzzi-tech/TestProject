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
      assign_users_to_new_project
      @project.project_users.create(user: current_user) 
      redirect_to projects_path, alert: "Project created successfully"
    else
      render :new
      flash[:alert] = @project.errors.full_messages.join(", ")
    end
  end  

  def edit
  end

  def update
    if @project.update(project_params)
      assign_users_to_existing_project
      redirect_to projects_path, alert: "Project updated successfully."
    else
      flash[:alert] = @project.errors.full_messages.join(", ")
      render :edit
    end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, alert: "Project deleted."
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

  def assign_users_to_new_project
    qa_users = User.where(id: params[:project][:qa_ids])
    qa_users.each { |qa| @project.project_users.create(user: qa) }

    developer_users = User.where(id: params[:project][:developer_ids])
    developer_users.each { |dev| @project.project_users.create(user: dev) }
  end

  def assign_users_to_existing_project
    @project.project_users.where.not(user_id: current_user.id).destroy_all  # Remove old assignments

    assign_users_to_new_project  # Reassign users
  end
end