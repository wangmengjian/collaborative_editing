package com.jit.doc.common;

import com.google.gson.Gson;
import com.jit.doc.po.*;
import com.jit.doc.services.DocumentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.*;

import java.io.IOException;
import java.util.*;

/**
 * 消息处理类
 *
 * @author ts
 */
@Component
public class WebSocketPushHandler implements WebSocketHandler {
    /**
     * 发送给用户的result状态码对应信息
     * 1：更新段落库
     * 2：在线人数更改
     *
     *
     *
     */
    @Autowired
    private DocumentService documentService;

    //每个文档对应用户session列表
    private static final Map<Integer, List<WebSocketSession>> documentUserListMap = new HashMap<>();
    //文档对应段落库
    private static final Map<Integer, List<Node>> paragraphLibraryMap = new HashMap<>();
    //每个用户正在编辑的文档id
    private static final Map<Integer, Integer> userDocument = new HashMap<>();

    /**
     * 用户进入websocket
     *
     * @param session
     * @throws Exception
     */
    @Override
    public void afterConnectionEstablished(WebSocketSession session) throws Exception {
        System.out.println("成功进入了系统。。。");
    }

    /**
     * 处理用户发送的信息
     *
     * @param session 用户会话
     * @param message 用户发送的信息
     * @throws Exception
     */
    @Override
    public void handleMessage(WebSocketSession session, WebSocketMessage<?> message) throws Exception {
        User nowUser = (User) (session.getAttributes().get("CURRENT_WEBSOCKET_USER"));
        String content = (String) message.getPayload();
        System.out.println(content);
        Gson gson = new Gson();
        //当前用户操作
        //当前用户进入通道
        Operation nowUserOperation = gson.fromJson(content, Operation.class);
        if (nowUserOperation.getType()==0) {
            //判断用户是否为第一人进入该文档通道
            if (documentUserListMap.get(nowUserOperation.getDocumentId()) == null) {
                List<WebSocketSession> userSessionList = new ArrayList<>();
                userSessionList.add(session);
                //初始化用户map
                documentUserListMap.put(nowUserOperation.getDocumentId(), userSessionList);
                Document document = documentService.queryByDocumentId(nowUserOperation.getDocumentId());
                //初始化文档段落库
                paragraphLibraryMap.put(nowUserOperation.getDocumentId(), FileUtils.analysisDoc(document));
                userDocument.put(nowUser.getId(), document.getId());
                System.out.println("第一个进去系统当前在线人数:1");
            } else {
                List<WebSocketSession> userSessionList = documentUserListMap.get(nowUserOperation.getDocumentId());
                userSessionList.add(session);
                userDocument.put(nowUser.getId(), nowUserOperation.getDocumentId());
                System.out.println("当前在线人数:" + userSessionList.size());
            }
            List<Node> paragraphLibrary= paragraphLibraryMap.get(nowUserOperation.getDocumentId());
            //给该用户发送当前段落库
            sendMessageToUser(1,"段落库",paragraphLibrary,session);
            List<WebSocketSession> userSessionList = documentUserListMap.get(nowUserOperation.getDocumentId());
            int onlinePeople=userSessionList.size();
            sendMessagesToUsers(2,"在线人数",onlinePeople,nowUserOperation.getDocumentId());
        }else if(nowUserOperation.getType()==4){
            Document document=new Document();
            document.setId(nowUserOperation.getDocumentId());
            document.setDocName(nowUserOperation.getDocName());
            documentService.editDocument(document);
        }
        else {//用户编辑文本操作
            //解除用户其他段落绑定状态
            List<Node> paragraphLibrary = paragraphLibraryMap.get(nowUserOperation.getDocumentId());
            if(paragraphLibrary!=null&&paragraphLibrary.size()>0){
                for(Node node:paragraphLibrary){
                    if(node.getUser()!=null&&node.getUser().getId().equals(nowUser.getId())){
                        node.setUser(null);
                    }
                }
            }
            System.out.println(nowUserOperation);
            if(nowUserOperation.getType()==3){//用户更改文档
                //获取更改段落库中的操作节点
                List<OperationNode> operationNodeList=nowUserOperation.getOperationNodeList();
                for(OperationNode operationNode:operationNodeList){
                    paragraphLibrary.get(operationNode.getIndex()).setContent(operationNode.getContent());
                }
                //第一个段落绑定给该用户
                if(operationNodeList!=null&&operationNodeList.size()>0) {
                    paragraphLibrary.get(operationNodeList.get(0).getIndex()).setUser(nowUser);
                }
                sendMessagesToOtherUsers(1,"段落库",paragraphLibrary,nowUser.getId(),nowUserOperation.getDocumentId());
            }else if(nowUserOperation.getType()==2){
                //获取更改段落库中的操作节点
                List<OperationNode> operationNodeList=nowUserOperation.getOperationNodeList();
                if(nowUserOperation.getBeginLineIndex()>=paragraphLibrary.size()){//尾部添加
                    for(OperationNode operationNode:operationNodeList){
                        Node node=new Node();
                        node.setContent(operationNode.getContent());
                        node.setDocumentId(nowUserOperation.getDocumentId());
                        paragraphLibrary.add(node);
                    }
                    paragraphLibrary.get(nowUserOperation.getBeginLineIndex()).setUser(nowUser);
                }else{//中部插入
                    paragraphLibrary.remove(paragraphLibrary.get(operationNodeList.get(0).getIndex()));
                    for(OperationNode operationNode:operationNodeList){
                        Node node=new Node();
                        node.setContent(operationNode.getContent());
                        node.setDocumentId(nowUserOperation.getDocumentId());
                        paragraphLibrary.add(operationNode.getIndex(),node);
                    }
                    paragraphLibrary.get(nowUserOperation.getBeginLineIndex()).setUser(nowUser);
                }
                sendMessagesToOtherUsers(1,"段落库",paragraphLibrary,nowUser.getId(),nowUserOperation.getDocumentId());
            }
            else{//删除操作
                //获取更改段落库中的操作节点
                List<OperationNode> operationNodeList=nowUserOperation.getOperationNodeList();
                for(int i=nowUserOperation.getBeginLineIndex(),j=0;j<nowUserOperation.getChangeLineCount();j++){
                    paragraphLibrary.remove(i);
                }
                if(operationNodeList!=null&&operationNodeList.size()>0){
                    //删除多行首尾合并
                    Node node=new Node();
                    node.setDocumentId(nowUserOperation.getDocumentId());
                    node.setUser(nowUser);
                    node.setContent(operationNodeList.get(0).getContent());
                    paragraphLibrary.add(operationNodeList.get(0).getIndex(),node);
                }
                sendMessagesToOtherUsers(1,"段落库",paragraphLibrary,nowUser.getId(),nowUserOperation.getDocumentId());
            }
            //保存文档
            Document document=new Document();
            String newContent="";
            for(Node node:paragraphLibrary){
                newContent+=node.getContent();
            }
            document.setId(nowUserOperation.getDocumentId());
            document.setDocContent(newContent);
            document.setRecentUpdateUserId(nowUser.getId());
            document.setRecentUpdateUsername(nowUser.getNickName());
            documentService.editGroupDocument(document);
            //保存文档结束
        }
        System.out.println("当前段落库:");
        for (Node node : paragraphLibraryMap.get(nowUserOperation.getDocumentId())) {
            System.out.println(node.toString());
        }
    }

    //后台错误信息处理方法
    @Override
    public void handleTransportError(WebSocketSession session, Throwable exception) throws Exception {
    }

    /**
     * 用户退出后的处理，不如退出之后，要将用户信息从websocket的session中remove掉，文档对应列表中也相应删除
     *
     * @param session
     * @param closeStatus
     * @throws Exception
     */
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus closeStatus) throws Exception {
        if (session.isOpen()) {
            session.close();
        }
        User nowUser = (User) (session.getAttributes().get("CURRENT_WEBSOCKET_USER"));
        List<Node> paragraphLibrary = paragraphLibraryMap.get(userDocument.get(nowUser.getId()));
        if(paragraphLibrary!=null&&paragraphLibrary.size()>0){
            for(Node node:paragraphLibrary){
                if(node.getUser()!=null&&node.getUser().getId().equals(nowUser.getId())){
                    node.setUser(null);
                }
            }
        }
        sendMessagesToOtherUsers(1,"段落库",paragraphLibrary,nowUser.getId(),userDocument.get(nowUser.getId()));
        //用户正在编辑的文档对应用户列表
        List<WebSocketSession> userSessionList = documentUserListMap.get(userDocument.get(nowUser.getId()));
        userSessionList.remove(session);
        System.out.println(nowUser.getNickName() + "安全退出了系统");
        int onlinePeople=userSessionList.size();
        sendMessagesToUsers(2,"在线人数",onlinePeople,userDocument.get(nowUser.getId()));
        if(userSessionList.size()==0){
            //清除两个map
            documentUserListMap.remove(userDocument.get(nowUser.getId()));
            paragraphLibraryMap.remove(userDocument.get(nowUser.getId()));
        }

        //最后清除用户与文档的绑定关系不然前面获取不到用户对应的文档id
        userDocument.remove(nowUser.getId());
    }

    @Override
    public boolean supportsPartialMessages() {
        return false;
    }

    /**
     * 给所有用户发送信息
     * @param code 状态码
     * @param message 结果是啥
     * @param object 结果
     * @param documentId 文档id
     */
    public void sendMessagesToUsers(int code, String message,Object object, Integer documentId) {
        Result result=new Result();
        result.setStatus(code,message);
        result.setResult(object);
        Gson gson=new Gson();
        String sendMessage=gson.toJson(result);
        TextMessage mes=new TextMessage(sendMessage);
        List<WebSocketSession> webSocketSessionList= documentUserListMap.get(documentId);
        for(WebSocketSession user:webSocketSessionList){
            try {
                if (user.isOpen()) {
                    user.sendMessage(mes);
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
    /**
     * 给所有用户发送信息
     * @param code 状态码
     * @param message 结果是啥
     * @param object 结果
     * @param documentId 文档id
     */
    public void sendMessagesToOtherUsers(int code, String message,Object object,Integer nowUserId, Integer documentId) {
        Result result=new Result();
        result.setStatus(code,message);
        result.setResult(object);
        Gson gson=new Gson();
        String sendMessage=gson.toJson(result);
        TextMessage mes=new TextMessage(sendMessage);
        List<WebSocketSession> webSocketSessionList= documentUserListMap.get(documentId);
        for(WebSocketSession user:webSocketSessionList){
            User user1= (User) user.getAttributes().get("CURRENT_WEBSOCKET_USER");
            if(!user1.getId().equals(nowUserId)) {
                try {
                    if (user.isOpen()) {
                        user.sendMessage(mes);
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
    /**
     * 发送消息给指定的用户
     */
    public void sendMessageToUser(int code, String message,Object object,WebSocketSession user) {
        Result result=new Result();
        result.setStatus(code,message);
        result.setResult(object);
        Gson gson=new Gson();
        String sendMessage=gson.toJson(result);
        TextMessage mes=new TextMessage(sendMessage);
        try {
            if (user.isOpen()) {
                user.sendMessage(mes);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 对象转成TextMessage
     * @param object
     * @return
     */
    public TextMessage objectChangeTextMessage(Object object){
        Gson gson=new Gson();
        String sendMessage=gson.toJson(object);
        return new TextMessage(sendMessage);
    }
}
