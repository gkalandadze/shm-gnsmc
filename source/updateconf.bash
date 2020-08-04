#!/bin/bash
##  28 JAN 2020 ##
serverfile=/DATA/shares/SHM/updateconf.bash
localfile=$HOME/bin/sh/updateconf.bash
tmp=tmp_$$_file
shm_conf_file=$HOME/bin/sh/inputs/shm-config.txt
filelines=`cat $shm_conf_file`
index=0
if [[ ! `diff $serverfile $localfile` == "" ]]; then
	##gamosacheni gverdebis Shenaxva
	if [ "$1" == '' ]; then
		echo "saving current configuration"
		for line in $filelines
		do
			if [[ $line == *'#v$read_dialog_stations_'?? ]]; then
			oldfile[$index]=$line
			index+=1		
			fi
		done
	fi
	
	##configuraciis failebis da filtrebis ganaxleba
	echo "copying inputs and filters..."
	cp -r /DATA/shares/SHM/inputs/* $HOME/bin/sh/inputs
	cp -r /DATA/shares/SHM/filter/* $HOME/bin/sh/filter

	##gamochenadi gverdebis agdgena
	if [ "$1" == '' ]; then
		echo "Restoring current configuration"
		for i in "${oldfile[@]}"
		do
			ii=${i##*#}
	        ii=${ii%% *}
			sed -n "/^$ii/{s|^|#|};p" "$shm_conf_file" > "$tmp" && mv "$tmp" "$shm_conf_file"  
		done
	fi

	##input_data failebis ganaxleba
	echo "copying input_data files"
	if [ -d $HOME/shfiles ]; then
		cp -r /DATA/shares/SHM/input_data/input_data.csh $HOME/shfiles/private/
		cp -r /DATA/shares/SHM/input_data/plugins.txt    $HOME/shfiles/private/
		cp -r /DATA/shares/SHM/input_data/cauhaz_input_data.html $HOME/shfiles/
		cp -r /DATA/shares/SHM/input_data/input_data.html $HOME/shfiles/
		cp -r /DATA/shares/SHM/input_data/cauhaz_input_data.csh $HOME/shfiles/private/
		cp -r /DATA/shares/SHM/input_data/map_google.csh $HOME/shfiles/private/
	fi
	cp -r $serverfile $localfile
fi
