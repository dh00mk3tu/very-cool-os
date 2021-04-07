IFS=";"

while read f1 f2 f3 

do 
    echo "$f1"
    echo $(( $f3 * 0.2 ));
done < prop.txt > output.txt

sort -r output.txt > final.txt

