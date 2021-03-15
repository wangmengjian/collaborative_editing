package com.jit.doc.dto;

import javax.validation.constraints.NotNull;

public class DocumentDto {
    private Integer id;
    private String docName;
    private Long docSize;
    //无样式的内容
    private String docContent;
    private String createTime;
    private String updateTime;
    private String isDelete;
    //单词出现次数
    private Integer wordAccount;

    public Integer getWordAccount() {
        return wordAccount;
    }

    public void setWordAccount(Integer wordAccount) {
        this.wordAccount = wordAccount;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getDocName() {
        return docName;
    }

    public void setDocName(String docName) {
        this.docName = docName;
    }

    public Long getDocSize() {
        return docSize;
    }

    public void setDocSize(Long docSize) {
        this.docSize = docSize;
    }

    public String getDocContent() {
        return docContent;
    }

    public void setDocContent(String docContent) {
        this.docContent = docContent;
    }

    public String getCreateTime() {
        return createTime;
    }

    public void setCreateTime(String createTime) {
        this.createTime = createTime;
    }

    public String getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(String updateTime) {
        this.updateTime = updateTime;
    }

    public String getIsDelete() {
        return isDelete;
    }

    public void setIsDelete(String isDelete) {
        this.isDelete = isDelete;
    }
}
