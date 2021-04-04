# hshkeys2symbols takes a hash as input and, if the keys are
# strings, converts them to symbols.  If the string 
# contains a colon (:), it is eliminated (and the new key
# will begin with a colon).  Also, if one of the hash 
# values is an array of hashes, the keys are converted 
# to symbols as above. 

def hshkeys2symbols (hsh)
  newhsh = Hash.new
  if(!hsh.is_a?(Hash)
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
          if( !(arrayelt.is_a?(Hash))
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
end

The old version is below

# hshkeys2symbols takes a hash as input and, if the keys are
# strings, converts them to symbols.  If the string 
# contains a colon (:), it is eliminated (and the new key
# will begin with a colon.  

def hshkeys2symbols (hsh)
  hshn = Hash.new
  if(hsh.is_a?(Hash))
    hsh.each do |key, value|
      if (key.is_a?(String))
        keyn = key.gsub(":","").to_sym
      end
  #    hshn[keyn] = value
  #    print "Inside hshkeys2symbols hshn [#{keyn}] = #{hshn[keyn]} \n"
      # Now we have to take care of values that are arrays
      # of hashes
      print "\n Then insise hshkeys2symbolx we print value: #{value} \n\n"
      if (value.is_a?(Array))
        print "\n If we get here in hshewys2symbols then #{value} is an array\n"
        value.each_with_index do |item, index|
          print "\nWe now know #{value} is an array and we're printing the first index: #{index} and the first item: #{item}\n"
          if (item.is_a?(Hash))
            print "\nAnd now inside the inner loop of hshkeys2symbols we print item: #{item}\n"
            newhash = Hash.new
            item.each do |key1, value1|
              print "\n For the loop in line 139 we are printing value1 and key1: #{value1}  #{key1}\n"
              key1n = key1
              if (key1.is_a?(String))
                key1n = key1.gsub(":","").to_sym
                print "Then inside the inner inner loop of hshkeys2symbols we print key1n: #{key1n}\n"
                newhash[key1n] = value1
              end
#              hshn[keyn][index][key1n] = value1
#              print "\n And inside the inner loop of hshkeys2symbolx, hsh[keyn][index][key1n] is #{hshn[keyn][index][key1n]}\n"
            end
            hshn[keyn] = Array.new
            hshn[keyn][index] = newhash
          else
            hshn[keyn] = value
          end
        end
      end
    end
  else
    hshn = hsh
  end
  return hshn
end

