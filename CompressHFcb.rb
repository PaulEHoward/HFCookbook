# 
        ######################################################
        # Initial Stuff:  Opening the input file             #
        ######################################################


cblongfile = File.open("HFCShort.txt",'r')   # The MasterCook text file.
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

def readRecipe(ifile) # reads one recipe into a hash
  line = findLine(ifile,"Exported from MasterCook")
  if line == "end of file"
    return
  end
  recipe = Hash.new

       # Get the title

  line = ifile.gets
  while !(line.match(/\w/))
    line = ifile.gets           # skip blank lines before the title
  end
  line = line.chomp!
  print "  #{line}\n\n"  #diagnostic
  matches = line.match(/\s*(?<title>.*)\s*\Z/)
  recipe[:title] = matches[:title]

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
  cats = istring.match(/.*:\s*(?<categories>.*)\s*|\z/)
  catarray = cats[:categories].split(/\s{2,}/)
 # catarray = cats[:categories].scan(/\w+|\G\w+/) # not exactly sure why this works
  recipe[:categories] = catarray

          # Get Ingreidients (An array of hashes)
          # one hash for each ingreidient
          # ingreidients[i][:amount], 
          # ingreidients[i][:measure], etc

  while (!(line.match(/---/)))
    line = ifile.gets
  end
  ingreidients = Array.new
  line = ifile.gets   # first ingreidient
  while (line.match(/\w/))
#    print "#{line}\n"  # diagnostic
    matches1 = line.match(/\A\s*(?<amount>[\d\s\/]*)/)
    matches2 = line.match(/.{9}\s*(?<measure>\w+)/)
    matches3 = line.match(/.{24}\s*(?<name>.*)/)
    ingreidient = Hash.new
#    print "#{matches1[:amount]} \n"  # diagnostic
    ingreidient[:amount] = matches1[:amount].strip
    ingreidient[:measure] = matches2[:measure]
    ingreidient[:name] = matches3[:name].strip
    ingreidients[ingreidients.length] = ingreidient    
    line = ifile.gets
  end
  recipe[:ingreidients] = ingreidients

          # Get directions in an array

  directions = Array.new
  line = ifile.gets   # this should be the first 
                      # direction line    
   #  directions may be more than one line long and
   # are separated by a blank line.  The list of 
   # direcitons ends with 3 blank lines followed by the
   # line "Source:"
   while (!(line.match(/Source:/)) && !(line.match(/- - -/)))
     dirline = line.chomp.strip
     while (line.match(/\w/))
        line = ifile.gets
        dirline = dirline << " " << line.chomp.strip
     end
#     print "  #{dirline}\n"
     m = dirline.match(/\A\s*\d+\.\s*(?<direction>.*)/)
     directions[directions.length] = m[:direction].strip
     while (!(line.match(/\w/)))
        line = ifile.gets
     end
   end
   recipe[:directions] = directions

           # Get the Source, Total time, cooking time
           # and Ratings if they exist
           # (this group ends with "    - - - - - ...")
   longline = line.chomp.strip # We're on 
                               # the line beginnig 
                               # Source:
   while(!(line.match(/- - -/)))
     line = ifile.gets
     longline = longline << " " << line.chomp.strip
   end

   if (!(m = longline.match(/Source:\s*"(?<source>.*?)"/)))
    recipe[:source] = ""
   else
    recipe[:source] = m[:source]
   end

   if (!(m = longline.match(/Start.*:\s*"(?<totaltime>.*?)"/)))
    recipe[:totaltime] = ""
   else
    recipe[:totaltime] = m[:totaltime]
   end

   if (!(m = longline.match(/T\(Coo.*:\s*"(?<cooktime>.*?)"/)))
    recipe[:cooktime] = ""
   else
    recipe[:cooktime] = m[:cooktime]
   end

   if (!(m = longline.match(/Ratings.*:\s*(?<ratings>.*?)\- - -/)))
    recipe[:ratings] = ""
   else
    
    recipe[:ratings] = m[:ratings].gsub(/\s{2,}/," ")
   end

                  # Get the "per serving" stuff

   while (!(line.match(/\w/)))
    line = ifile.gets
   end
   lperserving = line.chomp.strip
   while (line.match(/\w/))
    line = ifile.gets
    lperserving = lperserving << " " << line.chomp.strip
   end
   if (!(m = lperserving.match(/\):\s*(?<perserving>.*)/)))
    recipe[:perserving] = ""
   else
    recipe[:perserving] = m[:perserving]
   end

                 # Get the Notes
     # The recipe ends with the line "Nutr. Assoc. ..."
     # So we'll get everything up to there and then match
     # "NOTES"  (looks like NOTES are always followed by
     # Nutr. Assoc.)
   while (!(line.match(/\w/)))
    line = ifile.gets
   end
   laststr = line.chomp.strip
   line = ifile.gets
   while (!(line.match(/Nutr\./)))
    line = ifile.gets
    line = line.chomp.strip
    line = line.gsub(/\s{2,}/," ")     
    laststr = laststr << " " << line
   end
   print "   #{laststr} \n"
   laststr.gsub(/\s{2,}/," ")

   if (!(m = laststr.match(/NOTES\s*:\s*(?<notes>.*)/)))
     recipe[:notes] = ""
   else
    recipe[:notes] = m[:notes]
   end
                    
  return recipe
end 
   
          
       #################
       #  End Methods  #
       #################
require 'yaml'       
cookbook = Array.new       
while !(cblongfile.eof)
  recipehash = readRecipe(cblongfile)
  print "#{recipehash} \n\n"         # to test (delete later)
  cookbook[cookbook.length] = recipehash
end
File.write("cookbook.yml", YAML.dump(cookbook))

cblongfile.close

#cookbookback=YAML.load_file('cookbook.yml')
#print "\n\nFrom the yaml file \n\n #{cookbookback} \n"