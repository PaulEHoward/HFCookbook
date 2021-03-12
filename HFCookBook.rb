############### Howard Family Cookbook #################

require "sinatra"
require 'sass'
require "./methods/cbmethods.rb"  # try to store all 
                                  # methods here
require "yaml"

set :views, 'views'    #unnecessary line since 'views' is the default
set :public_folder, 'public' # unnecessary line since 'public' is the default

get('/styles.css'){ scss :styles }
cookbook=YAML.load_file('cookbook.yml')

get('/') do
  @title = 'Home'
  erb :home, :layout => :pagelayout # the default layout file is
                                # "/views/layout.erb".  This will
                                # use /views/pagelayout.erb
end

get '/recipelist' do
    @title = 'Recipe List'
    @recipetitles = recipetitles(cookbook) # recipetitles
               # is a method in the /methods/cbmethods file
    erb :recipelist, :layout => :pagelayout
end

get '/recipes/:id' do
    @title = 'Recipe'
    ind = params[:id].to_i
    @recipe = cookbook[ind]
    erb :show_recipe, :layout => :pagelayout
  end
  
 

get '/about' do
  @title = 'About'
  erb :about, :layout => :pagelayout
end

get '/contact' do
  @title = 'Contact'
  erb :contact, :layout => :pagelayout
end
