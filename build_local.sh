#docker image prune -a -f

VERSION="$(cat VERSION)"

docker build -t local/scan .

docker run --rm -d -e MODEL=MFC-L2700DW -e IPADDRESS=192.168.1.207 --name scan-dev local/scan 
