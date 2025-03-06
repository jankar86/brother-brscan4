docker image prune -a -f

export VERSION="$(cat VERSION)"
echo $VERSION
docker build -t local/scan --build-arg BUILD_VERSION=$VERSION .

#docker run --rm -d -e VERSION=$VERSION -e MODEL=MFC-L2700DW -e IPADDRESS=192.168.1.20 -v /home/jankar/scans:/scans --name scan-dev local/scan 
#docker run --rm -d -e VERSION=$VERSION -e MODEL=MFC-L2700DW -e IPADDRESS=192.168.1.20 --name scan-dev local/scan 

#docker run --rm -d --name='brscan-skey' --net='host' --privileged=true -e TZ="America/Chicago" -e HOST_OS="Unraid" -e HOST_HOSTNAME="skynet" -e HOST_CONTAINERNAME="brscan-skey" -e 'TZ'='America/Chicago' -e 'MODEL'='MFC-L2700DW' -e 'IPADDRESS'='192.168.1.20' -v /home/jankar/scans:/scans 'local/scan'
docker run --rm -d --name='brscan-skey' --net='host' -e TZ="America/Chicago" -e HOST_OS="Unraid" -e HOST_HOSTNAME="skynet" -e HOST_CONTAINERNAME="brscan-skey" -e 'TZ'='America/Chicago' -e 'MODEL'='MFC-L2700DW' -e 'IPADDRESS'='192.168.1.20' -v /home/jankar/scans:/scans 'local/scan'

#Try to use port mapping to remove "net=host"
#docker run --rm -d --name='brscan-skey' -p 54925:54925/udp -p 33355:33355 -p 54921:54921 -p 161:161/udp -e TZ="America/Chicago" -e HOST_OS="Unraid" -e HOST_HOSTNAME="skynet" -e HOST_CONTAINERNAME="brscan-skey" -e 'TZ'='America/Chicago' -e 'MODEL'='MFC-L2700DW' -e 'IPADDRESS'='192.168.1.20' -v /home/jankar/scans:/scans 'local/scan'


echo Version: $VERSION
