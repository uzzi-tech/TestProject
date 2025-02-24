class BugsController < ApplicationController
    before_action :set_project
    before_action :set_bug, only: [:show, :edit, :update, :destroy]
  
    def index
      @bugs = @project.bugs
    end
  
    def show
    end
  
    def new
      @bug = @project.bugs.new
    end
  
    def create
        @bug = @project.bugs.new(bug_params)
        @bug.creator_id = current_user.id  # Assign the logged-in user as the creator
      
        if @bug.save
          flash[:notice] = "Bug created successfully!"
          redirect_to project_bugs_path(@project)
        else
          puts @bug.errors.full_messages
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
  
    def set_project
      @project = Project.find(params[:project_id])
    end
  
    def set_bug
      @bug = @project.bugs.find(params[:id])
    end
  
    def bug_params
        params.require(:bug).permit(:title, :description, :bug_type, :status, :developer_id)
    end
  end
  