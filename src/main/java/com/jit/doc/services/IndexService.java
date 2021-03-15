package com.jit.doc.services;

import com.jit.doc.mapreduce.InvertedIndex;
import com.jit.doc.po.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;

@Service
public class IndexService {
    @Async
    public void dealDocumentIndex(User user){
        try {
            InvertedIndex.createIndex("/file/"+user.getId(),"/indexFile/"+user.getId());
            System.out.println("文档索引创建成功");
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("文档索引创建失败");
        }
    }
}
