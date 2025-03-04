docker image prune -a -f

VERSION="$(cat VERSION)"

docker build -t local/scan --build-arg VERSION=$VERSION .

docker run --rm -d -e VERSION=$VERSION -e MODEL=MFC-L2700DW -e IPADDRESS=192.168.1.20 -v /home/jankar/scans:/scans --name scan-dev local/scan 
