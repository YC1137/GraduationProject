package com.heritage;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

/**
 * 非遗数字化展示平台启动类
 */
@SpringBootApplication
@EnableAsync
public class HeritagePlatformApplication {
    public static void main(String[] args) {
        SpringApplication.run(HeritagePlatformApplication.class, args);
        System.out.println("========================================");
        System.out.println("非遗数字化展示平台后端启动成功！");
        System.out.println("访问地址: http://localhost:8080/api");
        System.out.println("========================================");
    }
}
