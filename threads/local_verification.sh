echo "Calculate the number of non blocking threads and cpus"

nonblockingpid=$(jcmd | awk '$3=="org.infinispan.server.Bootstrap" {print $1}')
nthreads=$(jcmd $nonblockingpid Thread.print | grep "non-blocking-thread" | wc -l)
echo "number of non blocking threads == " $nthreads

mythreads=$(jcmd $nonblockingpid Thread.print | grep "mythreads" | wc -l)
echo "number of < my threads> == " $mythreads

bthreads=$(jcmd $nonblockingpid Thread.print | grep '"blocking-thread.' | wc -l)
echo "number of blocking threads == " $bthreads

jgroupsthreads=$(jcmd $nonblockingpid Thread.print | grep '"jgroups.' | wc -l)
echo "number of jgroups threads == " $jgroupsthreads

ncpus=$(lscpu | grep "CPU(s)" | awk 'NR==1 {print $2}')
echo "number of cpus: == " $ncpus 