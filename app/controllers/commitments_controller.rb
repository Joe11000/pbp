class CommitmentsController < ApplicationController
  load_and_authorize_resource :project

  def index
    if request.xhr?
      render json: current_user.commitment_ids(@project.id)
    else
      render nothing: true
    end
  end

  def create
    if request.xhr?
      render text: current_user.update_events(params[:event_ids])
    else
      @project = Project.find(params[:project_id])
      redirect_to project_url(@project)
    end
  end
end
