i=0
arr=""
file=""
while getopts  f: flag
do
	
	case "${flag}" in
	f)file=${OPTARG}
	esac

done
while IFS='\n' read -r line
do
	arr[$i]="[$line]"
	i=$((i + 1))
done < $file


a="some long string"
b=":"
str=""
uniq=""

for ((i=0; i<${#arr[@]}; i++))
do
	#########
	first=`echo "${arr[$i]}" | awk '{sub(/\".*/,"");print length($0)+1}'` 
	last=`echo "${arr[$i]}" | awk '{sub(/:.*/,"");print length($0)+1}'`


	len=$(($last - $first - 2))

	new=`echo ${arr[$i]:$first:$len}`

	str="${str}${new}"
	
	######
	if [[ $uniq != *$new* ]]
	then
		uniq="${uniq}${new}"
		curly=`echo ${arr[$i]%\{*} | wc -c`
		normal=`echo ${arr[$i]%\[*} | wc -c`

		if [[ ${arr[$i]} == *"{"* && curly -gt 5 ]]; then
			echo $str
			str="${str}."
		elif [[ ${arr[$i]} == *"["* && normal -gt 5 ]]; then
			str="${str}[]"
			echo $str
			str="${str}."
		elif [[ ${arr[$i]} == *"}"* ]]; then
			a=1
		elif [[ ${arr[$i]} == *"],"* ]]; then
			
			last=`echo ${str%[*} | wc -c`
			len=$(($last - 1))
			str=`echo ${str:0:$len}`

			last=`echo ${str%.*} | wc -c`
			len=$(($last))
			str=`echo ${str:0:$len}`

		else
			echo $str
			last=`echo ${str%.*} | wc -c`
			str=`echo ${str:0:$last}`

			#remove last
		fi

	else
		curly=`echo ${arr[$i]%\{*} | wc -c`
		normal=`echo ${arr[$i]%\[*} | wc -c`

		if [[ ${arr[$i]} == *"{"* && curly -gt 5 ]]; then

			str="${str}."
		elif [[ ${arr[$i]} == *"["* && normal -gt 5 ]]; then

			str="${str}[]."

		elif [[ ${arr[$i]} == *"}"* ]]; then
			a=1

		elif [[ ${arr[$i]} == *"],"* ]]; then
			last=`echo ${str%[*} | wc -c`
			len=$(($last - 1))
			str=`echo ${str:0:$len}`
			
			newFirst=`echo ${str%.*} | wc -c`
			str2=`echo ${str:$newFirst:$(($last - $newFirst))}`
			last=`echo ${uniq%$str2*} | wc -c`
			uniq=`echo ${uniq:0:$(($last - 1))}`
			
			last=`echo ${str%.*} | wc -c`
			len=$(($last))
			str=`echo ${str:0:$len}`
		else

			last=`echo ${str%.*} | wc -c`
			str=`echo ${str:0:$last}`

			#remove last
		fi
	fi

	
	# if ] remove[]. and sondan ilk kotaya kadar ki kısmı al
	
done


