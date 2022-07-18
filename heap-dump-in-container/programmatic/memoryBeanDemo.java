import java.io.IOException;
import java.lang.management.ManagementFactory;
import java.nio.file.Paths;
import java.util.logging.Logger;
import java.lang.management.MemoryMXBean;
import java.lang.management.MemoryUsage;

public class memoryBeanDemo {

	public static void main(String[] args) {
		Logger LOGGER = Logger.getLogger(Thread.currentThread().getStackTrace()[0].getClassName() );

    	LOGGER.info("Logging an INFO-level message");
		int mb = 1024 * 1024;
		MemoryMXBean memoryBean = ManagementFactory.getMemoryMXBean();
		long xmx = memoryBean.getHeapMemoryUsage().getMax() / mb;
		long xms = memoryBean.getHeapMemoryUsage().getInit() / mb;

		MemoryUsage heap = memoryBean.getHeapMemoryUsage();
		MemoryUsage nonHeap = memoryBean.getNonHeapMemoryUsage();

		LOGGER.info("Initial Memory (xms):" + xms + " mb");
		LOGGER.info("Max Memory (xmx): " + xmx + " mb" );
		LOGGER.info("Non heap usage: " + nonHeap.toString());
	}

}