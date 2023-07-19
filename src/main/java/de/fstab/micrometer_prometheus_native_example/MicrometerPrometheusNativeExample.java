package de.fstab.micrometer_prometheus_native_example;

import io.micrometer.core.instrument.MeterRegistry;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Random;

@SpringBootApplication
@RestController
public class MicrometerPrometheusNativeExample {

	private final Random random = new Random(0);
	private final MeterRegistry registry;

	public MicrometerPrometheusNativeExample(MeterRegistry registry) {
		this.registry = registry;
	}

	public static void main(String[] args) {
		SpringApplication.run(MicrometerPrometheusNativeExample.class, args);
	}

	@GetMapping("/")
	public String sayHello() throws InterruptedException {
		registry.counter("my.custom.count.total").increment();
		Thread.sleep((long) (Math.abs((random.nextGaussian() + 1.0) * 100.0)));
		return "Hello, World!\n";
	}
}
