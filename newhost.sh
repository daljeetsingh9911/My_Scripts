#!/bin/bash
# Ask the user for login details
vhost="/opt/homebrew/etc/httpd/original/extra/httpd-vhosts.conf"
HOSTFILE = "/etc/hosts"

cat <<EOF

__      ___      _               _   _    _           _   
\\ \\    / (_)    | |             | | | |  | |         | |  
 \\ \\  / / _ _ __| |_ _   _  __ _| | | |__| | ___  ___| |_ 
  \\ \\/ / | | '__| __| | | |/ _\` | | |  __  |/ _ \\/ __| __|
   \\  /  | | |  | |_| |_| | (_| | | | |  | | (_) \\__ \\ |_ 
    \\/   |_|_|   \\__|\\__,_|\\__,_|_| |_|  |_|\\___/|___/\\__|

EOF


echo "Already avilable Hosts"

cat $HOSTFILE

# Asking for details

read -p 'Enter project Location: ' projectLocation
read -p 'Enter Host Name: ' hostName

# storing  Vhost Detials
multiline_content=$(cat <<EOF
<VirtualHost  0.0.0.0>
    DocumentRoot "$projectLocation"
    ServerName  $hostName
    <Directory "$projectLocation">
        AllowOverride All
        Order allow,deny
        Allow from all
        Require all granted
    </Directory>
</VirtualHost>
EOF
)

writingHostAndVhostFile(){
     echo "$multiline_content" >> $vhost

    echo  "127.0.0.1 $hostName">  $HOSTFILE
}

reStartServices(){
    echo `eval(sudo apachectl restart)`

    echo `eval(http-restart)`
}



if grep -q "$hostName" "$vhost"; then
    echo "Host is already setup with $hostName"
else
    writingHostAndVhostFile
    reStartServices
fi

# 






