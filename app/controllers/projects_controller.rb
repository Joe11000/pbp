class ProjectsController < ApplicationController
  load_and_authorize_resource

  def index
    @projects = Project.all
    @featured_project = @projects.last
  end

  def new
    @project = Project.new
  end

  def create
    @project = current_user.created_projects.new(params[:project])
    @project.deadline = DateTime.parse(params[:project][:deadline])
    if @project.save
      @project.strip_media
      flash[:notice] = "Thank you!"
      redirect_to project_url(@project)
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
      @project.strip_media
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
