class UpdatesController < ApplicationController
  def new
    @project = Project.find_by_id(params[:project_id])
    @update = Update.new
  end

  def create
    @project = Project.find_by_id(params[:project_id])
    @update  = @project.updates.create(params[:update])

    if @update.save
      flash[:notice] = 'Update has been created'
      redirect_to project_update_url(@project, @update)
    else
      flash.now[:notice] = 'Update failed. Please Fill Out All Fields'
      render :new
    end
  end

  def show
    @update  = Update.find_by_id(params[:id])
  end
end
