#!/bin/bash

echo "=============================="
echo "Starting brscan-skey......."
echo "Container Version: ${BUILD_VERSION:-unknown}"
echo "=============================="

# Wait for network stability
sleep 5

# Ensure scanner configuration (uncomment if needed)
# /usr/bin/brsaneconfig4 -a name="$SCANNER_NAME" model="$SCANNER_MODEL" ip="$SCANNER_IP_ADDRESS"

# Start brscan-skey in the background
/usr/bin/brscan-skey &
SCAN_PID=$!

echo "brscan-skey started with PID: $SCAN_PID"

# Function to restart brscan-skey with a backoff delay
restart_brscan() {
    echo "$(date) - brscan-skey-exe stopped! Restarting..."
    sleep 5  # Small delay before restart to avoid infinite loops
    /usr/bin/brscan-skey &
    SCAN_PID=$!
    echo "$(date) - Restarted brscan-skey with new PID: $SCAN_PID"
}

# Monitor Process Loop
while true; do
    sleep 300  # Check every 5 minutes

    # Check if brscan-skey is still running
    if ! pgrep -x "brscan-skey" > /dev/null; then
        restart_brscan
    fi
done

# Exit properly
exit 0



##### Old logic #####
# echo "Starting brscan-skey......."
# sleep 5
# echo "using the following environment variables:"
# echo "Container Version: " $BUILD_VERSION
# echo
# #/usr/bin/brsaneconfig4 -a name=$SCANNER_NAME model=$SCANNER_MODEL ip=$SCANNER_IP_ADDRESS
# /usr/bin/brscan-skey

# processId=$(ps -ef | grep 'brscan-skey' | grep -v 'grep' | awk '{ printf $2 }')
# echo $processId


# while true; do
#   #Wait 5 min
#   sleep 300

#    if pgrep -x "brscan-skey-exe" > /dev/null
#        then
#                 # Do nothing
#                 echo "brscan-skey-exe Running" > /dev/null

#         else

#                 echo "brscan-skey-exe is Stopped! try to restart it now. "
#                 /usr/bin/brscan-skey
#         fi

# done
# exit 0