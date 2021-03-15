package com.jit.doc.common;

import java.util.HashMap;
import java.util.Map;

public class Result {
    private Map status = new HashMap();
    private Object result;

    public Result(){
        this.status.put("code", 1);
        this.status.put("message", "操作成功");
    }

    public void setStatus(int code, String message) {
        this.status.put("code", code);
        this.status.put("message", message);
    }

    public void setResult(Object result) {
        this.result = result;
    }

    public Map getStatus() {
        return this.status;
    }

    public Object getResult() {
        return this.result;
    }
}
