#!/bin/bash

cat ipaws.xml | grep -oP '(?<=<info>).*?(?=</info>)' > relay.xml

if [ -s relay.xml ]
then
	echo "Alert Is Valid"
else
	echo "Invalid Alert"
	exit 1
fi

echo -n "ZCZC-" > same.txt
cat relay.xml | grep -oP '(?<=<valueName>EAS-ORG</valueName><value>).*?(?=</value>)' | head -n 1 | xargs echo -n >> same.txt
echo -n "-" >> same.txt
cat relay.xml | grep -oP '(?<=<eventCode><valueName>SAME</valueName><value>).*?(?=</value>)' | head -n 1 | xargs echo -n >> same.txt
echo -n "-" >> same.txt
cat relay.xml | grep -oP '(?<=<geocode><valueName>SAME</valueName><value>).*?(?=</value>)' | xargs echo -n >> same.txt
echo -n "+" >> same.txt
echo -n "0015" >> same.txt
echo -n "-" >> same.txt
date +%j | xargs echo -n >> same.txt
cat relay.xml | grep -oP '(?<=<effective>).*?(?=</effective>)' | grep -oP '(?<=T).*?(?=-)' | grep -Po '.*(?=...$)' | xargs echo -n >> same.txt
echo -n "-" >> same.txt
echo -n "KALT/WXR" >> same.txt # Station Callsign
echo -n "-" >> same.txt
sed --in-place 's/://g' same.txt
sed --in-place 's/ /-/g' same.txt
cat same.txt

echo "Generating Header"
cat same.txt | minimodem --tx same -f same.wav
echo "Generating Footer"
echo NNNN | minimodem --tx same -f eom.wav
echo "Generating ATTN Tone"
ffmpeg -f lavfi -i "sine=frequency=1050:duration=7" attn.wav -y
echo "Requesting external audio"
cat relay.xml | grep -oP '(?<=<resource>).*?(?=</resource>)' | grep -oP '(?<=<uri>).*?(?=</uri>)' > audio.txt

if [ -s audio.txt ]
then
	echo "Successful, using external audio."
	cat audio.txt | xargs wget -O ipaws.mp3
	ffmpeg -i ipaws.mp3 -acodec pcm_u8 -ar 22050 ipaws.wav -y
else
	echo "Unsuccessful, using internal audio."
	echo "Generating WAVE"
	cat relay.txt | grep -oP '(?<=<description>).*?(?=</description>)' | flite -voice kal16 --ssml -f - -o ipaws.wav

fi

echo "Outputting In:"
echo "3"
sleep 1
echo "2"
sleep 1
echo "1"
sleep 1
echo "TX Enabled"
screen -X -S "INSERT YOUR STATION AUTOMATION SCRIPT HERE" quit
echo "Passthrough Enabled"
aplay "same.wav"
sleep 1
aplay "same.wav"
sleep 1
aplay "same.wav"
sleep 3
aplay "attn.wav"
sleep 3
aplay "ipaws.wav"
sleep 3
aplay "eom.wav"
sleep 1
aplay "eom.wav"
sleep 1
aplay "eom.wav"
echo "Alert Relayed."
echo "Standby..."
screen -dmS "INSERT YOUR STATION AUTOMATION SCRIPT HERE" watch -n 1 sh "INSERT YOUR STATION AUTOMATION SCRIPT HERE"
exit 0
