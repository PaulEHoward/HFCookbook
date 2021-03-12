# This file contains methods for HFCookbook

             ####  recipetitles  ####
# Inputes the cookbook as an array and returns an array 
# of pairs - first component is title, second component
# is index in cb
             

def recipetitles(cb)
  titles = Array.new  
  cb.each_with_index do |rcp, ind|
    titles[titles.length] = [rcp[:title], ind]
    print "\n\n The title: #{rcp[:title]}\n\n" #diagnostic
  end
  return(titles)
end
             
