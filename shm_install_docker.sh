#!/bin/bash


if [ ! -d "$HOME/bin/" ]; then
    mkdir $HOME/bin/
fi


folder="/tmp"


cd /
if [ ! -d "DATA" ] && [ ! -d "STORAGE" ]; then
    sudo mkdir DATA
    sudo mkdir STORAGE
    cd /STORAGE
    sudo mkdir STORAGE_01
    sudo mkdir STORAGE_02
    sudo mkdir STORAGE_03
    sudo mkdir STORAGE_04
    sudo mkdir STORAGE_05
fi


b="export TBR=/DATA/recent/current"
if ! grep -Fxq "$b" $HOME/.bashrc ; then
    sh -c "echo 'source $HOME/bin/sh/setup/shsetup.sh' >> $HOME/.bashrc"
    sh -c "echo 'export TBR=/DATA/recent/current' >> $HOME/.bashrc"
    sh -c "echo 'source $HOME/bin/sh/updateconf.bash' >> $HOME/.bashrc"
    sh -c "echo 'export TBA=/DATA/recent/seed' >> $HOME/.bashrc"
    sh -c "echo 'export Y2020=/STORAGE/STORAGE_02/2020' >> $HOME/.bashrc"
    sh -c "echo 'export Y2019=/STORAGE/STORAGE_01/2019' >> $HOME/.bashrc"
    sh -c "echo 'export Y2018=/STORAGE/STORAGE_01/2018' >> $HOME/.bashrc"
    sh -c "echo 'export Y2017=/STORAGE/STORAGE_01/2017' >> $HOME/.bashrc"
    sh -c "echo 'export Y2016=/STORAGE/STORAGE_01/2016' >> $HOME/.bashrc"
    sh -c "echo 'export Y2015=/STORAGE/STORAGE_01/2015' >> $HOME/.bashrc"
    sh -c "echo 'export Y2014=/STORAGE/STORAGE_01/2014' >> $HOME/.bashrc"
    sh -c "echo 'export Y2013=/STORAGE/STORAGE_01/2013' >> $HOME/.bashrc"
    sh -c "echo 'export Y2012=/STORAGE/STORAGE_01/2012' >> $HOME/.bashrc"
    sh -c "echo 'export Y2011=/STORAGE/STORAGE_01/2011' >> $HOME/.bashrc"
    sh -c "echo 'export Y2010=/STORAGE/STORAGE_01/2010' >> $HOME/.bashrc"
    sh -c "echo 'export Y2009=/STORAGE/STORAGE_01/2009' >> $HOME/.bashrc"
    sh -c "echo 'export Y2008=/STORAGE/STORAGE_01/2008' >> $HOME/.bashrc"
    sh -c "echo 'export Y2007=/STORAGE/STORAGE_01/2007' >> $HOME/.bashrc"
    sh -c "echo 'export Y2006=/STORAGE/STORAGE_01/2006' >> $HOME/.bashrc"
    sh -c "echo 'export Y2005=/STORAGE/STORAGE_01/2005' >> $HOME/.bashrc"
    sh -c "echo 'export Y2004=/STORAGE/STORAGE_01/2004' >> $HOME/.bashrc"
    sh -c "echo 'export Y2003=/STORAGE/STORAGE_01/2003' >> $HOME/.bashrc"
fi
sleep 2


cd $folder

tar xzf sh64.tar.gz
mv $folder/sh $HOME/bin
mv $folder/shfiles $HOME
mv updateconf.bash $HOME/bin/sh/
rm $folder/sh64.tar.gz



ln -s $HOME/bin/sh/util/locsat $HOME/lcs


echo "#change" >> $HOME/bin/sh/updateconf.bash


# source $HOME/.bashrc


# sleep 2
