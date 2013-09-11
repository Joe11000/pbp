class UpdatesController < ApplicationController
  
  def index
    @project = Project.find_by_id(params[:project_id])
    @updates = @project.updates 
  end 

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

  def edit 
    @update = Update.find(params[:id]) 
    @project = @update.project 
  end 

  def update
    update = Update.find_by_id(params[:id])

    if update.update_attributes(title: params[:update][:title], 
                                body:  params[:update][:body])
      flash[:notice] = "Successful"
      redirect_to project_update_url(update)
    else 
      flash[:notice] = "Edit of Update Unsuccessful"
      redirect_to :edit 
    end 
  end 

  def destroy
    @update = Update.find_by_id(params[:id])
    @project = @update.project
    @update.destroy
    redirect_to project_url(@project)
  end 
end
