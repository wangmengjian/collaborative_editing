package com.jit.doc.po;

import java.util.List;

public class Word {
    /**
     * 单词id
     */
    private Integer id;
    /**
     * 单词名称
     */
    private String name;
    /**
     * 记录
     */
    private List<WordRecord> wordRecordList;

    @Override
    public String toString() {
        return "Word{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", wordRecordList=" + wordRecordList +
                '}';
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<WordRecord> getWordRecordList() {
        return wordRecordList;
    }

    public void setWordRecordList(List<WordRecord> wordRecordList) {
        this.wordRecordList = wordRecordList;
    }
}
