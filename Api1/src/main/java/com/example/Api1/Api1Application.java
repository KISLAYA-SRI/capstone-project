package com.example.Api1;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class Api1Application extends SpringBootServletInitializer {

	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
	   return application.sources(Api1Application.class);
	}

	public static void main(String[] args) {
		SpringApplication.run(Api1Application.class, args);
	}

}
