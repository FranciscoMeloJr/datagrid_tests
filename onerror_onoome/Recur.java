public class Recur {
    public static void main(String[] argv) {
        try {
            recur();
        }
        catch (Error e) {
            System.out.println(e.toString());
        }
        System.out.println("Ended normally");
    }
    static void recur() {
        Object[] o = null;
        try {
            while(true) {
                Object[] newO = new Object[1];
                newO[0] = o;
                o = newO;
            }
        }
        finally {
            recur();
        }
    }
}
