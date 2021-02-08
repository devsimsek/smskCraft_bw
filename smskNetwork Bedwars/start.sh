#!/bin/bash
clear
echo '              __                            __'
echo '   ____ ___  / /_____  _________ ___  _____/ /__'
echo '  / __ \`__ \/ __/ __ \/ ___/ __ \`__ \/ ___/ //_/'
echo ' / / / / / / /_/ / / (__  ) / / / / (__  ) ,<'   
echo '/_/ /_/ /_/\__/_/ /_/____/_/ /_/ /_/____/_/|_|'
echo "Welcome To the smskmc 0.0.1 minecraft 1.8 server instance launcher. Press Enter To Start"
echo "Starting Automaticly"
echo "Minecraft server starting, please wait" > ./ip.txt
# start tunnel
mkdir -p ./logs
touch ./logs/temp # avoid "no such file or directory"
rm ./logs/*
echo "Starting ngrok tunnel in region $ngrok_region"
touch logs/ngrok.log
./ngrok tcp -region eu --log=stdout 25565 > ./logs/ngrok.log &
# wait for started tunnel message, and print each line of file as it is written
tail -f ./logs/ngrok.log | sed '/started tunnel/ q'
orig_server_ip=`curl --silent http://127.0.0.1:4040/api/tunnels | jq '.tunnels[0].public_url'`
trimmed_server_ip=`echo $orig_server_ip | grep -o '[a-zA-Z0-9.]*\.ngrok.io[0-9:]*'`
server_ip="${trimmed_server_ip:-$orig_server_ip}"
echo "Server IP is: $server_ip"
echo "Server running on: $server_ip" > ./ip.txt
touch logs/latest.log
echo "Running server..."
java -Dfile.encoding=UTF-8 -Xmx1G -jar spigot-1.8.8.jar
echo "Exit code $?"