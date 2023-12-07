#!/bin/bash

# Ask the user for login details
vhost="/opt/homebrew/etc/httpd/original/extra/httpd-vhosts.conf"
HOSTFILE="/etc/hosts"

cat <<EOF

___      _               _   _    _           _   
\\ \\    / (_)    | |             | | | |  | |         | |  
 \\ \\  / / _ _ __| |_ _   _  __ _| | | |__| | ___  ___| |_ 
  \\ \\/ / | | '__| __| | | |/ _\` | | |  __  |/ _ \\/ __| __|
   \\  /  | | |  | |_| |_| | (_| | | | |  | | (_) \\__ \\ |_ 
    \\/   |_|_|   \\__|\\__,_|\\__,_|_| |_|  |_|\\___/|___/\\__|

EOF

echo "Available Hosts:"


# Asking for details

read -p 'Enter project Location: ' projectLocation
read -p 'Enter Host Name: ' hostName

# Storing virtual host details

multiline_content=$(cat <<EOF

<VirtualHost 0.0.0.0>
    DocumentRoot "$projectLocation"
    ServerName $hostName
    <Directory "$projectLocation">
        AllowOverride All
        Order allow,deny
        Allow from all
        Require all granted
    </Directory>
</VirtualHost>

EOF
)

writingHostAndVhostFile() {
    echo "$multiline_content" >> $vhost

   sudo echo "127.0.0.1 $hostName" >> $HOSTFILE
}

restartingServices() {
    echo "Restarting Apache..."
    sudo apachectl restart

    echo "Restarting httpd..."
    http-restart
}

if grep -q "$hostName" "$vhost"; then
    echo "Host $hostName already exists."
else
    writingHostAndVhostFile
    restartingServices
fi
