import sun.misc.Unsafe;
import java.lang.reflect.Field;

public class Crash {
    public static void main(String[] args) {

        Runnable[] arr = new Runnable[1];
        arr[0] = () -> {

            while (true) {
                new Thread(arr[0]).start();
            }
        };

        arr[0].run();
    }
}