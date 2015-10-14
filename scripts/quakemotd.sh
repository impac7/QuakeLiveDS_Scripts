#! /bin/bash
# quakemotd.sh - quake live message of the day server broadcaster. designed to be run in-shell, run './quakemotd.sh & disown %1'. kill with 'killall quakemotd.sh'
# created by Thomas Jones on 10/10/15.
# purger@tomtecsolutions.com

# Defining variables:
export qMOTDcontent=$(<remoteConfig-motd.txt)
export qRconPassword=$(<localConfig-rconPassword.txt)
export qUpdateLowestRconPort=28960
export qUpdateHighestRconPort=28970
export qBaseURL="https://raw.githubusercontent.com/tjone270/QuakeLiveDS_Scripts/master"
export qDelayBetweenMOTDbroadcast="900"  # in seconds

echo "========== QuakeMOTD.sh has started. =========="
echo "========= $(date) ========="

# Broadcast MOTD to every server hosted locally.
counter="$qUpdateLowestRconPort"
while true
do
    sleep $qDelayBetweenMOTDbroadcast
    # Download latest MOTD from GitHub.
    curl -s $qBaseURL/motd.txt > remoteConfig-motd.txt; dos2unix --quiet remoteConfig-motd.txt
    export qMOTDcontent=$(<remoteConfig-motd.txt)
    while [ $counter -le $qUpdateHighestRconPort ]
    do
        #echo "Broadcasting MOTD to port $counter"
        python steamcmd/steamapps/common/qlds/rcon.py --host tcp://127.0.0.1:$counter --password "$qRconPassword" --command "say '^5Message of the Day:^7'" > /dev/null
        counter2=3 # Skip line 1 and 2 to allow me to put instructions in.
        counted2=`echo $qMOTDcontent | wc -l`
        while [ $counter2 -le $counted2 ]
        do
            qBroadcastLine=`echo $qMOTDcontent | sed "${counter2}q;d"` # | grep -v '#'
            python steamcmd/steamapps/common/qlds/rcon.py --host tcp://127.0.0.1:$counter --password "$qRconPassword" --command "say \"^7$qBroadcastLine\"" > /dev/null
            ((counter2++))
        done
        ((counter++))
    done

    # Reset counter.
    export counter="$qUpdateLowestRconPort"
done

exit 0