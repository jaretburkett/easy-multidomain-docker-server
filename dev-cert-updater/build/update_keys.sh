#!/bin/bash
while :
do
	for filename in /main/keys/*.private; do
#        scp -i "/main/keys/$filename"
        y=${filename%.private}
        basefilename=${y##*/}
        echo "Updating certs for ${basefilename}"
        certsbasepath="`cat /main/keys/${basefilename}.certpath`"
        scp -i ${filename} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${certsbasepath}/${basefilename}.crt /main/certs/${basefilename}.crt
        scp -i ${filename} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${certsbasepath}/${basefilename}.key /main/certs/${basefilename}.key
    done
	sleep 10m
done