#!/bin/bash

#rm exit.code

echo "submitting makedb.pbs"
jobid=`qsub ~/.sca/services/blast_makedb/makedb.pbs`
#echo "joid: $jobid"
echo $jobid > running

curl -X POST -H "Content-Type: application/json" -d "{\"status\": \"waiting\", \"progress\": 0, \"msg\":\"Waiting on pbs queue\"}" $SCA_PROGRESS_URL

#wait for job to finish
while [ -f running ] ;
do
        qstat $jobid
        sleep 5
done

#echo "running.job.id is gone.. job must have finished"
code=`cat exit.code`
echo "job finished with code $code"
exit $code

