package com.jit.doc.controller;


import com.jit.doc.common.Result;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller 基类
 */
public class BaseCtrl {
    private final Logger exLogger = LoggerFactory.getLogger("exLogger");
    /**
     * 处理成功时的返回
     * @param o 返回的结果集
     * @return Result
     */
    protected Result send(Object o) {
        Result ret = new Result();
        ret.setResult(o);
        return ret;
    }

    /**
     * 非正常情况的返回
     * @param code 错误码
     * @param message 错误信息
     * @return Result
     */
    protected Result send(int code, String message) {
        Result ret = new Result();
        ret.setStatus(code, message);
        return ret;
    }

    /**
     * 特殊情况的反馈
     * @param o 结果集
     * @param code 状态码
     * @param message 状态信息
     * @return Result
     */
    protected Result send(Object o, int code, String message) {
        Result ret = new Result();
        ret.setStatus(code, message);
        ret.setResult(o);
        return ret;
    }
    /**
     * 全局异常拦截
     * @param ex
     * @return
     */
    /*@ExceptionHandler
    @ResponseBody
    public Result catchException(Exception ex) {
        Result ret = new Result();
        ret.setStatus(1005, "系统繁忙，请联系客服!");
        exLogger.error(ex.getMessage());
        return ret;
    }*/
    /**
     * 格式化表单验证信息
     * @param exception
     * @param response
     * @return
     */
    @ExceptionHandler(BindException.class)
    @ResponseBody
    public Result formatValidatorMsg(BindException exception, HttpServletResponse response) {
        Result ret = new Result();
        BindingResult bindingResult = exception.getBindingResult();
        Map<String, String> map = new HashMap<>();
        List<FieldError> list = bindingResult.getFieldErrors();
        List<String> messages=new ArrayList<>();
        for (FieldError error : list) {
            messages.add(error.getDefaultMessage());
        }
        ret.setStatus(1001, "参数有误");
        ret.setResult(messages);
        return ret;
    }

}

