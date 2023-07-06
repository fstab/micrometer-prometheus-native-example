package de.fstab.prometheus_new_demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Random;

@SpringBootApplication
@RestController
public class PrometheusNewDemoApplication {

	private final Random random = new Random(0);

	public static void main(String[] args) {
		SpringApplication.run(PrometheusNewDemoApplication.class, args);
	}

	@GetMapping("/")
	public String sayHello() throws InterruptedException {
		Thread.sleep((long) (Math.abs((random.nextGaussian() + 1.0) * 100.0)));
		return "Hello, World!\n";
	}
}
