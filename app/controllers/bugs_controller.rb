class BugsController < ApplicationController
    before_action :set_project
    before_action :set_bug, only: [:show, :edit, :update, :destroy]
    before_action :authorize_bug_update, only: [:edit, :update]
  
    def index
      if current_user.manager?
        @bugs = Bug.all
      elsif current_user.qa?
        @bugs = Bug.where(project_id: current_user.project_ids) # QA sees assigned projects' bugs
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
        flash[:notice] = "Bug created successfully!"
        redirect_to project_bugs_path(@project)
      else
        puts @bug.errors.full_messages  # Print errors in console
        render :new, status: :unprocessable_entity
      end
    end    
  
    def edit
    end
  
    def update
      if @bug.update(bug_params)
        redirect_to project_bug_path(@project, @bug), notice: "Bug updated successfully!"
      else
        render :edit
      end
    end
  
    def destroy
      @bug.destroy
      redirect_to project_bugs_path(@project), notice: "Bug deleted successfully!"
    end
  
    private

    def authorize_bug_update
      if current_user.developer? && @bug.developer_id != current_user.id
        redirect_to bugs_path, alert: "You can only update your assigned bugs!"
      elsif current_user.qa? && @bug.creator_id != current_user.id
        redirect_to bugs_path, alert: "You can only update bugs you created!"
      end
    end
  
    def set_project
      @project = Project.find(params[:project_id])
    end
  
    def set_bug
      @bug = @project.bugs.find(params[:id])
    end
  
    def bug_params
      params.require(:bug).permit(:title, :description, :bug_type, :status, :developer_id).tap do |whitelisted|
        whitelisted[:status] = whitelisted[:status].to_i if whitelisted[:status].present?
      end
    end
    
  end
  