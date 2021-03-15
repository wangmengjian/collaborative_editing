package com.jit.doc.common;

import com.jit.doc.filter.MyWebSocketInterceptor;
import com.jit.doc.services.DocumentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;

/**
 * Component注解告诉SpringMVC该类是一个SpringIOC容器下管理的类
 * 其实@Controller, @Service, @Repository是@Component的细化
 */
@Configuration
@EnableWebSocket
public class WebSocketConfig extends WebMvcConfigurerAdapter implements WebSocketConfigurer{
    @Autowired
    private DocumentService documentService;
    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        registry.addHandler(WebSocketPushHandler(),"/webSocketServer").addInterceptors(new MyWebSocketInterceptor());
        registry.addHandler(WebSocketPushHandler(), "/sockjs/webSocketServer").addInterceptors(new MyWebSocketInterceptor())
                .withSockJS();
    }
    @Bean
    public WebSocketHandler WebSocketPushHandler(){
        return new WebSocketPushHandler();
    }
}
