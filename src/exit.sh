echo -e "Write the test name:"
	read name
	echo -e "____________\n"


 (echo "$name" | grep -q '^[A-Za-z]\+$')
while [ $? -ne 0 ]
do
	echo -e "rewrite:"
	read name
	echo -e "____________\n"
	(echo "$name" | grep -q '^[A-Za-z]\+$')
done

		
