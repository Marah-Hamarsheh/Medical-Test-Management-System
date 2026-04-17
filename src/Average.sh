(cat medicalRecord.txt | cut -d',' -f1 | cut -d':' -f2)  > name.txt
(sort name.txt | uniq ) > sort.txt
count=$(cat sort.txt | wc -l)
	
num=1
while [ "$num" -le "$count" ]
do
	testn=$(sed -n "${num}p" sort.txt )
	(grep "$testn" medicalRecord.txt | cut -d',' -f3) > value.txt  
	count2=$(cat value.txt | wc -l)
	
	n2=1
	sum=0
	while [ "$n2" -le "$count2" ]
	do
		val=$(sed -n "${n2}p" value.txt )
		sum=$(echo "scale=2; $sum + $val" | bc)
		n2=$((n2 + 1))
	done
	avg=$(echo "scale=2; $sum / $count2" | bc)
	echo "Test $testn average = $avg" 
	num=$((num + 1))
done
	
rm value.txt
rm name.txt
rm sort.txt
