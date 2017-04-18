#!/bin/bash

# df_monitor

RUNDIR="$HOME/.config/df_monitor"
FILE_ROOT="$RUNDIR/root.dat"
FILE_HOME="$RUNDIR/home.dat"
RUTA=$1

function create_fs_file {
	mkdir -p $RUNDIR
	if [[ ! -f $FILE_ROOT ]]; then
		echo -e "year\tmonth\tday\thour\tmin\tdateNum\tUsage(%)" > $FILE_ROOT
		echo    "*********************" >> $FILE_ROOT
	fi
	if [[ ! -f $FILE_HOME ]]; then
		echo -e "year\tmonth\tday\thour\tmin\tdateNum\tUsage(%)" > $FILE_HOME
		echo    "*********************" >> $FILE_HOME
	fi

}

data_ruta=$(df $RUTA | grep "/dev")

total=$(echo $data_ruta | cut -d" " -f2)
used=$(echo $data_ruta | cut -d" " -f3)

percent_used=$(expr "$used / $total*100" | bc -l)

year=$(date +%Y)
month=$(date +%m)
day=$(date +%d)
hour=$(date +%H)
minute=$(date +%M)
date_num=$(expr "$year + $month/12 + $day/12/30 + $hour/12/30/24" | bc -l)

create_fs_file

if [ $RUTA == '/' ]
then
	printf "%i\t%i\t%i\t%i\t%i\t%4.4f\t%2.4f\n" $year $month $day $hour $minute $date_num $percent_used >> $FILE_ROOT
elif [[ $RUTA == '/home' || $RUTA == '/home/' ]]
then
		printf "%i\t%i\t%i\t%i\t%i\t%4.4f\t%2.4f\n" $year $month $day $hour $minute $date_num $percent_used >> $FILE_HOME
else
	echo "ERROR: Please specify a path"
fi
