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
cat -n id.txt
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

line=$(sed -n "${number}p" id.txt)
(grep -v  "$line" medicalRecord.txt) > newRecord.txt
mv newRecord.txt  medicalRecord.txt

cat medicalRecord.txt
rm id.txt
