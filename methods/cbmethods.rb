# This file contains methods for HFCookbook

             ####  recipetitles  ####
# Inputes the cookbook as an array and returns an array 
# of pairs - first component is title, second component
# is index in cb
             

def recipetitles(cb)
  titles = Array.new  
  cb.each_with_index do |rcp, ind|
    titles[titles.length] = [rcp[:title], ind]
  end
  return(titles)
end
             
             ####  categories  ####
# Inputes the cookbook as an array and returns an array 
# of the categories

def categories(cb)
  recipecats = Array.new
  cb.each do |rcp|
    if rcp[:categories].length > 0
      rcp[:categories].each do |categ|
        if !recipecats.include?(categ)
          recipecats = recipecats << categ
        end
      end
    end
  end
  return(recipecats)
end

               #### rcpincat ####
# Inputs the cookbook (cb) and a category and returns an # 
# array of pairs ["title", "index in cb"] for recipes
# for recipes in the category.

def rcpincat( cb,cat)
  recipettls = Array.new
  cb.each_with_index do |rcp, ind|
    if (rcp[:categories].include?(cat))
      recipettls << [rcp[:title],ind]
      print "\n\n The title: #{rcp[:title]}\n\n" #diagnostic
    end
  end
  return(recipettls)
end

class Recipes(title = "",author = "",servings = "", preptime = "", categories = "", ingreidients = "", directions = "", source = "", totaltime = "", cooktime = "", ratings = "", perserving = "", notes = "", 
  def initialize
    @title = title
    @author = author
    @servings = servings
    @preptime = preptime
    @categories = categories
    @ingreidients = ingreidients
    @directions = directions
    @source = source
    @totaltime = totaltime
    @cooktime = cooktime
    @ratings = ratings
    @perserving = perserving
    @notes = notes
end
             
