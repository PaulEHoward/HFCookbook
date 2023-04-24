#!/bin/bash
# To run HFCookBook.rb and open it in Firefox

ruby HFCookBook.rb &
hfcpid=$! 
# the pid of HFCookbook.rb  
sleep 4 

# For Windows
# C:\Program Files (x86)>start firefox.exe http://localhost:4567

# For Ubuntu
/bin/firefox http://localhost:4567 &

echo "Do you want to exit the Howard Family Cookbook?  Y/N"
read answer
if [ "$answer" = "Y" ]; then
  echo $hfcpid
  kill $hfcpid
  exit 0
fi
