This example here about Streams unique consumption
1. Stream and 
2. Debug symbols, where the -g is necessary - meaning the javac must be compiled with the debugging information to show the data for local variable:

This is Bella Ban asking Dinn about this problem: https://developer.jboss.org/thread/176913 <--- one needs the -g option to debug this

~~~
  5   -g:lines,source,vars   Line number, source file & variables
~~~

Example:
~~~
//test Example Streams:
import java.util.stream.*;
import java.io.*;

import org.infinispan.commons.marshall.MarshallUtil;

class ExampleStream {

	//Main
    public static void main(String[] args) throws IOException, ClassNotFoundException {
        System.out.println("Example Stream"); 
        Stream<Integer> streamExample = Stream.of( new Integer[]{1,2,3,4,5,6,7,8,9} );
        //stream.forEach(p -> System.out.println(p));
		readGenericStream(streamExample);

		//Complete example:
		completeExampleObjInput();
		return;
    }

    //Integer Stream
    private static void readGenericStream(Stream objectTest) throws IOException, ClassNotFoundException {
      String impl = objectTest.toString();
      String msg = "Example";
      System.out.println(impl); 
  }
  // Input Stream 
  //Based on https://www.programiz.com/java-programming/objectinputstream
  	private static void completeExampleObjInput() {

	        int data1 = 5;
	        String data2 = "This is programiz";
	        String s = "Hello UTF!";

	        try {
	            FileOutputStream file = new FileOutputStream("file.txt");
	            ObjectOutputStream output = new ObjectOutputStream(file);

	            output.writeUTF(s);
	           	output.flush();

	            FileInputStream fileStream = new FileInputStream("file.txt");
	            // Creating an object input stream
	            ObjectInputStream objStream = new ObjectInputStream(fileStream); // <---- object input stream

	            readGenericThrowable(objStream);

	            output.close();
	            objStream.close();
	        }
	        catch (Exception e) {
	            e.getStackTrace();
	        }
	    }

	//Function test, ObjectInput is wrapping around InputStream
	private static void readGenericThrowable(ObjectInput in) throws IOException, ClassNotFoundException {
        //Using UTF
        String impl = "UTF data: " + in.readUTF();
        String msg = MarshallUtil.unmarshallString(in);
        System.out.println("after marshalling: " + impl); 
	}
}
~~~
