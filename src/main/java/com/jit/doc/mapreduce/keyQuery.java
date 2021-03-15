package com.jit.doc.mapreduce;

import com.jit.doc.dao.DocumentDao;
import com.jit.doc.dto.DocumentDto;
import com.jit.doc.po.Document;
import com.jit.doc.po.Word;
import com.jit.doc.po.WordRecord;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.yarn.webapp.hamlet.Hamlet;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.*;
@Component
@Scope("session")
public class keyQuery {
    private static DocumentDao documentDao;
    @Autowired
    public void setDocumentDao(DocumentDao documentDao) {
        keyQuery.documentDao = documentDao;
    }
    public static String readFile(String path){
        Configuration configuration=new Configuration();
        configuration.set("fs.defaultFS","hdfs://175.24.16.7:9000");
        configuration.set("dfs.client.use.datanode.hostname", "true");
        FileSystem fs=null;
        try {
            fs = FileSystem.newInstance(configuration);
        }catch (Exception e){
        }
        try {
            FSDataInputStream his = fs.open(new Path(path));
            byte[] buff = new byte[1024];
            int length = 0;
            String content="";
            while ((length = his.read(buff)) != -1) {
                String s=new String(buff, 0, length);
                content+=s;
            }
            return content;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "";
    }
    /**
     * 读取用户对应的索引文件
     * @param userId
     * @return
     */
    public static List<Word> queryFiles(Integer userId){
        String indexFile=readFile("/indexFile/"+userId+"/part-r-00000");
        String[] strings=indexFile.split("\n");
        List<Word> wordList=new ArrayList<>();
        for(String string:strings){
            String[] strings1=string.split(" ");
            Word word=new Word();
            if(strings1.length>=2){
                word.setName(strings1[0].substring(0,strings1[0].length()-1));
                List<WordRecord> wordRecordList=new ArrayList<>();
                for(int i=1;i<strings1.length;i++){
                    String record=strings1[i];
                    String[] strings2=record.split("->");
                    WordRecord wordRecord=new WordRecord();
                    wordRecord.setDocumentId(Integer.valueOf(strings2[0]));
                    wordRecord.setCount(Integer.valueOf(strings2[1]));
                    wordRecordList.add(wordRecord);

                }
                Collections.sort(wordRecordList,new RecordComparator());
                word.setWordRecordList(wordRecordList);
                wordList.add(word);
            }
        }
        return wordList;
    }
    public static class RecordComparator implements Comparator<WordRecord>{
        @Override
        public int compare(WordRecord r1, WordRecord r2) {
            if(r1.getCount()>r2.getCount()){
                return -1;
            }else if(r1.getCount()<r2.getCount()){
                return 1;
            }else{
                return 0;
            }
        }
    }
    public static void main(String[] args) {
        queryFiles(7);
    }

    /**
     * 通过关键词给出搜索匹配文档
     * @param key
     * @Param userId
     * @return
     */
    public static List<DocumentDto> queryDocumentsByKey(String key,Integer userId){
        if(key.trim().replaceAll(" ","").equals("")){
            return null;
        }
        List<Word> index=queryFiles(userId);
        List<DocumentDto> documentDtoList=new ArrayList<>();
        List<Integer> idList=new ArrayList<>();
        for(Word word:index) {
            if (word.getName().toLowerCase().equals(key.trim())) {
                for (WordRecord wordRecord : word.getWordRecordList()) {
                    DocumentDto documentDto = new DocumentDto();
                    idList.add(wordRecord.getDocumentId());
                    documentDto.setId(wordRecord.getDocumentId());
                    documentDto.setWordAccount(wordRecord.getCount());
                    documentDtoList.add(documentDto);
                }
                break;
            }
        }
        //未查询到结果
        if(idList==null||idList.size()==0){
            return null;
        }
        return documentDtoList;
    }
}
