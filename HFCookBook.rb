############### Howard Family Cookbook #################

require "sinatra"
# require 'sass'
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

get '/contact' do
  @title = "Contact"
  erb :underconstruction, :layout => :pagelayout
end


get '/about' do
  @title = "About"
  erb :underconstruction, :layout => :pagelayout
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
#  @recipe = Recipes.new
  @recipe = mknewrecipe
  print "From inside recipes/new \n\n\nrecipe #{@recipe[:title]}\n\n\n"

  @new_or_edit = "n"  # "n" for new, index of recipe for edit

  erb :new_recipe, :layout => :pagelayout
end


get '/recipes/:id' do
    @title = 'Recipe'
    ind = params['id'].to_i # or params[:id]
    print "\nInside /recipe/:id the index, ind is #{ind}\n"
    @recipe = cookbook[ind]
    @index = ind
    erb :show_recipe, :layout => :pagelayout
end


=begin  # Commented out is the "real" post '/recipes/:n_or_e' do
        # so that the cookbook cannot be altered  from heroku
        # The replacement for use on heroku is below the commented 
        # out version
        
post '/recipes/:n_or_e' do
  recipen = trimiandd( hshkeys2symbols(params[:recipe]))  # *****
  cb_indx_arry = addrecipe(cookbook,  recipen, params[:n_or_e].to_i)
  cookbook = cb_indx_arry[0]
  recp_index = cb_indx_arry[1]
  # File.write("cookbook.yml", YAML.dump(cookbook))  # add after testing
  redirect to("/recipes/#{recp_index}")
end

=end

post '/recipes/:n_or_e' do
  @title = "Add new or edited recipe to cookbook"
  erb :underconstruction, :layout => :pagelayout
end

post '/search' do
  @title = "search results for #{params[:st].to_s}"
  @recipetitles = recipeSearch(cookbook, params[:st]) # recipeSearch
             # is a method in the /methods/cbmethods file
             # which inputs a category and returns an
             # array of pairs for each recipe
             # (with the search term in its ingredients)  ["title", "incex in cookbook]
  erb :recipelist, :layout => :pagelayout
#  params[:st].to_s   # diagnostic - just testing
end

get '/recipe/edit/:id' do
  @title = "Edit Recipe"
  id = params[:id].to_i
  @recipe = cookbook[id]

  @new_or_edit = id  # "n" for new, recipe index (id) for edit

  erb :new_recipe, :layout => :pagelayout
end

get '/about' do
  @title = 'About'
  erb :about, :layout => :pagelayout
end

get '/contact' do
  @title = 'Contact'
  erb :contact, :layout => :pagelayout
end
