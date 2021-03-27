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
cookbook.sort_by! { |k| k[:title]}
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
               # which inputs a cookbook and returns an 
               # an array of pairs ["title","index in cookbook"]
    erb :recipelist, :layout => :pagelayout
end

get '/categorylist' do
    @title = 'Category List'
    @recipecats = categories(cookbook) # categories
               # is a method in the /methods/cbmethods file
    erb :categorylist, :layout => :pagelayout
end

get '/listrecipesincat/:cat' do
    # Gets a category name and lists the recipes in that
    # category
    @title = 'Recipes with category' << " " <<"#{params[:cat]}"
    @recipetitles = rcpincat(cookbook, params[:cat]) # repincat
               # is a method in the /methods/cbmethods file
               # which inputs a category and returns an 
               # array of pairs for each recipe
               # in that category.  ["title", "incex in cookbook]
    erb :recipelist, :layout => :pagelayout
end

get '/recipes/new' do
  @title = 'Add a New Recipe'
  @recipe = Recipes.new
  print "\n\n\nrecipe #{@recipe.title}\n\n\n"
  erb :new_recipe, :layout => :pagelayout
end  


get '/recipes/:id' do
    @title = 'Recipe'
    ind = params[:id].to_i
    @recipe = cookbook[ind]
    erb :show_recipe, :layout => :pagelayout
  end

 

post '/recipes' do
  print "\n #{params[:recipe]}\n"
  recipe = Recipes.new(params[:recipe])
  cbl = cookbook.length
  cookbook[cbl] = recipe
  redirect to("/recipes/cbl")
end
  
 

get '/about' do
  @title = 'About'
  erb :about, :layout => :pagelayout
end

get '/contact' do
  @title = 'Contact'
  erb :contact, :layout => :pagelayout
end
