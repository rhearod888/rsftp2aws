#!/bin/bash

curdate=$(date --date="yesterday" +'%d/%b/%Y')
_now=$(date --date="yesterday" +"%Y_%m_%d")
rsname=rs5ftp

#echo $_now"_"$rsname
echo "Date,Server,Messages" > /usr/local/scripts/rsftp2awss3/$_now"_"$rsname.csv

cat /var/log/pureftpd/pureftpd.log | grep $curdate | awk -F":" -vDate=`date -d'now-1 day' +'%m-%d-%Y'` ' BEGIN{ OFS=","} { print Date,"RS5",$0}' >> /usr/local/scripts/rsftp2awss3/$_now"_"$rsname.csv

sleep 1m

aws s3 cp /home/rrodriguez/rsftp2awss3/$_now"_"$rsname.csv s3://rs-ftp-logs/

if [ $? -eq 0 ]; then
 echo "File successfully uploaded to s3 bucket"
else
    echo "Error in s3 upload"
fi

