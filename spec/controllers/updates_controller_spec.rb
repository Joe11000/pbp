require 'spec_helper'

describe UpdatesController do
  let(:project) { FactoryGirl.create(:project) }

  before do
    user = FactoryGirl.create(:user)
    controller.stub(:current_user).and_return user
  end

  describe '#new' do
    it "should return successfully" do
      get :new
      response.should be_successful
    end

    it "assigns correct project to the @project" do 
      get :new, project_id: project.id 
      assigns(:project).should eq project 
    end 
  end

  describe "#create" do
    
    context 'with valid input' do 
      before do 
        post :create, project_id: project.id, 
        update: { title: 'Bacon', body: "Bacon BODY!"}
      end 
      
      it "should create a new Update Object for specific project" do
        assigns(:update).should be_valid
      end

      it "should redirect if update is saved" do
        update = assigns(:update)
        response.should redirect_to(project_update_url(project, update))
      end

    end 
  
    context 'with invalid input' do 
      before do 
        post :create, project_id: project.id, 
        update: { body: "Bacon BODY!"}
      end 

      it "should stay on the same page" do
        update = assigns(:update) 
        should render_template :new
      end
    end 
  end

  describe "#edit" do 
    it 'should load correct project update' do 
      get :edit
      reponse.should be_successful
    end 
  end 

end