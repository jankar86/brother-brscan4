#docker image prune -a -f

VERSION="$(cat VERSION)"

docker build -t local/scan .

docker run --rm -d -e VERSION=$VERSION -e MODEL=MFC-L2700DW -e IPADDRESS=192.168.1.20 -e NC_USER="psb" -e NC_PASS="" -e NC_URL="https://nc.jankar.net/remote.php/dav/files/psb/Documents/Scans/" --name scan-dev local/scan 
