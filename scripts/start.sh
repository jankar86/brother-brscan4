echo "Starting brscan-skey......."
sleep 5
echo "using the following environment variables:"

echo
#/usr/bin/brsaneconfig4 -a name=$SCANNER_NAME model=$SCANNER_MODEL ip=$SCANNER_IP_ADDRESS
/usr/bin/brscan-skey

processId=$(ps -ef | grep 'brscan-skey' | grep -v 'grep' | awk '{ printf $2 }')
echo $processId


while true; do
  #Wait 5 min
  sleep 300

   if pgrep -x "brscan-skey-exe" > /dev/null
       then
                # Do nothing
                echo "brscan-skey-exe Running" > /dev/null

        else

                echo "brscan-skey-exe is Stopped! try to restart it now. "
                /usr/bin/brscan-skey
        fi

done
exit 0