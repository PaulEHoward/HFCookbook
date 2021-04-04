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

  attr_accessor :title, :author, :servings, :preptime, \
  :categories, :ingreidients, :directions,\
  :source, :totaltime, :cooktime, :ratings,\
  :perserving, :notes, :recipe  #:rhash
# (So @title can be accessed with obj.title
# and set with obj.title =   Same for @author, etc.

  def initialize (recipe = "blank") 
    iv = Hash.new
    iv[:title] = "Pork"
    iv[:author] = ""
    iv[:servings] = ""
    iv[:preptime] = ""
    iv[:categories] = Array.new
    iv[:ingreidients] = Array.new
    (0..5).each do |i|
      iv[:ingreidients][i] = {amount: "2", measure: "cups", name: "grease"}
    end
    iv[:directions] = Array.new
    (0..5).each do |i|
      iv[:directions][i] = "stir, stir, stir"
    end
    iv[:source] = ""
    iv[:totaltime] = ""
    iv[:cooktime] = ""
    iv[:ratings] = ""
    iv[:perserving] = ""
    iv[:notes] = ""
    
    print "\nInside initialize iv is #{iv}\n\n"

    if (recipe == "blank")
      recipe = iv
    end
    
    @title = "beans" #recipe[:title]
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

    @recipe = recipe
    print "\nInside intialize @recipe is #{@recipe}\n"
  end

  # @rhash = @recipe
  # so instance.rhash should give the recipe hash

end
 
# hshkeys2symbols takes a hash as input and, if the keys are
# strings, converts them to symbols.  If the string 
# contains a colon (:), it is eliminated (and the new key
# will begin with a colon).  Also, if one of the hash 
# values is an array of hashes, the keys are converted 
# to symbols as above. 

def hshkeys2symbols (hsh)
  newhsh = Hash.new
  if(!hsh.is_a?(Hash))
    newhsh = hsh
  else
    hsh.each do |label, contents|
      if(!label.is_a?(String))
        newlabel = label
      else
        newlabel = label.gsub(":","").to_sym
      end
      if(!contents.is_a?(Array))
        newhsh[newlabel] = contents
      else
        newhsh[newlabel] = Array.new
        contents.each_with_index do |arrayelt, ind|
          if( !(arrayelt.is_a?(Hash)))
            newhsh[newlabel][ind] = arrayelt
          else
            newhsh[newlabel][ind] = Hash.new
            arrayelt.each do |hshlbl, hshcontents|
              if (!hshlbl.is_a?(String))
                newhsh[newlabel][ind][hshlbl] = hshcontents
              else
                newhshlbl = hshlbl.gsub(":","").to_sym
                newhsh[newlabel][ind][newhshlbl] = 
                               hshcontents
              end
            end
          end
        end
      end
    end
  end
  return newhsh
end


