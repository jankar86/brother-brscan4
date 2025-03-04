# brother-brscan4
Creating a container to automate my scanning from my Brother MFC-L2700DW scanner.  This will take a button press from the
scanner and send it to a scanning script. 

### Adding more soon
Code based on repository: https://github.com/rocketraman/sane-scan-pdf.git with some minor changes. 



##### How to run #####
docker run -it --name=scan -v /home/$USER/scans:/scans -e "NAME=Scanner" -e "MODEL=MFC-L2700DW" -e "IPADDRESS=192.168.1.207" --net=host jankar/brscan-skey:latest

docker run -d --name=scan -v /home/$USER/scans:/scans -e "NAME=Scanner" -e "MODEL=MFC-L2700DW" -e "IPADDRESS=192.168.1.207" --net=host jankar/brscan-skey:latest


### Image tagging reference ####
https://betterprogramming.pub/how-to-version-your-docker-images-1d5c577ebf54
https://betterprogramming.pub/how-to-version-your-code-in-2020-60bdd221278b


https://webcache.googleusercontent.com/search?q=cache:https://betterprogramming.pub/how-to-version-your-docker-images-1d5c577ebf54
https://webcache.googleusercontent.com/search?q=cache:https://betterprogramming.pub/how-to-version-your-code-in-2020-60bdd221278b