class ProjectsController < ApplicationController
  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = User.first.created_projects.new(params[:project])
    if @project.valid?
      flash[:notice] = "Success"
      @project.save
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
      flash[:notice] = "Successful Update"
      redirect_to project_url(@project)
    else
      flash.now[:notice] = "Unsuccessful Update"
      render :edit
    end
  end

  def show
    @project = Project.find(params[:id])
  end
end
