#!/bin/bash

echo "=============================="
echo "Starting brscan-skey......."
echo "Container Version: ${BUILD_VERSION:-unknown}"
echo "=============================="

for required_var in NAME MODEL IPADDRESS; do
    if [ -z "${!required_var}" ]; then
        echo "Missing required environment variable: $required_var"
        exit 1
    fi
done

echo "Configuring scanner with runtime environment variables:"
echo "NAME=$NAME"
echo "MODEL=$MODEL"
echo "IPADDRESS=$IPADDRESS"

# Wait for network stability
sleep 5

existing_names=$(/usr/bin/brsaneconfig4 -q | awk '$1 ~ /^[0-9]+$/ { print $2 }')
if [ -n "$existing_names" ]; then
    while IFS= read -r existing_name; do
        [ -n "$existing_name" ] || continue
        /usr/bin/brsaneconfig4 -r "$existing_name"
    done <<EOF
$existing_names
EOF
fi

/usr/bin/brsaneconfig4 -a name="$NAME" model="$MODEL" ip="$IPADDRESS"

echo "Effective brsaneconfig4 configuration:"
/usr/bin/brsaneconfig4 -q

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
