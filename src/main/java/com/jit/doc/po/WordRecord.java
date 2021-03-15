package com.jit.doc.po;

public class WordRecord {

    /**
     * 出现文档id
     */
    private Integer documentId;
    /**
     * 出现次数
     */
    private Integer count;

    @Override
    public String toString() {
        return "WordRecord{" +
                "documentId=" + documentId +
                ", count=" + count +
                '}';
    }

    public Integer getCount() {
        return count;
    }

    public void setCount(Integer count) {
        this.count = count;
    }

    public Integer getDocumentId() {
        return documentId;
    }

    public void setDocumentId(Integer documentId) {
        this.documentId = documentId;
    }
}
