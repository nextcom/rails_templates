require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do

  def mock_user(stubs={})
    @mock_user ||= mock_model(User, stubs)
  end
  
  describe "when logged in as admin" do
    before(:each) do
      activate_authlogic
      UserSession.create(User.make(:admin))
    end
    
    it 'GET index' do
      get :index
      response.should be_success
    end
    
    it 'DELETE destroy' do
      @user = User.make
      lambda do
        delete :destroy, :id => @user.id
      end.should change(User, :count).by(-1)
    end
    
    it 'GET show' do
      @user = User.make
      get :show, :id => @user.id
      response.should be_success
    end
    
    it 'GET edit' do
      @user = User.make
      get :edit, :id => @user.id
      response.should be_success
    end
    
    it 'PUT update' do
      @user = User.make
      put :update, :id => @user.id, :user => {:first_name => 'Tom'}
      User.find(@user.id).first_name.should == 'Tom'
    end
  end
  
  describe "when logged in as a normal user" do
    before(:each) do
      activate_authlogic
      @test_id = '999'
      @logged_in_user = User.make(:id => @test_id, :first_name => 'John')
      UserSession.find.destroy
      UserSession.create(@logged_in_user)
    end
    
    it 'GET index' do
      get :index
      response.should_not be_success
    end
    
    it 'DELETE destroy' do
      @user = User.make
      lambda do
        delete :destroy, :id => @user.id
      end.should_not change(User, :count)
    end
    
    describe "user's own profile" do
      
      it 'GET show' do
        get :show, :id => @test_id
        response.should be_success
      end
    
      it 'GET edit' do
        get :edit, :id => @test_id
        response.should be_success
      end
    
      it 'PUT update' do
        put :update, :id => @test_id, :user => {:first_name => 'Tom'}
        User.find(@test_id).first_name.should == 'Tom'
      end
    end
    
    describe "another user's profile" do
      
      it 'GET show' do
        @user = User.make
        get :show, :id => @user.id
        response.should_not be_success
      end
    
      it 'GET edit' do
        @user = User.make
        get :edit, :id => @user.id
        response.should_not be_success
      end
    
      it 'PUT update' do
        @user = User.make(:first_name => 'John')
        put :update, :id => @user.id, :user => {:first_name => 'Tom'}
        User.find(@user.id).first_name.should_not == 'Tom'
      end
    end
  end
    
  describe "admin required action" do
    
    before(:each) do
      controller.should_receive(:require_admin).and_return(true)
    end
    
    describe "GET index" do
      it "assigns all users as @users" do
        User.stub!(:find).with(:all).and_return([mock_user])
        get :index
        assigns[:users].should == [mock_user]
      end
    end
    
    describe "DELETE destroy" do
      it "destroys the requested user" do
        User.should_receive(:find).with("37").and_return(mock_user)
        mock_user.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the users list" do
        User.stub!(:find).and_return(mock_user(:destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(users_url)
      end
    end
  end
  
  describe "admin or owner required action" do
    
    before(:each) do
      controller.should_receive(:require_admin_or_owner).and_return(true)
    end
    
    describe "GET show" do
      it "assigns the requested user as @user" do
        User.stub!(:find).with("37").and_return(mock_user)
        get :show, :id => "37"
        assigns[:user].should equal(mock_user)
      end
    end
    
    describe "GET edit" do
      it "assigns the requested user as @user" do
        User.stub!(:find).with("37").and_return(mock_user)
        get :edit, :id => "37"
        assigns[:user].should equal(mock_user)
      end
    end
    
    describe "PUT update" do

      describe "with valid params" do
        it "updates the requested user" do
          User.should_receive(:find).with("37").and_return(mock_user)
          mock_user.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :user => {:these => 'params'}
        end

        it "assigns the requested user as @user" do
          User.stub!(:find).and_return(mock_user(:update_attributes => true))
          put :update, :id => "37"
          assigns[:user].should equal(mock_user)
        end

        it "redirects to the user" do
          User.stub!(:find).and_return(mock_user(:update_attributes => true))
          put :update, :id => "37"
          response.should redirect_to(user_url(mock_user))
        end
      end

      describe "with invalid params" do
        it "updates the requested user" do
          User.should_receive(:find).with("37").and_return(mock_user)
          mock_user.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :user => {:these => 'params'}
        end

        it "assigns the user as @user" do
          User.stub!(:find).and_return(mock_user(:update_attributes => false))
          put :update, :id => "37"
          assigns[:user].should equal(mock_user)
        end

        it "re-renders the 'edit' template" do
          User.stub!(:find).and_return(mock_user(:update_attributes => false))
          put :update, :id => "37"
          response.should render_template('edit')
        end
      end
    end
    
  end

  describe "GET new" do
    it "assigns a new user as @user" do
      User.stub!(:new).and_return(mock_user)
      get :new
      assigns[:user].should equal(mock_user)
    end
  end

  describe "POST create" do
    
    describe "with valid params" do
      it "assigns a newly created user as @user" do
        User.stub!(:new).with({'these' => 'params'}).and_return(mock_user(:save => true))
        post :create, :user => {:these => 'params'}
        assigns[:user].should equal(mock_user)
      end

      it "redirects to the created user" do
        User.stub!(:new).and_return(mock_user(:save => true))
        post :create, :user => {}
        response.should redirect_to(user_url(mock_user))
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        User.stub!(:new).with({'these' => 'params'}).and_return(mock_user(:save => false))
        post :create, :user => {:these => 'params'}
        assigns[:user].should equal(mock_user)
      end

      it "re-renders the 'new' template" do
        User.stub!(:new).and_return(mock_user(:save => false))
        post :create, :user => {}
        response.should render_template('new')
      end
    end
    
  end

end
