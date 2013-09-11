class DonationsController < ApplicationController
  load_and_authorize_resource

  def index
    @project = Project.find(params[:project_id])
    @donations = @project.donations
  end

  def new
    @project = Project.find(params[:project_id])
    @donation = Donation.new
  end

  def create
    @project = Project.find(params[:project_id])
    @donation = @project.donations.create(params[:donation])
    @donation.user = current_user if @donation

    if @donation.save
      if @donation.dollar_amount > 0
        redirect_to project_payments_url
      else
        flash[:notice] = "Successfully Donated"
        @donations = @project.donations
        redirect_to project_url(@project)
      end
    else
      flash.now[:notice] = "Fail"
      render :new
    end
  end

  def edit
    @donation = Donation.find(params[:id])
    @project = @donation.project
  end

  def update
    donation = Donation.find(params[:id])

    if donation.update_attributes(hours: params[:donation][:hours], dollar_amount: params[:donation][:dollar_amount])
      flash[:notice] = "Sucessfully Edited Donation"
      redirect_to project_donation_url(Project.find(params[:project_id].to_i))
    else
      flash.now[:notice] = "Fail"
      render :edit
    end
  end

  def show
    @donation = Donation.find(params[:id])
    @project = @donation.project
  end
end
