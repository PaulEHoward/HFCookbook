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


#  Class for recipes


class Recipes

  def initialize (recipe = "blank") 
    iv = Hash.new
    iv[:title] = "Pork"
    iv[:author] = ""
    iv[:servings] = ""
    iv[:preptime] = ""
    iv[:categories] = Array.new
    iv[:ingreidients] = Array.new
    (0..5).each do |i|
      iv[:ingreidients][i] = {amount: "", measure: "", name: ""}
    end
    iv[:directions] = Array.new
    (0..5).each do |i|
      iv[:directions][i] = ""
    end
    iv[:source] = ""
    iv[:totaltime] = ""
    iv[:cooktime] = ""
    iv[:ratings] = ""
    iv[:perserving] = ""
    iv[:notes] = ""
      
    if (recipe == "blank")
      recipe = iv
    end
    @title = recipe[:title]
    @author = recipe[:author]
    @servings = recipe[:servings]
    @preptime = recipe[:preptime]
    @categories = recipe[:categories]
    @ingreidients = recipe[:ingreidients]
    @directions = recipe[:directions]
    @source = recipe[:source]
    @totaltime = recipe[:totaltime]
    @cooktime = recipe[:cooktime]
    @ratings = recipe[:ratings]
    @perserving = recipe[:perserving]
    @notes = recipe[:notes]
  end
  attr_accessor :title, :author, :servings, :preptime, \
              :categories, :ingreidients, :directions,\
              :source, :totaltime, :cooktime, :ratings,\
              :perserving, :notes
  # (So @title can be accessed with obj.title
  # and set with obj.title =   Same for @author, etc.
end
             
