# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require File.expand_path('../seed/users', __FILE__)
require File.expand_path('../seed/countries', __FILE__)
require File.expand_path('../seed/players', __FILE__)

require File.expand_path('../seed/seasons', __FILE__)
