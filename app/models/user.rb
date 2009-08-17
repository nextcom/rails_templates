class User < ActiveRecord::Base
  acts_as_authentic
  
  def admin?
    self.admin
  end
  
end
