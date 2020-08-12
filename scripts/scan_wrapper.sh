#/bin/bash


SCRIPT="bash /sane-scan-pdf/scan"
OUTPUTDIR="/scans"
DEVICE="brother4:net1\;dev0"
OUTPUT=$OUTPUTDIR/scan_"`date +%Y-%m-%d-%H-%M`"".pdf"

echo "Starting scanning with the following options "
echo "Device:  " $DEVICE
echo "Location: " $OUTPUT

function scan {
   echo $1 " scan type selected"

   case $1 in

		"image") $SCRIPT -x $DEVICE -o $OUTPUT;;
		"ocr") $SCRIPT -x $DEVICE -o $OUTPUT --ocr;;
		"email") $SCRIPT -x $DEVICE -o $OUTPUT;;
		"file") $SCRIPT -x $DEVICE -o $OUTPUT;;
		*) echo "Unknown input " $1 " in scan function!! ";;
	esac
}

function nc_upload {
   echo "someday upload to NC"
}

### Check for input value
if [ -z "$1" ]
	then
		echo "missing input arguments!"
	exit
fi

scan $1
