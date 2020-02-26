chk=0
tempfile=""
while read line
do
   if [ "$line" = "---" ]; then
      echo "ffmpeg -f concat -safe 0 -i "$filename.txt" -c copy "$filename" &" 
      ffmpeg -loglevel warning -stats -y -f concat -safe 0 -i "$filename.txt" -c copy "$filename" &
      tempfile="$tempfile $filename.txt"
      chk="0"
   elif [ "$chk" = "0" ];then
      filename=`echo $line | tr -d '"'`
      chk="1"
      [ -f $filename.txt ] && rm $filename.txt
   else
      echo file \'`echo $line | tr -d '"'`\' >> $filename.txt
   fi
done < $1
wait
rm $tempfile
