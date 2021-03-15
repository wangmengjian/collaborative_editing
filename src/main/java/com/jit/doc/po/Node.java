package com.jit.doc.po;

/**
 * 段落节点
 */
public class Node {
    private Integer documentId;//文档id
    private String content;//更改内容
    private User user;

    public Integer getDocumentId() {
        return documentId;
    }

    public void setDocumentId(Integer documentId) {
        this.documentId = documentId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }
}
