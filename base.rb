# Base Rails app template

# Delete unnecessary files
run "rm README"
run "rm public/index.html"
run "rm public/favicon.ico"
run "rm public/robots.txt"
run "rm -f public/javascripts/*"

# Make example database.yml file
run "cp config/database.yml config/database.yml.example"

# Setup stylesheets
run "curl -L http://github.com/nextcom/rails_templates/raw/master/public/stylesheets/reset.css > public/stylesheets/reset.css"
run "touch public/stylesheets/application.css"
  
# Download JQuery
run "curl -L http://jqueryjs.googlecode.com/files/jquery-1.3.2.min.js > public/javascripts/jquery.js"
  
# Download jQuery.pngFix
run "curl -L http://plugins.jquery.com/files/pngFix1.2.zip > public/javascripts/pngFix.zip"
run "unzip public/javascripts/pngFix.zip -C jquery.pngFix.pack.js"
run "mv jquery.pngFix.pack.js public/javascripts/jquery.pngFix.js"
run "rm public/javascripts/pngFix.zip"
  
# Write jQuery.pngFix activation script
append_file "public/javascripts/jquery.pngFix.js", <<-CODE

$(document).ready(function(){ 
  $(document).pngFix(); 
});
CODE

# Add application layout
run "curl -L http://github.com/nextcom/rails_templates/raw/master/app/views/layouts/application.html.erb > app/views/layouts/application.html.erb"
  
# Add Google Analytics partial
run "curl -L http://github.com/nextcom/rails_templates/raw/master/app/views/shared/_google.html.erb > app/views/shared/_google.html.erb"

# Add application helpers
run "curl -L http://github.com/nextcom/rails_templates/raw/master/app/helpers/application_helper.rb > app/helpers/application_helper.rb"

# Install non-testing gems
gem 'thoughtbot-paperclip', :lib => 'paperclip', :source => 'http://gems.github.com'

# Install testing gems
gem "thoughtbot-shoulda", :lib => "shoulda", :source => "http://gems.github.com"
gem "rspec", :lib => "spec"
gem "rspec-rails", :lib => "spec/rails"
gem "spork"
gem "notahat-machinist", :lib => "machinist", :source => "http://gems.github.com"
gem "faker", :source => "http://gems.rubyforge.org/"

# Confirm gem installs
rake("gems:install", :sudo => true)

# Setup testing env
generate :rspec
append_file "spec/spec.opts", "--drb"
run "curl -L http://github.com/nextcom/rails_templates/raw/master/spec/spec_helper.rb > spec/spec_helper.rb"
run "curl -L http://github.com/nextcom/rails_templates/raw/master/spec/blueprints.rb > spec/blueprints.rb"

# Setup Git repository
git :init

file ".gitignore", <<-END
log/*.log
log/*.pid
tmp/**/*
db/*.sqlite3
doc
END

git :add => ".", :commit => "-m 'Initial Commit'"


