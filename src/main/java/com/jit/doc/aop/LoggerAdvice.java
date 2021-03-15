package com.jit.doc.aop;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class LoggerAdvice {
    private Logger logger = LoggerFactory.getLogger("access");

    @Pointcut("execution(* com.jit.doc.services..*(..))")
    private void logger(){}

    @Before("logger()")
    public void doBefore(JoinPoint jp) {
        logger.info("aop:before");
    }

    @Around("logger()")
    public Object doAround(ProceedingJoinPoint pjp) throws Throwable {
        logger.info("aop:around");
        Object object = pjp.proceed();
        return object;
    }
}
