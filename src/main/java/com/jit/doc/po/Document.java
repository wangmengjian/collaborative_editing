package com.jit.doc.po;

import javax.validation.constraints.NotNull;

public class Document {
    private Integer id;
    @NotNull(message = "文档名不能为空")
    private String docName;
    private Long docSize;
    private String docContent;
    private String docLocation;
    private Integer groupId;
    private Integer createUserId;
    private String createUsername;
    private String createTime;
    private String updateTime;
    private String isDelete;
    private Integer recentUpdateUserId;
    private String recentUpdateUsername;
    private String deleteTime;

    public String getDeleteTime() {
        return deleteTime;
    }

    public void setDeleteTime(String deleteTime) {
        this.deleteTime = deleteTime;
    }

    public String getCreateUsername() {
        return createUsername;
    }

    public void setCreateUsername(String createUsername) {
        this.createUsername = createUsername;
    }

    public Integer getRecentUpdateUserId() {
        return recentUpdateUserId;
    }

    public void setRecentUpdateUserId(Integer recentUpdateUserId) {
        this.recentUpdateUserId = recentUpdateUserId;
    }

    public String getRecentUpdateUsername() {
        return recentUpdateUsername;
    }

    public void setRecentUpdateUsername(String recentUpdateUsername) {
        this.recentUpdateUsername = recentUpdateUsername;
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

    public String getDocLocation() {
        return docLocation;
    }

    public void setDocLocation(String docLocation) {
        this.docLocation = docLocation;
    }

    public Integer getGroupId() {
        return groupId;
    }

    public void setGroupId(Integer groupId) {
        this.groupId = groupId;
    }

    public Integer getCreateUserId() {
        return createUserId;
    }

    public void setCreateUserId(Integer createUserId) {
        this.createUserId = createUserId;
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
