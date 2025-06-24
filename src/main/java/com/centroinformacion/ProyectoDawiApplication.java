package com.centroinformacion;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;
@EnableScheduling
@SpringBootApplication
public class ProyectoDawiApplication {

	public static void main(String[] args) {
		SpringApplication.run(ProyectoDawiApplication.class, args);
	}

}
