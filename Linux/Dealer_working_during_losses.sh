awk '{print $1, $2, $5, $6}' $1 | grep $2:00:00 | grep $3
