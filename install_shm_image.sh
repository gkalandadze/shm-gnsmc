#!/bin/bash

# konteineris saxeli romelsac shevqmnit
container_name='shm-container'

# crontabshi chasamatebeli brdzaneba
crontab_command="@reboot docker start $container_name"

# shm is chasartavi brdzanebis alias, bashrc shi chasamateblad
docker_command="alias SHM='docker exec -it $container_name bash -i -c \"SHM\"'"

# funqica sheqmnis axal dockeris volumes, micemuli parametrebit
function create_nfs_volume {
    local volume_name=$1
    local ip_to_connect=$2
    local remote_folder_path=$3
    # wavshalot volume tu ukve arsebobs
    docker volume rm $volume_name &> /dev/null
    # shevqmnat axali volume
    docker volume create \
        --driver local \
        --opt type=nfs \
        --opt o=addr=$ip_to_connect,nfsvers=4,soft,tcp,noatime,timeo=15 \
        --opt device=:$remote_folder_path \
        $volume_name &> /dev/null
    if [ $? -eq 0 ]; then
        echo -e "Volume named $volume_name succesfully created\n"
    else
        echo -e "There was a problem creating volume: $volume_name\n"
    fi
}

# gadmoviwerot dockerisatvis sachiro secprofile rata chromma imushaos
if [ ! -f ~/docker_chrome.json ]; then
    wget https://raw.githubusercontent.com/gkalandadze/shm-gnsmc/master/chrome.json -O ~/docker_chrome.json
fi

# gadmoviwerot shm is image docker hub idan (hub.docker.com)
docker pull gkalandadze/shm-gnsmc:latest

if [ $? -eq 0 ]; then
    echo "--------------------------------------------------------"
    echo "SHM image was downloaded succesfully from hub.docker.com"
    echo "--------------------------------------------------------"
else
    echo "--------------------------"
    echo "SHM image download failed"
    echo "--------------------------"
    exit 1
fi


# shevamowmot 250 tan tu gvaqvs kavshiri
if ! ping -q -c 1 -W 1 10.0.0.250 &> /dev/null; then
    echo -e "\033[0;31m \nCan't connect to server(10.0.0.250)\n"
    exit 1
fi


# tu dockeris containeri sheqmnilia mashin wavshalot
docker stop $container_name &> /dev/null && docker rm $container_name &> /dev/null


create_nfs_volume data-250 10.0.0.250 /DATA
create_nfs_volume storage_01-250 10.0.0.250 /STORAGE/STORAGE_01
create_nfs_volume storage_02-250 10.0.0.250 /STORAGE/STORAGE_02


# shevqmnat containeri da gavushvat backgroundshi
# zog sistemaze am brdzanebis gashveba sheidzleba iyos sachiro rata gui gamochndes: xhost +local:$(id -un)
docker run -it -d --name $container_name -v data-250:/DATA \
    -v storage_01-250:/STORAGE/STORAGE_01 \
    -v storage_02-250:/STORAGE/STORAGE_02 \
    --net host \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e DISPLAY \
    -v $HOME/Downloads:/home/sysop/Downloads \
    --security-opt seccomp=$HOME/docker_chrome.json \
    --ipc=host \
    --device /dev/snd \
    --device /dev/dri \
    -v /dev/shm:/dev/shm \
    gkalandadze/shm-gnsmc:latest bash --noprofile --norc


# crontabshi chavamatot rom yovel chartvaze avtomaturad gaeshvas chveni sheqmnili containeri
echo "Do you want to add crontab command? container will start on boot"
read -p "(Y/n)" answer
if [ "$answer" != "${answer#[Yy]}" ]; then
    crontab -l > mycron
    if ! grep -Fxq "$crontab_command" mycron ; then
        echo "$crontab_command" >> mycron
        crontab mycron
        rm mycron
    fi
fi


# chavamatot shm is alias .bashrc shi
if ! grep -Fxq "$docker_command" $HOME/.bashrc ; then
    echo -e "$docker_command" >> $HOME/.bashrc
    source $HOME/.bashrc
fi
