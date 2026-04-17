echo -e "Write the patient ID:"
read ID
echo -e "____________\n"
		
echo "$ID" | grep -q '^[0-9]\+$'
while [ $? -ne 0 ]
do
	echo -e "Write the patient ID:"
	read ID
	echo -e "____________\n"
	
	echo "$ID" | grep -q '^[0-9]\+$'
done

(grep "$ID" medicalRecord.txt) > id.txt
cat id.txt
echo -e "\n____________\n"
	
echo -e "Write the test name:"
read name
echo -e "____________\n"
	
echo "$name" | grep -q '^[A-Za-z]\+$'
while [ $? -ne 0 ]
do
	echo -e "Write the test name:"
	read name
	echo -e "____________\n"
	
	echo "$name" | grep -q '^[A-Za-z]\+$'
done

(grep "$name" id.txt) > test.txt
line=$(cat test.txt | wc -l)
		
if [ "$line" -gt 1 ]  
then
	cat -n test.txt
	echo -e "\n____________\n"
	
	echo "choose a line:"
	read number
	echo -e "____________\n"
		
	echo "$number" | grep -q '^[0-9]\+$'
	while [ $? -ne 0 ]
	do
		echo -e "choose a line:"
		read number
		echo -e "____________\n"
		
		echo "$number" | grep -q '^[0-9]\+$'
	done
	
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
	
	l=$(sed -n "${number}p" test.txt)
	test=$(sed -n "${number}p" test.txt | cut -d',' -f3 )
	(grep -v  "$l" medicalRecord.txt) > newRecord.txt
	mv newRecord.txt  medicalRecord.txt
	sed -i "${number}s/${test}/${val}/g" test.txt
	sed -n "${number}p" test.txt  >> medicalRecord.txt

	cat test.txt
	echo -e "____________\n"
	cat medicalRecord.txt
	rm id.txt
	rm test.txt
			
else
	cat test.txt
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
	rm id.txt
	rm test.txt
				
fi
