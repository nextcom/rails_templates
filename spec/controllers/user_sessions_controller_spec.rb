require File.dirname(__FILE__) + '/../spec_helper'
 
describe UserSessionsController do
  # fixtures :all
  # integrate_views
  
  def mock_user_session(stubs={})
    @mock_user_session ||= mock_model(UserSession, stubs)
  end
  
  before(:each) do
    activate_authlogic
  end
  
  describe "when logged in" do
    
    before(:each) do
      controller.should_receive(:require_user).and_return(true)
    end
    
    it "destroy action should destroy model and redirect to index action" do
      UserSession.should_receive(:find).and_return(mock_user_session)
      mock_user_session.should_receive(:destroy)
      delete :destroy, :id => :current
      flash[:notice].should  == "Successfully logged out."
      response.should redirect_to(root_url)
    end
    
  end
  
  describe "when logged out" do
    
    
    
    it "new action should render new template" do
      get :new
      response.should render_template(:new)
    end
    
    describe "login attempts" do
      
      before(:each) do
        controller.should_receive(:require_no_user).and_return(true)
      end
      
      it "should create a new session when login is valid" do
        @test_username = 'david'
        @test_password = 'testing'
        User.make(:username => @test_username, :password => @test_password)
        post :create, :user_session => { :username => @test_username, :password => @test_password }
        UserSession.find.should be_an_instance_of(UserSession)
      end

      it "should not create a new session when login is invalid" do
        @test_username = 'david'
        @test_password = 'testing'
        User.make(:username => @test_username, :password => @test_password)
        post :create, :user_session => { :username => @test_username, :password => @test_password + 'invalid' }
        response.should render_template(:new)
        assigns[:user_session].errors.count.should >= 1
        response.status.should == "401 Unauthorized"
      end
    end
    
  end
  
end
