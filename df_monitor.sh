#!/bin/bash

# df_monitor

RUNDIR="$HOME/.config/df_monitor"
FILE_ROOT="$RUNDIR/root.dat"

function create_fs_file {
	mkdir -p $RUNDIR
	if [[ ! -f $FILE_ROOT ]]; then
		echo -e "year\tmonth\tday\thour\tmin\tdateNum\tUsage(%)" > $FILE_ROOT
		echo    "*********************" >> $FILE_ROOT
	fi
}

data_root=$(df /|grep "/dev")

total=$(echo $data_root|cut -d" " -f2)
used=$(echo $data_root|cut -d" " -f3)

percent_used=$(expr "$used/$total*100" | bc -l)

year=$(date +%Y)
month=$(date +%m)
day=$(date +%d)
hour=$(date +%H)
minute=$(date +%M)
date_num=$(expr "$year + $month/12 + $day/12/30 + $hour/12/30/24" | bc -l)

create_fs_file

printf "%i\t%i\t%i\t%i\t%i\t%4.4f\t%2.4f\n" $year $month $day $hour $minute $date_num $percent_used >> $FILE_ROOT
