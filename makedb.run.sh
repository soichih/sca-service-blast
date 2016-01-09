#!/bin/bash

#rm exit.code

echo "submitting makedb.pbs"
jobid=`qsub ~/.sca/services/blast_makedb/makedb.pbs`
#echo "joid: $jobid"
echo $jobid > running

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

