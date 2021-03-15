package com.jit.doc.controller;

import com.jit.doc.common.FileUtils;
import com.jit.doc.common.Result;
import com.jit.doc.dao.DocumentDao;
import com.jit.doc.dto.DocumentDto;
import com.jit.doc.mapreduce.keyQuery;
import com.jit.doc.po.Document;
import com.jit.doc.po.User;
import com.jit.doc.services.DocumentService;
import com.jit.doc.services.IndexService;
import org.apache.poi.poifs.filesystem.DirectoryEntry;
import org.apache.poi.poifs.filesystem.DocumentEntry;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.ByteArrayInputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/document")
public class DocumentCtrl extends BaseCtrl {
    @Autowired
    private DocumentService documentService;
    @Autowired
    private DocumentDao documentDao;
    @Autowired
    private IndexService indexService;

    @RequestMapping("/addDocument")
    public Result addDocument(Document document, HttpSession session) {
        User user = (User) session.getAttribute("USER_SESSION");
        int result = documentService.addDocument(document, user);
        indexService.dealDocumentIndex(user);
        return this.send(result);
    }

    @RequestMapping("/editDocument")
    public Result editDocument(Document document, HttpSession session) {
        User user = (User) session.getAttribute("USER_SESSION");
        int result = documentService.editDocument(document);
        indexService.dealDocumentIndex(user);
        return this.send(result);
    }

    /**
     * 查询我的文档
     *
     * @param pageNumber
     * @param pageSize
     * @param session
     * @return
     */
    @RequestMapping("/queryDocuments")
    public Result queryDocuments(@RequestParam("pageNumber") Integer pageNumber,
                                 @RequestParam("pageSize") Integer pageSize,
                                 @RequestParam("docName") String docName, HttpSession session) {
        User user = (User) session.getAttribute("USER_SESSION");
        return this.send(documentService.queryDocumentsByUserId(docName, user.getId(), pageNumber, pageSize));
    }

    @RequestMapping("/deleteDocuments")
    public Result deleteDocumentById(@RequestParam(value = "ids", required = false) Integer[] ids, HttpSession session) {
        if (ids.length == 0) return null;
        List<Integer> idList = new ArrayList<>();
        for (int i = 0; i < ids.length; i++) {
            idList.add(ids[i]);
        }
        int result = documentService.deleteDocumentById(idList);
        User user = (User) session.getAttribute("USER_SESSION");
        indexService.dealDocumentIndex(user);
        return this.send(result);
    }

    /**
     * 通过关键词查询文档
     *
     * @param key
     * @param session
     * @return
     */
    @RequestMapping("/queryDocumentsByKey")
    public Result queryDocumentsByKey(@RequestParam("key") String key,
                                      @RequestParam("pageNumber") Integer pageNumber,
                                      @RequestParam("pageSize") Integer pageSize,
                                      HttpSession session) {
        User user = (User) session.getAttribute("USER_SESSION");
        List<DocumentDto> documentDtoList = keyQuery.queryDocumentsByKey(key, user.getId());
        Map<String, Object> resultMap = new HashMap<>();
        if (documentDtoList == null || documentDtoList.size() == 0) {
            resultMap.put("data", null);
            resultMap.put("total", 0);
            resultMap.put("size", 0);
            return this.send(resultMap);
        }
        List<Integer> idList = new ArrayList<>();
        for (DocumentDto documentDto : documentDtoList) {
            idList.add(documentDto.getId());
        }
        List<Document> documentList = documentDao.queryDocumentByDocIds(idList);
        for (DocumentDto documentDto : documentDtoList) {
            for (Document document : documentList) {
                if (documentDto.getId().equals(document.getId())) {
                    BeanUtils.copyProperties(document, documentDto);
                    documentDto.setDocContent(FileUtils.getContent(documentDto.getDocContent()));
                }
            }
        }
        List<DocumentDto> result = new ArrayList<>();
        for (int i = (pageNumber - 1) * pageSize; i < pageNumber * pageSize && i < documentDtoList.size(); i++) {
            result.add(documentDtoList.get(i));
        }
        resultMap.put("data", result);
        resultMap.put("total", documentDtoList.size());
        resultMap.put("size", result.size());
        return this.send(resultMap);
    }

    /**
     * 查询我删除的文档
     *
     * @param pageNumber
     * @param pageSize
     * @param session
     * @return
     */
    @RequestMapping("/queryDeletedDocuments")
    public Result queryDeletedDocuments(@RequestParam("pageNumber") Integer pageNumber,
                                        @RequestParam("pageSize") Integer pageSize,
                                        @RequestParam(value = "docName", required = false) String docName, HttpSession session) {
        User user = (User) session.getAttribute("USER_SESSION");
        return this.send(documentService.queryDeletedDocumentsByUserId(docName, user.getId(), pageNumber, pageSize));
    }

    /**
     * 还原文档
     *
     * @param ids
     * @return
     */
    @RequestMapping("/restoreDocuments")
    public Result restoreDocuments(@RequestParam(value = "ids", required = false) Integer[] ids, HttpSession session) {
        if (ids.length == 0) return null;
        List<Integer> idList = new ArrayList<>();
        for (int i = 0; i < ids.length; i++) {
            idList.add(ids[i]);
        }
        int result = documentService.restoreDocument(idList);
        User user = (User) session.getAttribute("USER_SESSION");
        indexService.dealDocumentIndex(user);
        return this.send(result);
    }

    /**
     * 彻底删除文档
     *
     * @param ids
     * @return
     */
    @RequestMapping("/thoroughDeleteDocuments")
    public Result thoroughDeleteDocuments(@RequestParam(value = "ids", required = false) Integer[] ids) {
        if (ids.length == 0) return null;
        List<Integer> idList = new ArrayList<>();
        for (int i = 0; i < ids.length; i++) {
            idList.add(ids[i]);
        }
        return this.send(documentService.thoroughDeleteDocumentByIds(idList));
    }

    /**
     * 文档导出
     *
     * @param documentId
     * @param request
     * @param response
     */
    @RequestMapping("/exportDocument")
    public Result exportDocument(@RequestParam(value = "documentId", required = true) Integer documentId, HttpServletRequest request, HttpServletResponse response) {
        Document document = documentService.queryByDocumentId(documentId);
        try {
            //word内容
            String content = "<html><body><h1>" + document.getDocName() + "</h1>" + document.getDocContent() + "</body></html>";
            byte b[] = content.getBytes("utf-8");  //这里是必须要设置编码的，不然导出中文就会乱码。
            ByteArrayInputStream bais = new ByteArrayInputStream(b);//将字节数组包装到流中
            /*
             * 关键地方
             * 生成word格式
             */
            POIFSFileSystem poifs = new POIFSFileSystem();
            DirectoryEntry directory = poifs.getRoot();
            DocumentEntry documentEntry = directory.createDocument("WordDocument", bais);
            //输出文件
            String fileName = document.getDocName();
            request.setCharacterEncoding("utf-8");
            response.setContentType("application/msword");//导出word格式
            response.addHeader("Content-disposition", "attachment;filename=" +
                    new String((fileName + ".doc").getBytes(),
                            "iso-8859-1"));
            OutputStream ostream = response.getOutputStream();
            poifs.writeFilesystem(ostream);
            bais.close();
            ostream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
