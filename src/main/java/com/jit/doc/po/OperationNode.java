package com.jit.doc.po;

public class OperationNode {
    /**
     * 更改的位置
     */
    private Integer index;
    /**
     * 更改的内容
     */
    private String content;

    public Integer getIndex() {
        return index;
    }

    public void setIndex(Integer index) {
        this.index = index;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    @Override
    public String toString() {
        return "OperationNode{" +
                "index=" + index +
                ", content='" + content + '\'' +
                '}';
    }
}
