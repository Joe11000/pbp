class DonationsController < ApplicationController

  def index
    @project = Project.find(params[:project_id])
    @donations = @project.donations
  end

  def new
    @project = Project.find(params[:project_id])
    @donation = Donation.new()
    authorize! :create, @donation
  end

  def create
    @project = Project.find(params[:project_id])
    @donation = @project.donations.create(params[:donation])
    @donation.user = User.first if @donation

    authorize! :update, @donation

    if @donation.save
      flash[:notice] = "Successfully Donated"
      redirect_to project_donation_url(@project, @donation)
      
    else
      flash[:notice] = "Fail"
      render :new
    end
  end

  def edit
    @donation = Donation.find(params["id"])
    @project = @donation.project
    authorize! :update, @donation
  end

  def update
    donation = Donation.find(params[:id])

    authorize! :update, donation
    
    if donation.update_attributes(hours: params[:donation][:hours], dollar_amount: params[:donation][:dollar_amount])
      flash[:notice] = "Sucessfully Edited Donation"
      redirect_to project_donation_url(Project.find(params[:project_id].to_i))
    else
      flash[:notice] = "Fail"
      render :edit
    end
  end

  def show
    @donation = Donation.find(params["id"])
    @project = @donation.project
  end
end
