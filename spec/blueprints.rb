require 'machinist/active_record'
require 'sham'
require 'faker'

# # Example blueprint and Sham
# Sham.company_name { Faker::Company.name }
# Sham.address(:unique => false) { Faker::Address.street_address }
# 
# Company.blueprint do
#   company_name
#   address
# end