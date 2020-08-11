docker run -it -v -name scan /home/$USER/scans:/scans -e "NAME=Scanner" -e "MODEL=MFC-L2700DW" -e "IPADDRESS=192.168.1.207" --net=host jankar/brscan-skey:latest

docker run -d -v -name scan /home/$USER/scans:/scans -e "NAME=Scanner" -e "MODEL=MFC-L2700DW" -e "IPADDRESS=192.168.1.207" --net=host jankar/brscan-skey:latest