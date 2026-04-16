echo -e "Write the period yyyy-mm to yyyy-mm:"
read period
echo -e "____________\n"
			
T1=$(echo "$period" |cut -d' ' -f1 |tr -d '-')
T2=$(echo "$period" |cut -d' ' -f3 |tr -d '-')
			
(echo "$T1" | grep -q '^[0-9]\+$') && (echo "$T2" | grep -q '^[0-9]\+$')
while [ $? -ne 0 ]
do
	echo -e "Write the period yyyy-mm to yyyy-mm:"
	read period
	echo -e "____________\n"
			
	T1=$(echo "$period" |cut -d' ' -f1 |tr -d '-')
	T2=$(echo "$period" |cut -d' ' -f3 |tr -d '-')
	
	(echo "$T1" | grep -q '^[0-9]\+$') && (echo "$T2" | grep -q '^[0-9]\+$')
done

(grep 1300500 medicalRecord.txt) > id.txt
(cat id.txt | cut -d',' -f2)  > time.txt
(sort -n time.txt | uniq ) > sort.txt
count=$(cat sort.txt | wc -l)

n=1
while [ "$n" -le "$count" ]
do
	test=$(sed -n "${n}p" sort.txt )
	t=$(echo "$test" |tr -d '-')
		
	if [ "$t" -ge "$T1" ] && [ "$t" -le "$T2" ]
	then
		grep $test id.txt
	
	fi
	n=$((n + 1))
	
done
	
rm time.txt
rm sort.txt
rm id.txt 				
