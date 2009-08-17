# Load base template
load_template "http://github.com/nextcom/rails_templates/raw/master/base.rb"

# Add Authlogic gem
gem "authlogic"
rake "gems:install", :sudo => true

# Generate models for Authlogic
generate :session, "user_session"
generate :rspec_model, "user", "username:string", "email:string", "crypted_password:string", "password_salt:string", "persistence_token:string"
run "curl -L http://github.com/nextcom/rails_templates/raw/master/app/models/user.rb > app/models/user.rb"
run "curl -L http://github.com/nextcom/rails_templates/raw/master/app/controllers/users_controller.rb > app/controllers/users_controller.rb"
rake "db:migrate"

# Set controller and helper methods
run "curl -L http://github.com/nextcom/rails_templates/raw/master/app/controllers/application_controller.rb > app/controllers/application_controller.rb"

# Set tests
gsub_file "spec/spec_helper.rb", /#\s*(require "authlogic\/test_case)"/, '\1'
run "curl -L http://github.com/nextcom/rails_templates/raw/master/spec/user_blueprints.rb >> spec/blueprints.rb"
run "curl -L http://github.com/nextcom/rails_templates/raw/master/spec/controllers/users_controller_spec.rb >> spec/controllers/users_controller_spec.rb"
run "curl -L http://github.com/nextcom/rails_templates/raw/master/spec/controllers/user_sessions_controller_spec.rb >> spec/controllers/user_sessions_controller_spec.rb"

# Set login and logout routes
route "map.login 'login', :controller => 'user_sessions', :action => 'new'"
route "map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'"



