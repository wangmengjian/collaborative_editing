package com.jit.doc.common;

import com.jit.doc.po.Document;
import com.jit.doc.po.Node;
import com.jit.doc.po.Operation;
import com.jit.doc.services.UserService;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataOutputStream;
import org.apache.hadoop.fs.FileStatus;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
import org.junit.Test;
import org.springframework.beans.factory.annotation.Autowired;
import sun.reflect.misc.FieldUtil;

import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class FileUtils {
    @Test
    public void test(){
        upload("123\n" +
                        "士大夫士大夫吉林省\n" +
                        "撒旦发生六点就发了\n" +
                        "发生的几率就过来让他\n" +
                        "士大夫乐山大佛胜多负少\n" +
                        "wer\n"
                ,"/file/7/50");
    }
    public static String getEncoding(String str){
        String encode;

        encode = "UTF-16";
        try
        {
            if(str.equals(new String(str.getBytes(), encode)))
{
            return encode;
        }
        }
        catch(Exception ex) {}

        encode = "ASCII";
        try
        {
            if(str.equals(new String(str.getBytes(), encode)))
{
            return "字符串<< " + str + " >>中仅由数字和英文字母组成，无法识别其编码格式";
        }
        }
        catch(Exception ex) {}

        encode = "ISO-8859-1";
        try
        {
            if(str.equals(new String(str.getBytes(), encode)))
{
            return encode;
        }
        }
        catch(Exception ex) {}

        encode = "GB2312";
        try
        {
            if(str.equals(new String(str.getBytes(), encode)))
{
            return encode;
        }
        }
        catch(Exception ex) {}

        encode = "UTF-8";
        try
        {
            if(str.equals(new String(str.getBytes(), encode)))
{
            return encode;
        }
        }
        catch(Exception ex) {}

        /*
         *......待完善
         */

        return "未识别编码格式";
    }
        /**
         * 上传文件默认GB2312编码
         * @param content
         * @param path
         * @return
         */
    public static boolean upload(String content,String path) {
        Configuration configuration=new Configuration();
        configuration.set("fs.defaultFS","hdfs://175.24.16.7:9000");
        configuration.set("dfs.client.use.datanode.hostname", "true");
        try {
            FileSystem fileSystem = FileSystem.newInstance(configuration);
            FSDataOutputStream outputStream = fileSystem.create(new Path(path));
            outputStream.write(content.getBytes());
            outputStream.close();
            fileSystem.close();
        }catch (Exception e){
            return false;
        }
        return true;
    }
    public static long getFileLength(String path){
        Configuration configuration=new Configuration();
        configuration.set("fs.defaultFS","hdfs://175.24.16.7:9000");
        configuration.set("dfs.client.use.datanode.hostname", "true");
        try {
            FileSystem fileSystem = FileSystem.newInstance(configuration);
            FileStatus file = fileSystem.getFileStatus(new Path(path));
            return file.getLen();
        }catch (Exception e){
            System.out.println("文件不存在");
            return 0;
        }
    }
    public static boolean deleteFile(String path) {
        Configuration configuration=new Configuration();
        configuration.set("fs.defaultFS","hdfs://175.24.16.7:9000");
        configuration.set("dfs.client.use.datanode.hostname", "true");
        try {
            FileSystem fileSystem = FileSystem.newInstance(configuration);
            fileSystem.delete(new Path(path),true);
        }catch (Exception e){
            return false;
        }
        return true;
    }

    /**
     * jsoup解析文本
     * @param document
     * @return
     */
    public static List<Node> analysisDoc(Document document){
        org.jsoup.nodes.Document document1= Jsoup.parseBodyFragment(document.getDocContent());
        Element element=document1.body();
        Elements elements=element.children();
        List<Node> nodeList=new ArrayList<>();
        for(Element element1:elements){
            Node node=new Node();
            node.setDocumentId(document.getId());
            node.setContent(element1.toString());
            nodeList.add(node);
        }
        return nodeList;
    }
    public static String getContent(String s){
        Document document=new Document();
        document.setDocContent(s);
        List<Node> nodeList=FileUtils.analysisDoc(document);
        String result="";
        for(Node node:nodeList){
            result+=Html2Text.getContent(node.getContent().toLowerCase())+"\n";
        }
        return result;
    }
}
