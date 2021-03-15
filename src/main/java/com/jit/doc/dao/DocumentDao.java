package com.jit.doc.dao;

import com.jit.doc.po.Document;
import com.jit.doc.po.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface DocumentDao {
    public int addDocument(Document document);
    public int editDocument(Document document);
    public Document queryDocument(int id);
    public List<Document> queryDocumentByUserId(@Param("docName") String docName, @Param("userId") int userId);
    public List<Document> queryDeletedDocumentByUserId(@Param("docName") String docName, @Param("userId") int userId);
    public int deleteDocumentById(List<Integer> ids);
    public List<Document> queryDocumentByDocIds(List<Integer> ids);
    public List<Document> queryDocumentsByGroupId(Integer groupId);
    public List<Document> queryAllDocuments();
    //通过文档id列表查询文档
    public List<Document> queryDeletedDocumentsByDocIds(List<Integer> ids);
    //从回收站中还原文档
    public int restoreDocByIds(List<Integer> ids);
    //彻底删除文档
    public int thoroughDeleteDocumentsByIds(List<Integer> ids);
}
