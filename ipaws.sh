#!/bin/bash
mv alert.xml alertold.xml
wget "https://kj7bre.com/ipaws/server2server_bridge/ipaws.php?pin=INSERTPINHERE" -O ipaws.xml

cat ipaws.xml | grep -oP '(?<=<info>).*?(?=</info>)' > alert.xml

if [ -s alert.xml ]
then
        echo "Validating New Alert."
        cmp --silent alert.xml alertold.xml || echo "Valid Alert!.. Relaying."
        cmp --silent alert.xml alertold.xml || sh relay.sh
        cmp --silent alert.xml alertold.xml || exit 0
else
        echo "No Current Alerts."
        exit 0
fi

echo "Alert is expired."
exit 0
