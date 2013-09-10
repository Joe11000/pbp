class ProjectsController < ApplicationController
  load_and_authorize_resource

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.created_projects.new(params[:project])
    @project.deadline = DateTime.parse(params[:project][:deadline])

    if @project.save
      flash[:notice] = "Thank You For Giving"
      @project.save
      @mediafiles = Mediafile.new
      redirect_to new_project_mediafiles_url(@project)
    else
      flash.now[:notice] = "Fail"
      render :new
    end
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])

    if @project.update_attributes(params[:project])
      flash[:notice] = "Successful Update"
      redirect_to project_url(@project)
    else
      flash[:notice] = "Unsuccessful Update"
      render :edit
    end
  end

  def show
    @project = Project.find(params[:id])
    @donations = @project.donations
  end
end
