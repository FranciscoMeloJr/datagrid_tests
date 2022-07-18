import java.io.IOException;
import java.lang.management.ManagementFactory;
import java.nio.file.Paths;
import java.util.logging.Logger;
import java.lang.management.MemoryMXBean;
import java.lang.management.RuntimeMXBean;
import java.lang.management.OperatingSystemMXBean;
import java.lang.management.ThreadMXBean;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

public class JVMInfo {

	public static void main(String[] args) {
		Logger LOGGER = Logger.getLogger(Thread.currentThread().getStackTrace()[0].getClassName() );

    	LOGGER.info("Support JVM info tool");
		RuntimeMXBean runtimeBean = ManagementFactory.getRuntimeMXBean();

		List<String> infos = new ArrayList<String>();
		
		infos.add("uptime" + "" + runtimeBean.getUptime());
		infos.add("name " +  runtimeBean.getName());
		infos.add("pid "+ runtimeBean.getName().split("@")[0]);
		
		OperatingSystemMXBean systemBean = ManagementFactory.getOperatingSystemMXBean();
		infos.add("os name" + systemBean.getName());
		infos.add("os version " + systemBean.getVersion());
		infos.add("system load average " + systemBean.getSystemLoadAverage());
		infos.add("available processors " + systemBean.getAvailableProcessors());

		ThreadMXBean threadBean = ManagementFactory.getThreadMXBean();
		infos.add("thread count " + threadBean.getThreadCount());
		infos.add("peak thread count " + threadBean.getPeakThreadCount());
		
		MemoryMXBean memoryBean = ManagementFactory.getMemoryMXBean();
		infos.add("heap memory used " + memoryBean.getHeapMemoryUsage().getUsed());
		infos.add("non-heap memory used " +  memoryBean.getNonHeapMemoryUsage().getUsed());
		
		System.out.println(Arrays.toString(infos.toArray()));
	}
	
}
