Testing on crash and on OOME inside pod:


Flag | Effect
--------- | ---------
OnError | execute during error
ErrorFileToStdout 	| Send the output to pod logs - oc logs --> https://access.redhat.com/solutions/5224201
ErrorFile 	| Sent path for crash file (hs_error) --> https://access.redhat.com/solutions/3645742
HeapDumpPath 	| Given HeapDumpOnOutOfMemoryError as JVM, you can set where the heap will be written to
CrashOnOutOfMemoryError 	Crashes instead of OOME
ExitOnOutOfMemoryError  	Exit on out of memory exception
