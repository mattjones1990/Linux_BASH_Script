#!/bin/bash

echo "Type the name of your desired log file (e.g LogFile.log) and press [ENTER]:"
read filename
write_to_log=$filename;
blank=""

if [ "$filename" == "$blank" ] #check filename isn't blank
    then
        echo "File cannot be blank!"
        echo "Script will terminate in 5 seconds..."
        sleep 5
        exit;
    fi

if [[ "$filename" != *"."* ]] #check filename contains full-stop
    then
        echo "File must contain a full stop!"
        echo "Script will terminate in 5 seconds..."
        sleep 5
        exit;
    fi

###Create file if it doesnt exist.
if [ -f ./$write_to_log ];
        then
        echo " "
            echo "The File already exists!"
        echo "No new files created.."
        sleep 1
        echo " "
        else
            touch $write_to_log;
            echo "The File \"$write_to_log\" has been created!"
        sleep 1
        echo "Changing permissions for file..."
            chmod 775 $write_to_log
        sleep 1
        echo "Permissions changed."
        sleep 1
    fi

echo "Please input in seconds how often you want the system to be checked for changes (e.g 2), and press [ENTER]:"
read sleep_input
sleeptime=$sleep_input

sleep 1
echo "System is now being monitored every $sleeptime second(s) depending on system performance.."
echo " "

home_directory()
    	{	
    		date_right_now=$(date +%D);
    		time_right_now=$(date +%T);
    		home_directory=$HOME
    		bytes_used=$(df -m $home_directory | sed 1d | awk '{print $3}')
    		bytes_available=$(df -m $home_directory | sed 1d | awk '{print $4}')
    		used_percentage=$(df -m $home_directory | sed 1d | awk '{print $5}')
    		title="Home Directory Disk Usage (Located in ~$HOME)"

    		bytes_used_gb=$(($bytes_used /1000))
    		bytes_used_remainder=$(($bytes_used % 1000))
    		bytes_available_gb=$(($bytes_available /1000))
    		bytes_available_remainder=$(($bytes_available % 1000))
    
    		printf "Date: %s | %s\nTime: %s |\n\t\t Current Usage\n\t\t -------------------------------------------------------------------\n\t\t Megabytes Used: \t%sMB \t\t(%s.%sGB)\n\t\t Megabytes Available: \t%sMB \t(%s.%sGB)\n\t\t Disk Usage: \t\t%s\n" "$date_right_now" "$title" "$time_right_now" "$bytes_used" "$bytes_used_gb" "$bytes_used_remainder" "$bytes_available" "$bytes_available_gb" "$bytes_available_remainder" "$used_percentage"       
    	}

home_directory_bytes()
    	{
   		home_directory=$HOME
     		bytes_used=$(df -m $home_directory | sed 1d | awk '{print $3}')
     		printf "$bytes_used"
    	}

interface_use()
    	{
    		interfaces_in_use=$(ifconfig -s |grep -c -v Iface)
    		printf "$interfaces_in_use"
    	}

interface_total()
    	{
    		date_right_now=$(date +%D);
       		time_right_now=$(date +%T);
    
    		title="Interfaces In Use"
    		total=$(interface_use)

    		printf "Date: %s | %s\nTime: %s |\n\t\t Current Interfaces\n\t\t -------------------------------------------------------------------\n\t\t Total number of interfaces in use: \t%s" "$date_right_now" "$title" "$time_right_now" "$total"    
    	}

overall_disk()
    	{
    		date_right_now=$(date +%D);
    		time_right_now=$(date +%T);
    		title="Total Disk Usage and Availability"
    		overall_used=$(df -lP -BM | awk '{total+=$3} END {printf "%d", total}')
    		overall_free=$(df -lP -BM | awk '{total+=$4} END {printf "%d", total}')
        
    		overall_used_gb=$(($overall_used /1000))
    		overall_used_gb_remainder=$(($overall_used % 1000))
    		overall_free_gb=$(($overall_free /1000))
    		overall_free_gb_remainder=$(($overall_free % 1000))
    		printf "Date: %s | %s\nTime: %s |\n\t\t Current Usage\n\t\t -------------------------------------------------------------------\n\t\t Megabytes Used: \t%sMB \t(%s.%sGB)\n\t\t Megabytes Available: \t%sMB \t(%s.%sGB)\n" "$date_right_now" "$title" "$time_right_now" "$overall_used" "$overall_used_gb" "$overall_used_gb_remainder" "$overall_free" "$overall_free_gb" "$overall_free_gb_remainder"
    	}

overall_disk_mb()
    	{
    		overall_used=$(df -lP -BM | awk '{total+=$3} END {printf "%d", total}')
    		printf "$overall_used"
   	}

temp_file_use()
    	{
    		date_right_now=$(date +%D);
    		time_right_now=$(date +%T);
    		title="Total Temporary File (tmpfs) Disk Usage"
        	temp_file_use=$(df -BM --output=source,used -t tmpfs | awk '{total+=$2} END {printf "%d", total}')
    		printf "Date: %s | %s\nTime: %s |\n\t\t Current Usage\n\t\t -------------------------------------------------------------------\n\t\t Megabytes Used: \t%sMB" "$date_right_now" "$title" "$time_right_now" "$temp_file_use"
    	}

process_use()
    	{
    		processes=$(ps -e | grep -c -v 00:00:00)
    		printf "$processes"
    	}

process_total()
    	{
        	date_right_now=$(date +%D);
        	time_right_now=$(date +%T);
    
        	title="Processes Currently Running for More Than Zero Seconds"
        	total=$(process_use)

    		printf "Date: %s | %s\nTime: %s |\n\t\t Processes currently running\n\t\t -------------------------------------------------------------------\n\t\t Total number of processes running: \t%s\n\n" "$date_right_now" "$title" "$time_right_now" "$total"
    	}

process_details()
    	{
    		ps -e | sed 1d | grep -v 00:00:00 | awk '
        	BEGIN {
        	  	printf "\t\t %s\t%s\t\t%s\t\n", "PID", "Time", "Command"
        	}
        	{
        	  	printf "\t\t %s\t%s\t%s\t", $1, $3, $4
        	  	printf "\n"
       		}'
    	}

temp_file_use_mb()
    	{
    		temp_file_use=$(df -BM --output=source,used -t tmpfs | awk '{total+=$2} END {printf "%d", total}')
    		printf "$temp_file_use"    
    	}

user_details() 
	{
  		w -h | awk '
    		BEGIN {
      			printf "\t\t %s\t\t%s\t%s\n", "User", "TTY", "Login Time"
    		}
    		{
      			printf "\t\t %s\t%s\t%s\t", $1, $2, $4
      			printf "\n"
    		}'
	}

user_use()
    	{
    		users_logged=$(w -h |grep -c -v USER)
    		printf "$users_logged"
    	}

user_total()
    	{
    		date_right_now=$(date +%D);
    		time_right_now=$(date +%T);
    
    		title="Users Logged on"
    		total=$(user_use)

    		printf "Date: %s | %s\nTime: %s |\n\t\t Current Users Logged on\n\t\t -------------------------------------------------------------------\n\t\t Total number of users/sessions: \t%s" "$date_right_now" "$title" "$time_right_now" "$total"    
    	}

usb_details() 
	{
  		lsusb | grep -v Foundation | awk '
    		BEGIN {
      			printf "\t\t %s\t%s\t%s\t\t%s\n", "Bus", "Device", "ID", "Device Name"
    		}
    		{
      			printf "\t\t %s\t%s\t%s\t", $2, $4, $6
      			for(i=7; i<=NF; i++) printf "%s ", $i
      			printf "\n"
    		}'
	}


usb_use()
    	{
    		usb_devices_connected=$(lsusb |grep -c -v Foundation)
    		printf "$usb_devices_connected"
    	}

usb_total()
        {
        	date_right_now=$(date +%D);
    		time_right_now=$(date +%T);
    
        	title="USB Devices Attached"
        	total=$(usb_use)

        	printf "Date: %s | %s\nTime: %s |\n\t\t Current USB Usage\n\t\t -------------------------------------------------------------------\n\t\t Total number of USB devices attached: \t%s" "$date_right_now" "$title" "$time_right_now" "$total"    
        }

#Main



date_right_now=$(date +%D);
time_right_now=$(date +%T);
printf "Date: %s | Time: %s | SYSTEM SNAPSHOT STARTED\n" "$date_right_now" "$time_right_now"
printf "Date: %s | Time: %s |\t SYSTEM SNAPSHOT STARTED\n" "$date_right_now" "$time_right_now" >> $write_to_log
echo " " >> $write_to_log

#get initial process information
process_use_one=$(process_use)
process_details_one=$(process_details)
process_total_one=$(process_total)

#print initial process information
echo "$process_total_one" >> $write_to_log
echo " " >> $write_to_log
echo "$process_details_one" >> $write_to_log
echo " " >> $write_to_log

#get initial home directory information
home_dir_one=$(home_directory);
home_dir_bytes_one=$(home_directory_bytes);

#print initial home directory information
echo "$home_dir_one" >> $write_to_log
echo " " >> $write_to_log

#get initial overall disk information
overall_one=$(overall_disk);
overall_one_mb=$(overall_disk_mb);

#print initial overall disk information
echo "$overall_one" >> $write_to_log
echo " " >> $write_to_log

#get initial temp file information
temp_one=$(temp_file_use);
temp_one_mb=$(temp_file_use_mb);

#print initial temp file information
echo "$temp_one" >> $write_to_log
echo " " >> $write_to_log

#get initial usb information
usb_use_one=$(usb_use)
usb_total_one=$(usb_total)
usb_details_one=$(usb_details)

#print initial usb information
echo "$usb_total_one" >> $write_to_log
echo " " >> $write_to_log
echo "$usb_details_one" >> $write_to_log
echo " " >> $write_to_log

#get initial interface information
interface_use_one=$(interface_use)
interface_total_one=$(interface_total)

#print intial interface information
echo "$interface_total_one" >> $write_to_log
echo " " >> $write_to_log
ifconfig >> $write_to_log

#get initial user information
user_one=$(user_use)
user_total_one=$(user_total)
user_details_one=$(user_details)

#print initial user information
echo "$user_total_one" >> $write_to_log
echo " " >> $write_to_log
echo "$user_details_one" >> $write_to_log
echo " " >> $write_to_log

printf "Date: %s | Time: %s |\t SYSTEM SNAPSHOT ENDED\n" "$date_right_now" "$time_right_now" >> $write_to_log
echo " " >> $write_to_log
echo "LOGGED CHANGES" >> $write_to_log
echo " " >> $write_to_log

while true
do     
	changes=0
	
	#processes
	process_use_two=$(process_use)
	process_details_two=$(process_details)
	process_total_two=$(process_total)
	
	if [ "$process_use_one" != "$process_use_two" ]
            	then
		echo "$process_total_two" >> $write_to_log
            	printf "\n\t\t The Number of running processes has changed from %s to %s" "$process_use_one"  "$process_use_two" >> $write_to_log
            	printf "\n\t\t Process Details:\n\n" >> $write_to_log
		echo "$process_details_two" >> $write_to_log
            	echo " " >> $write_to_log
            	process_use_one=$process_use_two
        	process_details_one=$process_details_two
        	changes=$((changes + 1))
        fi

    	#users
        user_two=$(user_use)
        user_total_two=$(user_total)
        user_details_two=$(user_details)
    
        if [ "$user_one" != "$user_two" ]
            	then
            	echo "$user_total_two" >> $write_to_log
            	printf "\n\t\t The Number of users logged on has changed from %s to %s\n" "$user_one"  "$user_two" >> $write_to_log
            	printf "\n\t\t User details:\n\n" >> $write_to_log
            	echo "$user_details_two" >> $write_to_log
            	echo " " >> $write_to_log
            	user_one=$user_two
        	user_details_one=$user_details_two
        	changes=$((changes + 1))
    
    	elif [ "$user_details_one" != "$user_details_two" ]
       		then
        	printf "\n\t\t The Number of users logged on hasn't changed, but some details have! (See below)\n" >> $write_to_log
     	   	echo "$user_details_two" >> $write_to_log
		echo " " >> $write_to_log
        	user_details_one=$user_details_two
        	changes=$((changes + 1))
        fi

        #interface
        interface_use_two=$(interface_use)
        interface_total_two=$(interface_total)
    
        if [ "$interface_use_one" != "$interface_use_two" ]
            	then
            	echo "$interface_total_two" >> $write_to_log
            	printf "\n\t\t The Number of interfaces in use has changed from %s to %s\n" "$interface_use_one"  "$interface_use_two" >> $write_to_log
            	printf "\n\t\t Interface details:\n\n" >> $write_to_log
            	ifconfig >> $write_to_log
            	interface_use_one=$interface_use_two
        	interface_total_one=$interface_total_two
        	changes=$((changes + 1))
        fi

        #home_directory
        home_dir_bytes_two=$(home_directory_bytes) #grab MB used at this moment
        home_dir_two=$(home_directory) #grab recent home directory stats
        
        if [ "$home_dir_bytes_one" != "$home_dir_bytes_two" ]
            	then
            	echo "$home_dir_two" >> $write_to_log #print the output to the file as MB has changed.
            	printf "\n\t\t The Number of Megabytes used has changed from %sMB to %sMB\n" "$home_dir_bytes_one"  "$home_dir_bytes_two" >> $write_to_log
            	echo " " >> $write_to_log
            	home_dir_one=$home_dir_two
            	home_dir_bytes_one=$home_dir_bytes_two
        	changes=$((changes + 1))
        fi

        #overall_disk
        overall_two=$(overall_disk) #grab current disk usage stats
        overall_two_mb=$(overall_disk_mb) #grab current usage for comparison
    
        if [ "$overall_one_mb" != "$overall_two_mb" ]
            	then
            	echo "$overall_two" >> $write_to_log #print the output of the disk usage to file.
            	printf "\n\t\t The Number of Megabytes used has changed from %sMB to %sMB\n\n" "$overall_one_mb"  "$overall_two_mb" >> $write_to_log
            	overall_one=$overall_two;
            	overall_one_mb=$overall_two_mb;
        	changes=$((changes + 1))
        fi

        #temp_file_use
        temp_two=$(temp_file_use)
        temp_two_mb=$(temp_file_use_mb)

        if [ "$temp_one_mb" != "$temp_two_mb" ]
            	then
            	echo "$temp_two" >> $write_to_log #print the output of the disk usage to file.
            	printf "\n\t\t The Number of Megabytes used has changed from %sMB to %sMB\n" "$temp_one_mb"  "$temp_two_mb" >> $write_to_log
            	echo " " >> $write_to_log
            	temp_one=$temp_two;
            	temp_one_mb=$temp_two_mb;
        	changes=$((changes + 1))
        fi

        #usb_use
        usb_use_two=$(usb_use)
        usb_total_two=$(usb_total)
        usb_details_two=$(usb_details)
    
        if [ "$usb_use_one" != "$usb_use_two" ]
            	then
            	printf "$usb_total_two (was previously $usb_use_one) \n\n" >> $write_to_log
            	printf "$usb_details_two \n\n" >> $write_to_log
            	echo "" | mail -s "USB ALERT!" mattjones1990@hotmail.co.uk <<< "A USB device has been plugged into your machine!"
            	usb_use_one=$usb_use_two
            	usb_details_one=$usb_details_two
        	changes=$((changes + 1))

    	elif [ "$usb_details_one" != "$usb_details_two" ]
        	then
        	printf "Date: %s |\nTime: %s | The Number of USB devices hasn't changed, but some details have! (See below)\n" "$date_right_now_log" "$time_right_now_log" >> $write_to_log
		echo " " >> $write_to_log
        	echo "$usb_details_two" >> $write_to_log
		echo " " >> $write_to_log
        	usb_details_one=$usb_details_two
        	changes=$((changes + 1)) #add 1 to changes, to update the terminal message.
        fi
        
    	date_right_now_log=$(date +%D);
    	time_right_now_log=$(date +%T);
    
    	if [ "$changes" != "0" ]
        	then
        	printf "Date: %s | Time: %s | Checked for changes: %s changes logged\n" "$date_right_now_log" "$time_right_now_log" "$changes"
    	else
        	printf "Date: %s | Time: %s | Checked for changes: None logged.\n" "$date_right_now_log" "$time_right_now_log"
    	fi

    	sleep $sleeptime
done



