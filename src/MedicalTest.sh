#Marah Hamarsheh 1220281
#Lana Daramna 1220588

choosen=0 	# Initialize value 
# Loop until the user enter 7
while [ "$choosen" -ne 7 ] 
do
# print the operation so the user choose one
echo -e "1-Add a medical test:
2-search for a test by patient ID:
3-search for normal test:
4-Average test value:
5-Update a test result:
6-Delete a medical test:
7-Exist:\n"
echo "choose an operation"
read choosen
 # read what the user enter
echo -e "____________\n"

# check if the user enter a valid number
echo "$choosen" | grep -q '^[0-9]\+$'
# if the user didn't enter a valid input it will ask him again
# loop until the user enter a valid number
while [ $? -ne 0 ]
do
	echo "choose an operation"
	read choosen
	echo -e "____________\n"
	# check if the user enter a valid number
	echo "$choosen" | grep -q '^[0-9]\+$'
done 	# end of while loop

# all the operation
case "$choosen" in
 1) # If the user chooses 1, it will add a new test
    # let the user to enter initial information
    echo "Write ID:"; read ID
    echo "Write test name:"; read name
    echo "Write the date (yyyy-mm):"; read Date
    echo "Write the test result (numeric or decimal):"; read result
    echo "Write the test status (pending, completed, Reviewed):"; read status
    echo -e "____________\n"
    # Validate ID
    while (! echo "$ID" | grep -q '^[0-9]\+$'); do
        echo "Invalid ID. It should be numeric."
        echo "Write ID:"; read ID
    done

    # Validate test name
    while (! echo "$name" | grep -q '^[A-Za-z ]\+$'); do
        echo "Invalid test name. It should contain only letters and spaces."
        echo "Write test name:"; read name
    done

    # Validate date
    while ! echo "$Date" | grep -q '^[0-9]\{4\}-[0-9]\{2\}$'; do
        echo "Invalid date. It should be in the format yyyy-mm."
        echo "Write the date (yyyy-mm):"; read Date
    done

    # Validate result
    while ! (echo "$result" | grep -q '^[0-9]\+$' || echo "$result" | grep -q '^[0-9]*\.[0-9]\+$'); do
        echo "Invalid result. It should be numeric or a decimal number."
        echo "Write the test result (numeric or decimal):"; read result
    done

    # Validate status
    while true; do
        if [ "$status" = "pending" ] || [ "$status" = "completed" ] || [ "$status" = "Reviewed" ]; then
            break
        else
            echo "Invalid status. It should be 'pending', 'completed', or 'Reviewed'."
            echo "Write the test status (pending, completed, Reviewed):"; read status
        fi
    done
    # Check if the test name exists in the system
    if (! grep -q "$name" medicaltest.txt ); then
        echo "Sorry, but our system does not support a test of this type: $name."
        echo -e "____________\n"
        continue  # Re-prompt the user for all inputs
    fi

    # Extract the unit from the medicaltest.txt file
    unit=$(grep "$name" medicaltest.txt | cut -d';' -f3 | cut -d':' -f2 | xargs)

    # Format the information to add to the file
    answer=$(echo "$ID: $name, $Date, $result, $unit, $status")

    # Check if the test already exists in medicalRecord.txt
    if grep -q "$answer" medicalRecord.txt; then
        echo "The test already exists."
    else
        # If the test does not exist, add it to the file
        echo "$answer" >> medicalRecord.txt
        cat  medicalRecord.txt
        echo -e "\nThe test was added successfully."
    fi
    echo -e "____________\n"
    ;;

2) # if the user choose 2 it will do some operation using patient ID
	echo  "Write the patient ID:" 	# ask the user to enter the patient ID
	read answer	 # read the answer and save it
	echo -e "____________\n"
	echo "$answer" | grep -q '^[0-9]\+$' 	# check if the answer is valid
	while [ $? -ne 0 ]	# loop until the user enter a valid input
	do
		echo "Invalid ID. It should be an integer."
		echo  "Rewrite the patient ID:"
		read answer
		echo -e "____________\n"
		echo "$answer" | grep -q '^[0-9]\+$'	# check if the answer is valid
	done
	
	new=$(grep "$answer" medicalRecord.txt | cut -d':' -f1 | uniq)	
	[ "$answer" = "$new" ]		# check if the patient exist
			
	if [ $? -ne  0 ]  # if it is not exist
	then
		echo  "No patient with this ID"
		echo -e "____________\n"
		
	else
	
	# print the operation so the user choose one
	echo "choose an operation"
	echo -e "1-Retrieve all patient tests:\n2-Retrieve all up normal patient tests:
3-Retrieve all patient tests in a given specific period:
4-Retrieve all patient tests based on test status:\n"
	read op
	echo -e "____________\n"
	
	echo "$op" | grep -q '^[0-9]\+$'	# check if the answer is valid
	while [ $? -ne 0 ]		# loop until the user enter a valid input
	do
		echo "choose an operation"
		read op
		echo -e "____________\n"
		echo "$op" | grep -q '^[0-9]\+$'	# check if the answer is valid
	done

		case "$op" in	# all the operation
 		1)	# if the user choose 1 it will print all the patient test
			grep "$answer" medicalRecord.txt
			echo -e "____________\n"
			;; # break
	
		2) # if the user choose 2 it will print all the patient normal test
			# Create the necessary temporary files
			touch id_n.txt
			touch Range_of_each_test.txt
			touch normal_test.txt
			# Search for the patient's records based on their ID
			grep "$answer" medicalRecord.txt > id_n.txt
			# Initialize counter
			counter=1
			# Get the number of lines (tests) for the patient
			n=$(cat id_n.txt | wc -l)
			
			# Loop through each test line
			while [ "$counter" -le "$n" ]
			do
				# Extract the specific line from id_n.txt
				line=$(sed -n "${counter}p" id_n.txt)
				# Extract the test name and remove spaces
				test_name=$(echo "$line" | cut -d ',' -f1 | cut -d ':' -f2 | tr -d ' ')
				# echo "Test name: $test_name"
				# Extract the test result and remove spaces
				test_value=$(echo "$line" | cut -d ',' -f3 | tr -d ' ')
				#Find the normal range for the test name
				range=$(grep "$test_name" medicaltest.txt | cut -d ';' -f2)
				# Determine min and max values based on the range format
				# Equilibrium equation: A test value is considered "normal" if it falls within the defined range.
				# Specifically, if min_value <= test_value <= max_value, the test is "pass"; otherwise, it is "fail".
				# Determine min and max values based on the range format
				if echo "$range" | grep -q ',' ; then
					# equlibrim with $(echo "$range"|grep -q ',' ) " -eq 0 then
					# Range format: >min_value, <max_value
					min_value=$(echo "$range" | cut -d '>' -f2 | cut -d ',' -f1 | tr -d ' ')
					max_value=$(echo "$range" | cut -d '<' -f2 | tr -d ' ')
				
				elif echo "$range" | grep -q '>'; then
					# Range format: >min_value (no upper limit)
					min_value=$(echo "$range" | cut -d '>' -f2 | tr -d ' ')
					max_value="99999.0" # Set a very high max_value
				
				elif echo "$range" | grep -q '<'; then
					# Range format: <max_value (no lower limit)
					max_value=$(echo "$range" | cut -d '<' -f2 | tr -d ' ')
					min_value="0.0" # Set a very low min_value
				else
					# Default case if no range is specified
					min_value="0.0"
					max_value="99999.0"
				fi
				min_comparison=$(echo "$test_value >= $min_value" | bc)
				max_comparison=$(echo "$test_value <= $max_value" | bc)
				
				# Check if the test value is within the normal range
				if [ "$min_comparison" -eq 1 -a "$max_comparison" -eq 1 ]; then
   				echo "$line" >> normal_test.txt
				fi
				counter=$((counter + 1))
			done
			cat normal_test.txt
			echo -e "____________\n"
			# Remove temporary files
			rm id_n.txt
			rm Range_of_each_test.txt
			rm normal_test.txt
			;; # break
	
		3) # if the user choose 3 it will print all the patient test in specific period
			echo -e "Write the period yyyy-mm to yyyy-mm:" 	# ask the user to enter the period
			read period
			echo -e "____________\n"
			
			T1=$(echo "$period" |cut -d' ' -f1 |tr -d '-') 	# take the first date and delete (-)
			T2=$(echo "$period" |cut -d' ' -f3 |tr -d '-')  # take the second date and delete (-)
			
			(echo "$T1" | grep -q '^[0-9]\+$') && (echo "$T2" | grep -q '^[0-9]\+$') 	# check if the enter is valid
			while [ $? -ne 0 ]	# loop until the user enter a valid input
			do
				echo -e "Write the period yyyy-mm to yyyy-mm:"
				read period
				echo -e "____________\n"
			
				T1=$(echo "$period" |cut -d' ' -f1 |tr -d '-')
				T2=$(echo "$period" |cut -d' ' -f3 |tr -d '-')
	
				(echo "$T1" | grep -q '^[0-9]\+$') && (echo "$T2" | grep -q '^[0-9]\+$') 	# check if the enter is valid
			done
			
			(grep "$answer" medicalRecord.txt) > id.txt  # save the patient's test based on ID
			(cat id.txt | cut -d',' -f2)  > time.txt     # save the date from the file that contain the patient test
			(sort -n time.txt | uniq ) > sort.txt			# save after sort the date and take the unique so there is no repeated date
			count=$(cat sort.txt | wc -l)  # get the number of lines (dates)  

			n=1 	# Initialize value
			while [ "$n" -le "$count" ] 	# Loop through each date line
			do
				test=$(sed -n "${n}p" sort.txt )  # Extract the specific line from sort.txt
				t=$(echo "$test" | tr -d '-')   # delete (-) from the date so we can compare
		
				if [ "$t" -ge "$T1" -a "$t" -le "$T2" ]  # if the date from the file in the range of the period user enter
				then														# then print the date
					grep $test id.txt
				fi
				n=$((n + 1)) 	# so we go through the next lines
	
			done
			echo -e "____________\n"
			# Remove temporary files
			rm time.txt
			rm sort.txt
			rm id.txt 
			;; # break
	
		4) # if the user choose 4 it will print all the test have the same status as user enter
			grep "$answer" medicalRecord.txt > id.txt		# save the patient's test based on ID
			echo  "Write the test status(pending,completed,Reviewed):" # ask the user which status
			read status
			echo -e "____________\n"
			# check if the enter is valid
			while true; do
        		if [ "$status" = "pending" ] || [ "$status" = "completed" ] || [ "$status" = "Reviewed" ]; then
           		 break
        		else
          		  echo "Invalid status. It should be 'pending', 'completed', or 'Reviewed'."
            		echo "Write the test status (pending, completed, Reviewed):"; read status
       			 fi
  			  done
			grep "$status" id.txt 
			echo -e "____________\n"
			rm id.txt   # Remove temporary file
			;;	 # break
			
		*) echo "This operation doesn't exist"
			echo -e "____________\n" 
			;;
		esac  # end the case statement
		
	fi
	;; # break
	
3) # if the user choose 3 it will print all normal test
	# Create the necessary temporary files
	touch Range_of_each_test.txt
	touch normal_test.txt
	# Initialize counter
	counter=1
	# Get the number of lines (tests) for the patient
	n=$(cat medicalRecord.txt| wc -l)
	# Loop through each test line
	while [ "$counter" -le "$n" ]
	do
		# Extract the specific line from id_n.txt
		line=$(sed -n "${counter}p" medicalRecord.txt)
		# Extract the test name and remove spaces
		test_name=$(echo "$line" | cut -d ',' -f1 | cut -d ':' -f2 | tr -d ' ')
		# echo "Test name: $test_name"
		# Extract the test result and remove spaces
		test_value=$(echo "$line" | cut -d ',' -f3 | tr -d ' ')
		#Find the normal range for the test name
		range=$(grep "$test_name" medicaltest.txt | cut -d ';' -f2)
		if echo "$range" | grep -q ',' 
		 then
			# equlibrim with $(echo "$range"|grep -q ',' ) " -eq 0 then
			# Range format: >min_value, <max_value
			min_value=$(echo "$range" | cut -d '>' -f2 | cut -d ',' -f1 | tr -d ' ')
			max_value=$(echo "$range" | cut -d '<' -f2 | tr -d ' ')
			
		elif echo "$range" | grep -q '>'
		then
			# Range format: >min_value (no upper limit)
			min_value=$(echo "$range" | cut -d '>' -f2 | tr -d ' ')
			max_value="99999.0" # Set a very high max_value
		elif echo "$range" | grep -q '<'
		then
			# Range format: <max_value (no lower limit)
			max_value=$(echo "$range" | cut -d '<' -f2 | tr -d ' ')
			min_value="0.0" # Set a very low min_value
		else
			# Default case if no range is specified
			min_value="0.0"
			max_value="99999.0"
		fi
		# Perform the comparisons using basic shell arithmetic
		min_comparison=$(echo "$test_value >= $min_value" | bc)
		max_comparison=$(echo "$test_value <= $max_value" | bc)
		# Check if the test value is within the normal range
		if [ "$min_comparison" -eq 1 -a "$max_comparison" -eq 1 ]; then
   		echo "$line" >> normal_test.txt
		fi
		counter=$((counter + 1))
	done
	cat normal_test.txt
	echo -e "____________\n"
	# Remove temporary files
	rm Range_of_each_test.txt
	rm normal_test.txt
	;;  # break
	
4) # if the user choose 4 it will print the average
	cat medicalRecord.txt | cut -d',' -f1 | cut -d':' -f2  > name.txt  # save all name of tests
	sort name.txt | uniq  > sort.txt  # save after sort the names and take the unique so there is no repeated names
	count=$(cat sort.txt | wc -l)   # get the number of lines (names) 
	
	num=1  # Initialize value
	while [ "$num" -le "$count" ]   # Loop through each name line
	do
		testn=$(sed -n "${num}p" sort.txt )   # Extract the specific line from sort.txt
		(grep "$testn" medicalRecord.txt | cut -d',' -f3) > value.txt   # save all result of the same test
		count2=$(cat value.txt | wc -l)   # get the number of lines (values)
	
		n2=1   # Initialize value
		sum=0  # Initialize value
		while [ "$n2" -le "$count2" ]   # Loop through each name line
		do
			val=$(sed -n "${n2}p" value.txt )   # Extract the specific line from value.txt
			sum=$(echo "scale=2; $sum + $val" | bc) # sum the value whether they are integer or float
			# where bc turn the number to integer and scale save the digit after the decimal point (.)
			n2=$((n2 + 1))  # so we go through the next lines
		done
		
		avg=$(echo "scale=2; $sum / $count2" | bc) # calculate the average whether they are integer or float
		# where bc turn the number to integer and scale save the digit after the decimal point (.)
		echo "Test $testn average = $avg"  # print the average of each test
		num=$((num + 1))  # so we go through the next lines
	done
	echo -e "____________\n"
	# Remove temporary files
	rm value.txt
	rm name.txt
	rm sort.txt
	;;  # break

5)
#update case
	echo -e "Write the patient ID:"
	read ID
	#take an id from the user
	echo -e "____________\n"
		
	echo "$ID" | grep -q '^[0-9]\+$' 
	while [ $? -ne 0 ]
	#If ID contains only digits, grep -q will find a match and exit with status 0 . then is not enter  the loop
	do
	#loop it still take a input until input just an digits
		echo -e "wrong in id please Rewrite the patient ID:"
		read ID
		echo -e "____________\n"
	
		echo "$ID" | grep -q '^[0-9]\+$'
	done
	grep "$ID:" medicalRecord.txt > id.txt
	#^$ID to ensure that contain an id in the same way
	if [ $(cat id.txt | wc -l) -eq 0 ]; 
	#check if id.txt empty or not if it is empty that mean the person with id have no test
	then
	echo "No tests found for the person with ID $ID."
	echo -e "____________\n"
	
	
	else
	#search the test for the same person
	cat id.txt #print all test for the person with input id to be easier to the user work with data
	echo -e "\n____________\n"
	echo -e "Write the test name:"
	read name
	echo -e "____________\n"
	
	echo "$name" | grep -q '^[A-Za-z]\+$'
	#check if the name of test is contain a char only
	while [ $? -ne 0 ]
	do
	#repeat until get the true input 
		echo -e "the test name is a string of char just please rewrite the name of test"
		read name
		echo -e "____________\n"
	
		echo "$name" | grep -q '^[A-Za-z]\+$'
	done
	if (! grep -q "$name" id.txt ); then
        echo "Sorry, but this person doesn't do this test: $name."
        echo -e "____________\n"
        continue  # Re-prompt the user for all inputs
    	fi
	(grep "$name" id.txt) > test.txt
	#we take the line with the same input id and the same test name
	line=$(cat test.txt | wc -l)
		
	if [ "$line" -gt 1 ]  #we check if we have multiple test for the same person
	then 
		cat -n test.txt
		echo -e "\n____________\n"
	
		echo "choose a line:"
		read number
		echo -e "____________\n"
		#we display all test for the same person with the same test
		echo "$number" | grep -q '^[0-9]\+$'
		#let user choose line to edit the test on it 
		while [ $? -ne 0 ]
		do
			echo -e "choose a line:"
			read number
			echo -e "____________\n"
		
			echo "$number" | grep -q '^[0-9]\+$' #found the line that we need to updated
		done
		echo "enter the new value:"
		read value
		val=" $value"
		echo -e "____________\n"
				
		
		while [ $? -ne 0 ]
		do
			echo "enter the new value:"
			read value
			val=" $value"
			echo -e "____________\n"
				
			(echo "$value" | grep -q '^[0-9]\+$') || (echo "$value" | grep -q '^[0-9]*\.[0-9]\+$')
			#checks if the variable value is an integer or a float.
		done
	
		l=$(sed -n "${number}p" test.txt)
		#read the line with line =number and store it in l
		test=$(sed -n "${number}p" test.txt | cut -d',' -f3 )
		#taking the old result of test
		(grep -v  "$l" medicalRecord.txt) > newRecord.txt
		#delete the line that match with our 
		mv newRecord.txt  medicalRecord.txt
		#save the result in new file name newRecord.txt
		sed -i "${number}s/${test}/${val}/g" test.txt
		#replace the contain of test result with the user input value
		sed -n "${number}p" test.txt  >> medicalRecord.txt
		#add the edit line to file
		cat test.txt
		echo -e "____________\n"
		cat medicalRecord.txt
		echo -e "____________\n"
		rm id.txt
		rm test.txt
			
	else #if we have just one special test for the person
		cat test.txt #repeat the step in appear case but without ask the user which line
		echo -e "\n____________\n"
			
		echo "enter the new value:"
		read value
		val=" $value"
		echo -e "____________\n"
	
		(echo "$value" | grep -q '^[0-9]\+$') || (echo "$value" | grep -q '^[0-9]*\.[0-9]\+$')
		while [ $? -ne 0 ]
		do
			echo "enter the new value:"
			read value
			val=" $value"
			echo -e "____________\n"
				
			(echo "$value" | grep -q '^[0-9]\+$') || (echo "$value" | grep -q '^[0-9]*\.[0-9]\+$')
		done

		l=$(cat test.txt)
		test=$(cat test.txt | cut -d',' -f3 )
		(grep -v  "$l" medicalRecord.txt) > newRecord.txt
		mv newRecord.txt  medicalRecord.txt
		sed -i "s/${test}/${val}/g" test.txt
		cat test.txt  >> medicalRecord.txt
				
		cat test.txt
		echo -e "____________\n"
		cat medicalRecord.txt
		echo -e "____________\n"
		rm id.txt
		rm test.txt
				
	fi
	fi
	;;   # break

6)
#delete case
	cat medicalRecord.txt
	echo -e "____________\n" 
	echo  "Write the patient ID:"
	read ID
	echo -e "____________\n"

	echo "$ID" | grep -q '^[0-9]\+$' #check if the input value is accepted or not same way in update
	while [ $? -ne 0 ]
	do
		echo -e "Write the patient ID:"
		read ID
		echo -e "____________\n"
		echo "$ID" | grep -q '^[0-9]\+$'
	done

	(grep "$ID:" medicalRecord.txt) > id.txt # save the patient test in file
	
	if [ $(cat id.txt | wc -c) -eq 0 ]; #check if id.txt empty or not if it is empty that mean the person with id have no test
	then
		echo "No tests found for the person with ID $ID."
		echo -e "____________\n"
	
	elif [ $( cat id.txt | wc -l) -eq 1 ]; #check if id.txt has one test if there one line then there is no need to ask the user about the line
	then
		cat  id.txt
		echo -e "____________\n"
		echo "Are you sure you want to delete(Y/N)?" # ask the user if he sure he want to delete
		read check
		echo -e "____________\n"
		while [ "$check" != "Y" -a "$check" != "y" -a "$check" != "N" -a "$check" != "n" ]; do
    		echo "Invalid input. Please enter Y/y for yes or N/n for no."
    		echo "Are you sure you want to delete (Y/N)?"
    		read check
   		echo -e "____________\n"
		done
		
		if [ "$check" = "Y" -o "$check" = "y" ]; # if yes then it will delete the line that user choose
		then
			line=$(cat id.txt)
			#store the line in var named line
			(grep -v  "$line" medicalRecord.txt) > newRecord.txt
			#using grep we search about the line in our file and delete it and rewrite the date in new file 
			mv newRecord.txt  medicalRecord.txt
			#change the contain of the original line
			cat medicalRecord.txt
			echo -e "\ndelete file ended"
			echo -e "____________\n"
			rm id.txt
			
		else  # else it will not delete
		echo -e "____________\n"
		fi
		
	else
		cat -n id.txt
		echo -e "____________\n"
		echo "choose a line:"
		read number
		echo -e "____________\n"
		echo "$number" | grep -q '^[0-9]\+$'  #check if the input value is accepted or not
		while [ $? -ne 0 ]
		do
			echo -e "choose a line:"
			read number
			echo -e "____________\n"
			echo "$number" | grep -q '^[0-9]\+$'  #check if the input value is accepted or not 
		done 
		#make sure the number input is only line

		echo "Are you sure you want to delete(Y/N)?" # ask the user if he sure he want to delete
		read check
		echo -e "____________\n"
		while [ "$check" != "Y" -a "$check" != "y" -a "$check" != "N" -a "$check" != "n" ]; do
    		echo "Invalid input. Please enter Y/y for yes or N/n for no."
    		echo "Are you sure you want to delete (Y/N)?"
    		read check
   		echo -e "____________\n"
		done
		if [ "$check" = "Y" -o "$check" = "y" ]; # if yes then it will delete the line that user choose
		then
			line=$(sed -n "${number}p" id.txt)
			#store the line in var named line
			(grep -v  "$line" medicalRecord.txt) > newRecord.txt
			#using grep we search about the line in our file and delete it and rewrite the date in new file 
			mv newRecord.txt  medicalRecord.txt
			#change the contain of the original line
			cat medicalRecord.txt
			echo -e "\ndelete file ended"
			echo -e "____________\n"
			rm id.txt
		
		else  # else it will not delete
		echo -e "____________\n"
		fi
	fi
	;;  # break

7) ;; # if the user enter 7 exit 

*) echo "This operation doesn't exist"   # if the user enter a number(op) doesn't exist it tell the user that there no operation 
	echo -e "____________\n" 
	;; # break
		
esac  # end the case statement
done # end the loop
