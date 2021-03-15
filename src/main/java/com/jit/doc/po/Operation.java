package com.jit.doc.po;

import java.util.List;

/**
 * 操作对应实体类
 */
public class Operation {
    /**
     * 文档id
     */
    private Integer documentId;
    private String docName;
    /**
     * 0.进去协同文档
     * 1.文档行数减少的修改（删除一行或多行操作）
     * 2.文档行数增加的修改（回车或复制操作）
     * 3.文档行数不变的修改
     * 4.更改文档标题
     */
    private Integer type;
    private List<OperationNode> operationNodeList;
    private Integer beginLineIndex;
    private Integer changeLineCount;

    public String getDocName() {
        return docName;
    }

    public void setDocName(String docName) {
        this.docName = docName;
    }

    public Integer getBeginLineIndex() {
        return beginLineIndex;
    }

    public void setBeginLineIndex(Integer beginLineIndex) {
        this.beginLineIndex = beginLineIndex;
    }

    public Integer getChangeLineCount() {
        return changeLineCount;
    }

    public void setChangeLineCount(Integer changeLineCount) {
        this.changeLineCount = changeLineCount;
    }

    public Integer getDocumentId() {
        return documentId;
    }

    public void setDocumentId(Integer documentId) {
        this.documentId = documentId;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public List<OperationNode> getOperationNodeList() {
        return operationNodeList;
    }

    public void setOperationNodeList(List<OperationNode> operationNodeList) {
        this.operationNodeList = operationNodeList;
    }

    @Override
    public String toString() {
        return "Operation{" +
                "documentId=" + documentId +
                ", type=" + type +
                ", operationNodeList=" + operationNodeList +
                ", beginLineIndex=" + beginLineIndex +
                ", changeLineCount=" + changeLineCount +
                '}';
    }
}
