package com.jit.doc.services;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.jit.doc.common.FileUtils;
import com.jit.doc.common.Util;
import com.jit.doc.dao.DocumentDao;
import com.jit.doc.mapreduce.InvertedIndex;
import com.jit.doc.po.Document;
import com.jit.doc.po.Group;
import com.jit.doc.po.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class DocumentService {
    @Autowired
    private DocumentDao documentDao;
    private SimpleDateFormat simpleDateFormat=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    @Autowired
    private HttpSession session;
    /**
     * 添加文档
     */
    @Transactional
    public int addDocument(Document document, User user){
        document.setCreateUserId(user.getId());
        document.setCreateUsername(user.getNickName());
        String now=simpleDateFormat.format(new Date());
        document.setCreateTime(now);
        document.setIsDelete("0");
        document.setUpdateTime(now);
        document.setDocLocation("");
        documentDao.addDocument(document);
        String path="/file/"+user.getId()+"/"+ document.getId();
        document.setDocLocation(path);
        FileUtils.upload(FileUtils.getContent(document.getDocContent()),path);
        document.setDocSize(FileUtils.getFileLength(path));
        documentDao.editDocument(document);
        return document.getId();
    }
    @Transactional
    public int editDocument(Document document){
        Document oldDocument=documentDao.queryDocument(document.getId());
        if(document.getDocContent()!=null){
            //更改原文件
            boolean result=FileUtils.upload(FileUtils.getContent(document.getDocContent()),oldDocument.getDocLocation());
            if(!result)return 0;
            document.setDocSize(FileUtils.getFileLength(oldDocument.getDocLocation()));
        }
        String now=simpleDateFormat.format(new Date());
        document.setUpdateTime(now);
        User user= (User) session.getAttribute("USER_SESSION");
        return documentDao.editDocument(document);
    }
    @Transactional
    public int editGroupDocument(Document document){
        Document oldDocument=documentDao.queryDocument(document.getId());
        if(document.getDocContent()!=null){
            //更改原文件
            boolean result=FileUtils.upload(FileUtils.getContent(document.getDocContent()),oldDocument.getDocLocation());
            if(!result)return 0;
            document.setDocSize(FileUtils.getFileLength(oldDocument.getDocLocation()));
        }
        String now=simpleDateFormat.format(new Date());
        document.setUpdateTime(now);
        return documentDao.editDocument(document);
    }
    /**
     * 通过用户id查询所有文档（不包括上传的团队文档）
     * @param userId
     * @param pageNumber
     * @param pageSize
     * @return
     */
    public Map<String,Object> queryDocumentsByUserId(String docName,Integer userId,Integer pageNumber,Integer pageSize){
        PageHelper.startPage(pageNumber,pageSize);
        List<Document> documents=documentDao.queryDocumentByUserId(docName,userId);
        PageInfo pageInfo=new PageInfo(documents);
        Map<String,Object> map=new HashMap<>();
        map.put("total",pageInfo.getTotal());
        map.put("size",pageInfo.getSize());
        map.put("data",documents);
        return map;
    }

    /**
     * 通过文档id查询文档信息
     * @param id
     * @return
     */
    public Document queryByDocumentId(Integer id){
        return documentDao.queryDocument(id);
    }
    @Transactional
    public int deleteDocumentById(List<Integer> ids){
        List<Document> documents=documentDao.queryDocumentByDocIds(ids);
        for(Document document:documents){
            FileUtils.deleteFile(document.getDocLocation());
        }
        User user= (User) session.getAttribute("USER_SESSION");
        return documentDao.deleteDocumentById(ids);
    }

    /**
     * 查询团队文档
     * @param groupId
     * @param pageNumber
     * @param pageSize
     * @return
     */
    public Map<String,Object> queryGroupDocuments(Integer groupId,Integer pageNumber,Integer pageSize){
        PageHelper.startPage(pageNumber,pageSize);
        List<Document> documentList=documentDao.queryDocumentsByGroupId(groupId);
        PageInfo pageInfo=new PageInfo(documentList);
        Map<String,Object> map=new HashMap<>();
        map.put("total",pageInfo.getTotal());
        map.put("size",pageInfo.getSize());
        map.put("data",documentList);
        return map;
    }

    /**
     * 查询所有的团队文档建立每个文档的socket通道
     * @return
     */
    public List<Document> queryAllDocuments(){
        return documentDao.queryAllDocuments();
    }

    /**
     * 通过用户id查询所有删除的文档（不包括上传的团队文档）
     * @param userId
     * @param pageNumber
     * @param pageSize
     * @return
     */
    public Map<String,Object> queryDeletedDocumentsByUserId(String docName,Integer userId,Integer pageNumber,Integer pageSize){
        PageHelper.startPage(pageNumber,pageSize);
        List<Document> documents=documentDao.queryDeletedDocumentByUserId(docName,userId);
        PageInfo pageInfo=new PageInfo(documents);
        Map<String,Object> map=new HashMap<>();
        map.put("total",pageInfo.getTotal());
        map.put("size",pageInfo.getSize());
        map.put("data",documents);
        return map;
    }

    /**
     * 还原文档
     * @param ids
     * @return
     */
    @Transactional
    public int restoreDocument(List<Integer> ids){
        List<Document> documents=documentDao.queryDeletedDocumentsByDocIds(ids);
        for(Document document:documents){
            FileUtils.upload(FileUtils.getContent(document.getDocContent()),document.getDocLocation());
        }
        User user= (User) session.getAttribute("USER_SESSION");
        return documentDao.restoreDocByIds(ids);
    }
    //彻底删除文档
    @Transactional
    public int thoroughDeleteDocumentByIds(List<Integer> ids){
        List<Document> documents=documentDao.queryDocumentByDocIds(ids);
        return documentDao.thoroughDeleteDocumentsByIds(ids);
    }
}
