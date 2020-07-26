#!/bin/bash

# konteineris saxeli romelsac shevqmnit
container_name='shm-container'

# crontabshi chasamatebeli brdzaneba
crontab_command="@reboot docker start $container_name"

# shm is chasartavi brdzanebis alias, bashrc shi chasamateblad
docker_command="alias SHM='docker exec -it $container_name bash -i -c \"SHM\"'"

# gadmoviwerot dockerisatvis sachiro secprofile rata chromma imushaos
if [ ! -f ~/docker_chrome.json ]; then
    wget https://raw.githubusercontent.com/gkalandadze/shm-gnsmc/master/chrome.json -O ~/docker_chrome.json
fi

# gadmoviwerot shm is image docker hub idan (hub.docker.com)
docker pull gkalandadze/shm-gnsmc:latest

if [ $? -eq 0 ]; then
    echo "-------------------------------"
    echo "warmatebit gadmoiwera shm image"
    echo "-------------------------------"
else
    echo "--------------------------"
    echo "ver gadmowera shm is image"
    echo "--------------------------"
    exit
fi


# shevamowmot 250 tan tu gaqvt kavshiri
if ping -q -c 1 -W 1 10.0.0.250 >/dev/null; then
    echo "---------------------------------"
    echo "servertan kavshiri shesadzlebelia"
    echo "---------------------------------"
else
    echo "-------------------------------------------------------------------"
    echo "servertan kavshiri sheudzlebelia, sheamowme 10.0.0.250 tan kavshiri"
    echo "-------------------------------------------------------------------"
    exit
fi


# shevqmnat volume romelic DATA direqtorias daimauntebs
docker volume create \
   --driver local \
   --opt type=nfs \
   --opt o=addr=10.0.0.250,nfsvers=4 \
   --opt device=:/DATA \
   data-250


# shevqmnat volume romelic STORAGE_01 direqtorias daimauntebs
docker volume create \
   --driver local \
   --opt type=nfs \
   --opt o=addr=10.0.0.250,nfsvers=4 \
   --opt device=:/STORAGE/STORAGE_01 \
   storage_01-250


# shevqmnat volume romelic STORAGE_02 direqtorias daimauntebs
docker volume create \
   --driver local \
   --opt type=nfs \
   --opt o=addr=10.0.0.250,nfsvers=4 \
   --opt device=:/STORAGE/STORAGE_02 \
   storage_02-250


# tu dockeris containeri ar aris sheqmnili mashin shevqmnat da gavushvat backgroundshi
# zog sistemaze am brdzanebis gashveba sheidzleba iyos sachiro rata gui gamochndes: xhost +local:$(id -un)
[[ $(docker ps -af "name=$container_name" --format '{{.Names}}') == $container_name ]] ||
docker run -it -d --name $container_name -v data-250:/DATA \
    -v storage_01-250:/STORAGE/STORAGE_01 \
    -v storage_02-250:/STORAGE/STORAGE_02 \
    --net host \
    --cpuset-cpus 0 \
    --memory 512mb \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY \
    -v $HOME/Downloads:/home/sysop/Downloads \
    --security-opt seccomp=$HOME/docker_chrome.json \
    --device /dev/snd \
    --device /dev/dri \
    -v /dev/shm:/dev/shm \
    gkalandadze/shm-gnsmc:latest bash --noprofile --norc


# crontabshi chavamatot rom yovel chartvaze avtomaturad gaeshvas chveni sheqmnili containeri
# crontab -l > mycron
# if ! grep -Fxq "$crontab_command" mycron ; then
#     echo "$crontab_command" >> mycron
#     crontab mycron
#     rm mycron
# fi


# chavamatot shm is alias .bashrc shi
if ! grep -Fxq "$docker_command" $HOME/.bashrc ; then
    echo -e "$docker_command" >> $HOME/.bashrc
    source $HOME/.bashrc
fi
