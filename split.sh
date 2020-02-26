chk=0
while read line
do
   if [ "$line" = "---" ]; then
      ffmpeg -loglevel warning -stats -y $starttime -i $infile $endtime $outfile &
      chk=0
   elif [ $chk -eq 4 ];then
      ffmpeg -loglevel warning -stats -y $starttime -i $infile $endtime $outfile &
      outfile=`echo $line | tr -d '"'`
      chk=2
   elif [ $chk -eq 0 ];then
      infile=`echo $line | tr -d '"'`
      chk=1
   elif [ $chk -eq 1 ];then
      outfile=`echo $line | tr -d '"'`
	   chk=2
   elif [ $chk -eq 2 ];then
      if [ `echo $line | tr -d '"'` == "str" ];then
         starttime=""
      else
         starttime=`echo $line | tr -d '"'`
         starttime="-ss $starttime"
      fi
      chk=3
   elif [ $chk -eq 3 ];then
      if [ `echo $line | tr -d '"'` == "end" ];then
         endtime=""
      else
         endtime=`echo $line | tr -d '"'`
         endtime="-to $endtime"
      fi
      chk=4
   fi
done < $1
wait

