# 
# Inputs a MasterCook text file exported by MasterCook (cblongfile) and converts it to a 
# .yml data file for use by the program HFCookBook.rb  HFCookBook.rb will read 
# it as an array of hashes.
#
        ######################################################
        # Initial Stuff:  Opening the input file             #
        ######################################################

cblongfile = File.open("HFC.txt",'r')   # The MasterCook text file full version.
#cblongfile = File.open("HFCShort.txt",'r')   # The MasterCook text file short version.
            #############
            #  Methods  #
            #############

# findLine(ifile,st) reads up through the first line it finds in
# the file iflie containing the string st and returns the line

def findLine(ifile,st)
    line = ifile.gets
    while(!(line.match(/#{Regexp.quote(st)}/)) && !(ifile.eof)) do # to interpret st 
                                                           # literally
      line = ifile.gets
    end
    if( ifile.eof)
      return   "end of file"
    end
    return line
end

# regexarraymatch(str,rgexarray) takes a string str and an array of regular 
# expressions (without the /.../) and returns an array
# [trthval, matches] where trthval = True and matches contains the last match
# if there is a match at the beginning of a line
# and if there is no match at the beginning of a line 
#  trthval = False and matches = 
# "none".  Added 12/31/21

def regexarraymatch(str,regexary) 
  trthval = false
  matches = "none"
  print "\n String = #{str} and Regexary = #{regexary} \n"
  regexary.each do |rx|
    if m = str.match(/\A\s*(?<mtch>#{Regexp.quote(rx)})/)  #to interpret rx literally
      trthval = true
      matches = m[:mtch]
    end
  end
  retrnarray = [trthval, matches]
  print "\n Return from regexarraymatch \n"
  return retrnarray
end      


def readRecipe(ifile) # reads one recipe into a hash
  line = findLine(ifile,"Exported from MasterCook")
  if line.match(/end of file/)
    return
  end
  recipe = Hash.new

       # Get the title

  line = ifile.gets
  while !(line.match(/\w/))
    line = ifile.gets           # skip blank lines before the title
  end
  line = line.chomp!
 # print "  #{line}\n\n"  #diagnostic
  recipe[:title] = "Untitled"  # in case there is no title (added 11/25/21)
  if ( matches = line.match(/\s*(?<title>.*)\s*\Z/))
    recipe[:title] = matches[:title]
  end

        # Get the author

  line = ifile.gets
  while !(line.match(/\w/))
    line = ifile.gets           # skip blank lines before the author
  end
  line.chomp!
  matches = line.match(/.*?:\s*(?<author>.*)\s*\Z/)
  recipe[:author] = matches[:author]

        # Get Servings, prep time 

  line = ifile.gets
  matches = line.match(/.*:\s*(?<servings>\d*)
                       .*:(?<preptime>\d*:\d*)/x)
                      # the x option ignores white space
                      # including carrige returns in the 
                      # regex
  recipe[:servings] = matches[:servings]
  recipe[:preptime] = matches[:preptime]
  
         # Get Categories

  line = ifile.gets  
  istring = line.chomp
  line = ifile.gets
  while (line.match(/\w/))
    line.chomp
    istring = istring << line
    line = ifile.gets
  end
  recipe[:categories] = []  # In case there are no categories
  if (cats = istring.match(/.*:\s*(?<categories>.*)\s*|\z/))
    catarray = cats[:categories].split(/\s{2,}/)
      # catarray = cats[:categories].scan(/\w+|\G\w+/) # not exactly sure why this works
    recipe[:categories] = catarray
  end

          # Get ingredients (An array of hashes)
          # one hash for each ingredient
          # ingredients[i][:amount], 
          # ingredients[i][:measure], etc

  while (!(line.match(/---/)))
    line = ifile.gets
  end
  ingredients = Array.new
  line = ifile.gets   # first ingredient
  while (line.match(/\S/))
#    print "#{line}\n"  # diagnostic
    matches1 = line.match(/\A\s*(?<amount>[\d\s\/]*)/)
    matches2 = line.match(/.{9}\s*(?<measure>\w+)/)
    matches3 = line.match(/.{24}\s*(?<name>.*)/)
    ingredient = Hash.new
#    print "#{matches1[:amount]} \n"  # diagnostic
    ingredient[:amount] = matches1[:amount].strip
    ingredient[:measure] = matches2[:measure]
    ingredient[:name] = matches3[:name].strip
    ingredients[ingredients.length] = ingredient    
    line = ifile.gets
  end
  recipe[:ingredients] = ingredients

         # Get directions in an array (altered 12/21/31)
         # at this point we have only white space in line

  directions = Array.new
  line = ifile.gets   
  while !line.match(/\S/)
    line = ifile.gets
  end    
  print "\n ****** First Dir Line #{line} \n"
   # line *should*  be the first
                      # direction line
   #  directions may be more than one line long and
   # are separated by a blank line.  The list of
   # directions ends with 1, 2 or 3 blank lines followed by the
   # line "Source:" or "Description:" or "Cuisine:" or "Yield:" or 
   # "Start to Finish Time": or "T(Cooking Time):" or "Ratings" 
   # These, if they exist, are followed by a line with 20 or so - - - 
   # Then "Per Serving (excluding unknown items):" (always) and 
   # "Nutr. Assoc. :" (always) with (possibly) "NOTES :" and
   # "Serving Ideas :" in between.
   # The next recipe begins with * Exported from MasterCook * then blank line
   
   kywrdarray = ["Source:", "Cuisine:", "Yield:", "Description:","Start to Finish Time:",
                 "T\(Cooking Time\)", "Ratings", "Per Serving", "NOTES", "Serving Ideas",
                 "Nutr\. Assoc\."]
   keywordfound = regexarraymatch(line,kywrdarray)[0]  
                   
   while (!(keywordfound) && !(line.match(/- - -/))) # while line begins with no key words
                                                    # and contains no "- - -"
     dirline = line.chomp.strip
     while (line.match(/\S/))    # \S is a non-white space character
        line = ifile.gets
        dirline = dirline << " " << line.chomp.strip
     end

     if (m = dirline.match(/\A\s*\d*\W*(?<direction>.*)/))  # directions may or
                              # may not begin with "digits."
       directions[directions.length] = m[:direction].strip
     end  
     while (!(line.match(/\S/)) || line.match(/- - -/) )     #*****
        line = ifile.gets
     end
     keywordfound = regexarraymatch(line,kywrdarray)[0]
   end
   print "\n found a KEYWORD.  It's #{regexarraymatch(line,kywrdarray)[1]} \n"
   recipe[:directions] = directions
   
           # This completes the directions. line contains a keyword and it's
           # not Nutr. Assoc.   Now initialize the recipe
           # hash with keywords as keys to ""
           print "\n line should contain a keyword: #{line}\n"
   
   kywrdarray.each do |kw|
      recipe[kw.to_sym] = ""
   end  
  
        # Now we get the values for the key words that are there 
        
       print "\n line before entering values for keywords while #{line}\n"    
         
   while (line.match(/- - -/) || !line.match(/\S/))   # clumsy way to handle the - - - lines
     line = ifile.gets
   end    
   
   while (!line.match(/Nutr\./))
      longline = line.gsub(/(?:- )+-/,"").chomp.strip
      line = ifile.gets
      print "\n longline before while #{longline} \n"
      while (!regexarraymatch(line,kywrdarray)[0] )
         print "\n After call 3 \n"
        longline = longline << " " << line.gsub(/(?:- )+-/,"").chomp.strip # because
                    # of the line with - - - ..."
        line = ifile.gets
      end
      print "\n longline before the match #{longline}\n"
      matches = longline.match(/(?<key>\A.*?):\s*(?<value>.*)/) #get key and value
      key = matches[:key].to_sym
      value = matches[:value]
      recipe[key] = value        
   end  
   return recipe
end   # (readRecipe(ifile))
   
          
       #################
       #  End Methods  #
       #################
       
require 'yaml'       
cookbook = Array.new       
while !(cblongfile.eof)
  recipehash = readRecipe(cblongfile)
 #  print "***** In Main #{recipehash[:title]} \n"         # to test (delete later)
  if (recipehash != nil)
    cookbook[cookbook.length] = recipehash
  end
end
File.write("cookbook.yml", YAML.dump(cookbook))  # to test CompressHFcb.rb

cblongfile.close

#cookbookback=YAML.load_file('cookbook.yml')
#print "\n\nFrom the yaml file \n\n #{cookbookback} \n"
