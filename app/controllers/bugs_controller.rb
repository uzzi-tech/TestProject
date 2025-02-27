class BugsController < ApplicationController
    before_action :set_project
    before_action :set_bug, only: [:show, :edit, :update, :destroy]
    before_action :authorize_bug_update, only: [:edit, :update, :destroy]
    before_action :authorize_manager_or_qa, only: [:new, :create, :destroy]

  
    def index
      if current_user.manager?
        @bugs = Bug.where(project_id: current_user.project_ids) 
      elsif current_user.qa?
        @bugs = @project.bugs 
      elsif current_user.developer?
        @bugs = Bug.where(developer_id: current_user.id) # Developer sees only assigned bugs
      end
    end
    
  
    def show
    end
  
    def new
      @bug = @project.bugs.new
    end
  
    def create
      @bug = @project.bugs.new(bug_params)
      @bug.creator_id = current_user.id  
    
      puts "BUG STATUS BEFORE SAVE: #{@bug.status.inspect}"  # Debugging line
    
      if @bug.save
        flash[:alert] = "Bug created successfully!"
        redirect_to project_bugs_path(@project)
      else
        flash[:alert] = @bug.errors.full_messages.join(", ") 
        render :new, status: :unprocessable_entity
      end
    end    
  
    def edit
    end
  
    def update
      if params[:bug][:screenshot].present?
        @bug.screenshot.remove!
      end
    
      if @bug.update(bug_params)
        redirect_to project_bug_path(@project, @bug), alert: "Bug updated successfully!"
      else
        flash[:alert] = @bug.errors.full_messages.join(", ")
        render :edit
      end
    end
    
  
    def destroy
      @bug.destroy
      redirect_to project_bugs_path(@project), alert: "Bug deleted successfully!"
    end
  
    private
    def authorize_manager_or_qa
      redirect_to project_bugs_path(@project), alert: "Access denied!" unless current_user.manager? || current_user.qa?
    end    
      

    def authorize_bug_update
      if current_user.qa? && @bug.creator_id != current_user.id
        redirect_to project_bugs_path, alert: "You can only update bugs you created!"
      end
    end
  
    def set_project
      @project = Project.find(params[:project_id])
    end
  
    def set_bug
      @bug = @project.bugs.find(params[:id])
    end
  
    def bug_params
      params.require(:bug).permit(:title, :description, :bug_type, :status, :developer_id, :screenshot, :deadline).tap do |whitelisted|
        whitelisted[:status] = whitelisted[:status].to_i if whitelisted[:status].present?
      end
    end    
    
  end
  