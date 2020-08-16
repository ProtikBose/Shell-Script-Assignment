#!/bin/bash
 
#unzip -o "submissionsAll.zip" -d backup1/
Output="OutputStore"
cp CSE_322.csv backup1
cd backup1
mkdir "$Output"
touch Absents.txt
touch Marks.txt
 
existenceCheck()
{
    cd ..
    cd ..
    cp CSE_322.csv backup1
    cd backup1
    searchNum=$(grep -ic "$1" CSE_322.csv)
    if [ $searchNum -eq 1 ]; then
        return 1
    else
       
        searchNum1=$(grep -ic "$1" CSE_322.csv)
        if [ $searchNum1 -eq 0 ]; then
            return 0
        else
            return 1
        fi
    fi
   
}
 
 
rostercheck()
{
   
    searchNum=$(grep -ic "$1" CSE_322.csv)
    roll=$(grep -i "$1" CSE_322.csv)
   
    if [ $searchNum = 1 ]; then
       
        if echo "$roll" | grep -q "\""; then
            echo "achi"
            roll="$(cut -d"\"" -f2 <<<"$roll")"
            roll=$(echo $roll | tr -d ' ')
            cd tempFolder
            mv "$2" ..
            cd ..
            mv "$2" "$Output"
            cd "$Output"
            mv "$2" "$roll"     #name changed
            echo "$roll   0" >> Marks.txt
            sed -i "/$roll/d" Absents.txt
            cd ..
            rm -r 'tempFolder'
	else
	    echo "achi"
            roll="$(cut -d',' -f2 <<<"$roll")"
            roll=$(echo $roll | tr -d ' ')
            cd tempFolder
            mv "$2" ..
            cd ..
            mv "$2" "$Output"
            cd "$Output"
            mv "$2" "$roll"     #name changed
            echo "$roll   0" >> Marks.txt
            sed -i "/$roll/d" Absents.txt
            cd ..
            rm -r 'tempFolder'
        fi
       
       
       
       
    else
	
       if echo "$roll" | grep -q "\""; then
		search=$(grep -i "$1" CSE_322.csv)
		#echo $searchNum
		#echo $search
		((searchNum++))
		roll2=$(echo $search | tr -d ' ')
		roll3=$(cut -d',' -f "$searchNum" <<<"$roll2")
		echo $roll3
		((searchNum--))
		cd "$Output"
		flag1=0
		flag2=0
		for((i=1;i<=searchNum;i++))
		do
			if [ $i -gt 1 ]; then
				roll2=$(echo $search | tr -d ' ')
				roll2=$(cut -d',' -f "$i" <<<"$roll2")	
		
				roll22=${roll2#"$roll3"}
				val=$(grep -c "$roll22" Absents.txt)
				if [ "$val" = "0" ]; then
					((flag2++))
					echo "2"
				fi
			else
				roll=$(echo $search | tr -d ' ')
				roll21=$(cut -d',' -f "$i" <<<"$roll")
				val=$(grep -c "$roll21" Absents.txt)
				if [ "$val" = "0" ]; then
					((flag1++))
					echo "1"
				fi	
			fi
		
	
		done
		cd ..
		state="none"
		if [ "$flag1" = "0" ]; then
			if [ "$flag2" = "0" ]; then
				state="extra"
			else
				state="number1"
			fi	
		else
			if [ "$flag2" = "0" ]; then
				state="number2"
			else
				state="extra"
			fi
		fi
		fin="Extra"
		cd tempFolder
	        mv "$2" ..
	        cd ..
	        mv "$2" "$Output"
	        cd "$Output"
           

		if [ "$state" = "extra" ]; then
			mv "$2" "$1"     #name changed
			mv "$1" "$fin"	
		
			cd ..
	            	rm -r 'tempFolder'

		elif [ "$state" = "number1" ]; then
			 mv "$2" "$roll21"     #name changed
	            	 echo "$roll21   0" >> Marks.txt
			 cd ..
	                 rm -r 'tempFolder'	
		elif [ "$state" = "number2" ]; then
			 mv "$2" "$roll22"     #name changed
	            	 echo "$roll22   0" >> Marks.txt
			 cd ..
	                 rm -r 'tempFolder'
		fi
	else
		echo "ok"
	fi
  fi
   
}
 
 
 
stdcnt=$(grep -v "^#" CSE_322.csv|wc -l)
for((i=stdcnt;i>=1;i--))
do
   
   
    stdID=$(grep -v "^#" CSE_322.csv|tail -n $i|head -n 1|cut -d "," -f 1|cut -d "\"" -f 2)
    stdID=$(echo $stdID)
    stdIDPattern="${stdID}"
   
   
    found=$(find .  -name "*$stdIDPattern*" -type f|wc -l)
    if [ $found -eq 0 ]; then
       
        stdName=$(grep -v "^#" CSE_322.csv|tail -n $i|head -n 1|cut -d "," -f 2)
        stdName=$(echo $stdName)
       
        found=$(find .  -name "*$stdName*" -type f|wc -l)
       
        if [ $found -eq 0 ]; then
        	echo "$stdID" >> Absents.txt
        	echo "$stdID 0" >> Marks.txt
        elif [ $found -gt 1 ]; then
                echo "$stdID" >> Absents.txt
        	echo "$stdID 0" >> Marks.txt    
        fi
   
    fi
 
done
rm -r 'CSE_322.csv'
cd ..
 
cd backup1
mv Absents.txt "$Output"
mv Marks.txt "$Output"
 
cd "$Output"
mkdir "Extra"
cd ..
 
for file in *
do
   
   
    if echo "$file" | grep -q "\.zip"; then
        #unzip -d tempFolder/ "$file"
        unzip -o "$file" -d tempFolder/
        filename="${file%.zip}"
        cd tempFolder
        fileNum=$(ls -l | grep "^d" | wc -l)
        filename1="$(cut -d'_' -f5 <<<"$filename")"    # roll number
        personname="$(cut -d'_' -f1 <<<"$filename")"   #student name
   
   
        if [ $fileNum -gt 1 ]; then

            if [[ "$filename1" =~ ^[0-9]+$ ]]; then
		cd ..
		cd ..
		cp CSE_322.csv backup1
    		cd backup1
		roster="CSE_322.csv"
		if grep -w "$filename1" "$roster"; then
			rm -r 'CSE_322.csv'
			cd tempFolder
               		mkdir "$filename1"
                	for fl in *
                	do
                	    if ! [[ "$fl" = "$filename1" ]]; then
                	        mv "$fl" "$filename1"
                	    fi
                	done           
                	mv "$filename1" ..
               
                	cd ..
                	rm -r 'tempFolder'
                	mv "$filename1" "$Output"
                	cd "$Output"
                	echo "$filename1   0" >> Marks.txt
                	cd ..
 			echo "ok1"
		else
			cd tempFolder
               		mkdir "$filename1"
                	for fl in *
                	do
                	    if ! [[ "$fl" = "$filename1" ]]; then
                	        mv "$fl" "$filename1"
                	    fi
                	done           
                	mv "$filename1" ..
               
                	cd ..
                	rm -r 'tempFolder'
                	mv "$filename1" "$Output"
                	cd "$Output"
                	
			mv "$filename1" "$personname"     #name changed 
			mv "$personname" Extra
			cd ..
			
			rm -r 'CSE_322.csv'
		fi
            else
                temp="newfolder"
                mkdir "$temp"
                for fl in *
                do
                    if ! [[ "$fl" = "$temp" ]]; then
                        mv "$fl" "$temp"
                    fi
                done
                cd ..
                cd ..
                cp CSE_322.csv backup1
                cd backup1
                rostercheck "$personname" "$temp"  
            fi
 
           
        else
            folderfile=`ls`                 # unzip file name
            if [[ "$filename1" =~ ^[0-9]+$ ]]; then
               
                cd ..
		cd ..
		cp CSE_322.csv backup1
    		cd backup1
		roster="CSE_322.csv"
		if grep -w "$filename1" "$roster"; then
			rm -r 'CSE_322.csv'
			cd tempFolder
               
                	if [ "$filename1" = "$folderfile" ]; then
               
                	    mv "$folderfile" ..                 #move file to parent directory
                	    cd ..            #back to parent directory
                	    mv "$folderfile" "$Output"
                	    cd "$Output"
                	    echo "$folderfile   10" >> Marks.txt
                	    cd ..               #back to parent directory
                	    rm -r 'tempFolder'
                	    echo "Done"
                	elif echo "$folderfile" | grep -q "$filename1"; then
               
                	    mv "$folderfile" ..                   #move file to parent directory
                	    cd ..            #back to parent directory
                	    mv "$folderfile" "$Output"
                	    cd "$Output"
                	    mv "$folderfile" "$filename1"     #name changed
                	    echo "$filename1   5" >> Marks.txt
                	    cd ..               #back to parent directory
                	    rm -r 'tempFolder'     
                	    echo "done again"
                	else
                	    mv "$folderfile" ..                 #move file to parent directory
                	    cd ..            #back to parent directory
                	    mv "$folderfile" "$Output"
                	    cd "$Output"
                	    mv "$folderfile" "$filename1"     #name changed
                	    echo "$filename1   0" >> Marks.txt
                	    cd ..               #back to parent directory
                	    rm -r 'tempFolder'     
                	    echo "done again"  
                	fi
		else
			echo "ok2"
			rm -r 'CSE_322.csv'
			cd tempFolder
			mv "$folderfile" ..                   #move file to parent directory
                	cd ..            #back to parent directory
                	mv "$folderfile" "$Output"
                	cd "$Output"
                	mv "$folderfile" "$filename1"     #name changed
			mv "$filename1" "$personname"     #name changed 
			mv "$personname" Extra
			cd ..
			rm -r 'tempFolder'
		fi
            else
		echo "ok3"
                cd ..
                cd ..
                cp CSE_322.csv backup1
                cd backup1
                rostercheck "$personname" "$folderfile"    
            fi
        fi
    elif echo "$file" | grep -q "\.rar"; then
        filename="${file%.rar}"
        filename1="$(cut -d'_' -f5 <<<"$filename")"    # roll number
        personname="$(cut -d'_' -f1 <<<"$filename")"   #student name
        cd "$Output"
        echo "$filename1   0" >> Marks.txt
        cd ..
        rm -r "$file"
    fi
   
   
done
 
for file in *
do
    if ! [[ "$file" = "$Output" ]]; then
        rm -r "$file"  
    fi
done
