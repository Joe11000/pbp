class MediafilesController < ApplicationController
  def new
    @project = Project.find(params[:project_id])
    @mediafile = @project.mediafiles.build
  end

  def create
    @project = Project.find(params[:project_id])
    @mediafile = @project.mediafiles.create(params[:mediafile])

    if @mediafile.persisted?
      redirect_to project_url(@project)
    else
      flash[:notice] = "dont be a muggle...learn how to load your photos." # I still challenge the fact that you guys use flash for form error messages
      render :new
    end
  end

  def show
    @mediafile = Mediafile.find(params[:id])
    @project = @mediafile.project
  end

  def edit
    @project = Project.find(params[:id])
    @mediafiles = Mediafile.find(params[:id])
  end

  def update
    mediafile = Donation.find(params[:id])
    project = Project.find_by_id(params[:project_id])
    if donation.update_attributes(name: params[:mediafile][:name],
                                  url: params[:mediafile][:url],
                                  media_type: params[:mediafile][:media_type])
      flash[:notice] = "Successfully Updated"
      redirect_to project_url(project)
    else
      flash.now[:notice] = 'Failed To Update' # I still challenge the fact that you guys use flash for form error messages
      render :edit
    end
  end
end
