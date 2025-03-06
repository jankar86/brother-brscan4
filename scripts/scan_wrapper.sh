#!/bin/bash
YEAR=$(date +"%Y")

SCRIPT="bash /sane-scan-pdf/scan"
OUTPUTDIR="/scans/$YEAR"
DEVICE="brother4:net1\;dev0"
OUTPUT=$OUTPUTDIR/"`date +%Y-%m-%d-%H-%M`""_$1.pdf"
LOGFILE="/scan_wrapper.log"

echo "Starting scanning with the following options " | tee -a $LOGFILE
echo "Device:  " $DEVICE | tee -a $LOGFILE
echo "Location: " $OUTPUT | tee -a $LOGFILE

function scan {
   echo $1 " scan type selected" | tee -a $LOGFILE

   case $1 in

		"image") $SCRIPT -x $DEVICE -o $OUTPUT;;
		"ocr") $SCRIPT -x $DEVICE -o $OUTPUT --ocr;;
		"email") $SCRIPT -x $DEVICE -o $OUTPUT;;
		"file") $SCRIPT -x $DEVICE -o $OUTPUT;;
		*) echo "Unknown input " $1 " in scan function!! ";;
	esac
}

# Ensure input is provided
if [ -z "$1" ]; then
   echo "Error: Missing input arguments!" | tee -a $LOGFILE
   exit 1
fi

### Check for input value
if [ -z "$1" ]
	then
		echo "missing input arguments!"
	exit
fi

# Ensure the output directory exists (only creates if missing)
[ ! -d "$(dirname "$OUTPUT")" ] && mkdir -p "$(dirname "$OUTPUT")"


## Call the scan script
scan $1

# Ensure the file was created
if [ ! -f "$OUTPUT" ]; then
   echo "Error: Scan failed, file not found!" | tee -a $LOGFILE
   exit 1
fi

echo "Scan completed successfully. File saved to $OUTPUT" | tee -a $LOGFILE
exit 0
