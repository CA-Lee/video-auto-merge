echo -e "\e[0;32mStart!!\e[0m"
chk=0
i=0
while read line
do
    if [ $line == "---" ];then
        cat $outfile.partlist
        echo "***"

        ./split.sh $outfile.partlist

        [ -f $outfile.mergelist ] && rm $outfile.mergelist
        touch $outfile.mergelist
        echo \"$outfile\" >> $outfile.mergelist
        n=1
        while [ $n -le $i ]
        do
            echo \"$n.mp4\" >> $outfile.mergelist
            n=$(( $n + 1 ))
        done
        echo "---" >> $outfile.mergelist

        cat $outfile.mergelist
        echo "***"

        ./merge.sh $outfile.mergelist
        
        # Remove temporary files
        rm $outfile.partlist $outfile.mergelist
        n=1
        while [ $n -le $i ]
        do
            rm $n.mp4
            n=$(( $n + 1 ))
        done

        i=0
        chk=0
    elif [ $chk -eq 0 ];then
        outfile=`echo $line | tr -d '"'`
        [ -f $outfile.partlist ] && rm $outfile.partlist
        touch $outfile.partlist
        chk=1
    elif [ $chk -eq 1 ];then
        echo $line >> $outfile.partlist
        i=$(( $i + 1 ))
        echo \"$i.mp4\" >> $outfile.partlist
        chk=2
    elif [ $chk -eq 2 ];then
        echo $line >> $outfile.partlist
        chk=3
    elif [ $chk -eq 3 ];then
        echo $line >> $outfile.partlist
        echo "---" >> $outfile.partlist
        chk=1
    fi
done < $1
wait && echo -e "\e[0;32mDone!!\e[0m"
exit 0