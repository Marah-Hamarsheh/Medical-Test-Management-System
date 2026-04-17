echo "write Id:"; read ID
	echo "write test name:"; read name
	echo "write the date yyyy-mm:"; read Date
	echo "write the test result:"; read result
	echo "write the unit xx/yy :"; read unit
	echo "write the test status (pending,completed,Reviewed):"; read status
	echo -e "____________\n"
	
	# check if the user enter a valid inputs
	(echo "$ID" | grep -q '^[0-9]\+$') && (echo "$name" | grep -q '^[A-Za-z]\+$') && (echo "$Date" | grep -q '^[-0-9]\+$') && ((echo "$result" | grep -q '^[0-9]\+$') || (echo "$result" | grep -q '^[0-9]*\.[0-9]\+$')) &&(echo "$unit" | grep -q '^[A-Za-z/]\+$') && (echo "$status" | grep -q '^[A-Za-z]\+$');
	# if the user didn't enter a valid inputs it will ask him again
	# loop until the user enter a valid inputs
	while [ $? -ne 0 ]
	do
		echo "write Id:"; read ID
		echo "write test name:"; read name
		echo "write the date yyyy-mm:" ;read Date
		echo "write the test result:";read result
		echo "write the unit xx/yy :" ;read unit
		echo "write the test status (pending,completed,Reviewed):"; read status
		echo -e "____________\n"
		# check if the user enter a valid inputs
		(echo "$ID" | grep -q '^[0-9]\+$') && (echo "$name" | grep -q '^[A-Za-z]\+$')&& (echo "$Date" | grep -q '^[-0-9]\+$') && ((echo "$result" | grep -q '^[0-9]\+$') || (echo "$result" | grep -q '^[0-9]*\.[0-9]\+$'))&&(echo "$unit" | grep -q '^[A-Za-z/]\+$') && (echo "$status" | grep -q '^[A-Za-z]\+$');
	done 
