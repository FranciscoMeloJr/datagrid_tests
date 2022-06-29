function set_up_ {
	echo "======================  Setting up environment variables ====================== "
	export BYTEMAN_HOME=/home/fdemeloj/Downloads/byteman-download-4.0.18
	export JAVA_HOME=/home/fdemeloj/Downloads/cases/java-11-openjdk-11.0.14.0.9-3.portable.jdk.el.x86_64/
	export CLASSPATH=/home/fdemeloj/Downloads/cases/OCP_TESTS/lib/infinispan-commons-13.0.6.Final-redhat-00001.jar:/home/fdemeloj/Downloads/cases/OCP_TESTS/lib/jboss-logging-3.4.1.Final-redhat-00002.jar:.:
}

function run_print_out_rule_ {
	set_up_
	echo "====================== Run Print out rule ====================== "
	rm ExampleStream.class
	$JAVA_HOME/bin/javac -g ExampleStream.java
	$JAVA_HOME/bin/java -Dorg.jboss.byteman.verbose -javaagent:${BYTEMAN_HOME}/lib/byteman.jar=script:trivial.btm ExampleStream
	#$JAVA_HOME/bin/java -Xlog:exceptions=trace,class+loader+data=trace -javaagent:${BYTEMAN_HOME}/lib/byteman.jar=script:trivial.btm ExampleStream
}

function run_print_out_rule_verbose_ {
	set_up_
	echo "======================  Run Print out rule verbose ====================== "
	rm ExampleStream.class
	rm gc.log
	$JAVA_HOME/bin/javac -g ExampleStream.java
	$JAVA_HOME/bin/java -Xlog:exceptions=trace,class+loader+data=trace -Dorg.jboss.byteman.verbose -javaagent:${BYTEMAN_HOME}/lib/byteman.jar=script:trivial.btm ExampleStream
	#$JAVA_HOME/bin/java -javaagent:${BYTEMAN_HOME}/lib/byteman.jar=script:trivial.btm ExampleStream
}


function run_print_out_rule_no_byteman_ {
	set_up_
	echo "======================  Print standard - no byteman rule ====================== "
	rm ExampleStream.class
	rm gc.log
	$JAVA_HOME/bin/javac -g ExampleStream.java
	$JAVA_HOME/bin/java -Xlog:exceptions+info,verification=debug,class+loader+data=trace ExampleStream
	#$JAVA_HOME/bin/java -javaagent:${BYTEMAN_HOME}/lib/byteman.jar=script:trivial.btm ExampleStream
}



if [[ $# -eq 0 ]] ; then
    echo "R for printing out rule"
    echo "V for printing out rule with verbose"
    exit 0
fi

if  [ "$1" = "R" ] || [ "$1" = "r" ]
	then
	    echo "Starting"
	    run_print_out_rule_
fi

if  [ "$1" = "V" ] || [ "$1" = "v" ]
	then
	    echo "Verbose"
	    run_print_out_rule_verbose_
fi

if  [ "$1" = "B" ] || [ "$1" = "b" ]
	then
	    echo "Verbose"
	    run_print_out_rule_no_byteman_
fi

if  [ "$1" != "V" ] && [ "$1" != "v" ] && [ "$1" != "R" ] && [ "$1" != "r" ]  && [ "$1" != "B" ] && [ "$1" != "b" ]
	then
	    echo "Invalid option - try again with R or r"
fi