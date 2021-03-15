<%--
  Created by IntelliJ IDEA.
  User: 18861
  Date: 2019/12/29
  Time: 12:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>${document.docName}</title>
    <!-- Tell the browser to be responsive to screen width -->
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="<c:url value="/plugins/fontawesome-free/css/all.min.css"/>">
    <!-- Ionicons -->
    <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
    <!-- icheck bootstrap -->
    <link rel="stylesheet" href="<c:url value="/plugins/icheck-bootstrap/icheck-bootstrap.min.css"/>">
    <!-- Theme style -->
    <link rel="stylesheet" href="<c:url value="/dist/css/adminlte.min.css"/>">
    <!-- Google Font: Source Sans Pro -->
    <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700" rel="stylesheet">
    <style type="text/css">
        .toolbar {
            border: 1px solid #ccc; /*设置下拉棒*/
        }

        .w-e-text-container {
            height: 500px !important; /*!important是重点，因为原div是行内样式设置的高度300px*/
        }

        .locking {
            box-shadow: 0 1px 6px 0 rgba(32, 33, 36, 0.28);
            border-color: rgba(223, 225, 229, 0);
            border-radius: 24px;
            border: 1px solid #dfe1e5;
        }

        #back:hover {
            cursor: pointer;
        }
    </style>
</head>
<body class="hold-transition skin-blue layout-top-nav">
<div class="wrapper">

    <jsp:include page="header_myGroup.jsp"/>

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">

        <!-- Main content -->
        <section class="content" style="margin-top:15px;">
            <div class="row">
                <div class="col-md-12">
                    <!-- /.box -->
                    <div class="card">
                        <div class="card-header">
                            <a id="back"><i class="fa fa-fw fa-angle-left"></i>新增团队文档</a>
                        </div>
                        <div class="card-body">
                            <div class="row">

                                <div class="col-md-3">
                                    <div class="info-box">
                                        <span class="info-box-icon bg-warning"><i class="fa fa-pencil-alt"></i></span>
                                        <div class="info-box-content">
                                            <span class="info-box-text">当前编辑人数：</span>
                                            <span class="info-box-number" id="onlinePeople"></span>
                                        </div>
                                        <!-- /.info-box-content -->
                                    </div>
                                    <!-- /.info-box -->
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group col-md-6">

                                    <input id="docName" type="text" class="form-control"
                                           placeholder="请输入标题" value="${document.docName}"
                                           name="docName">
                                </div>
                            </div>
                            <div class="form-group" id="docContent">
                            </div>
                        </div>
                    </div>
                    <!-- tools box -->
                    <!-- /. tools -->
                </div>
            </div>
        </section>
<!-- /.content -->
</div>
<!-- /.content-wrapper -->
    <footer class="main-footer">
        <!-- To the right -->
        <div class="float-right d-none d-sm-inline">
            Anything you want
        </div>
        <!-- Default to the left -->
        <strong>Copyright © 2014-2019 <a href="https://adminlte.io">AdminLTE.io</a>.</strong> All rights reserved.
    </footer>

</div>
<!-- jQuery -->
<script src="<c:url value="/plugins/jquery/jquery.min.js"/>"></script>
<!-- Bootstrap 4 -->
<script src="<c:url value="/plugins/bootstrap/js/bootstrap.bundle.min.js"/>"></script>
<!-- AdminLTE App -->
<script src="<c:url value="/dist/js/adminlte.min.js"/>"></script>
<!-- AdminLTE for demo purposes -->
<script src="<c:url value="/dist/js/demo.js"/>"></script>
<script src="<c:url value="/dist/js/wangEditor.js"/>"></script>
<script>
    $(function () {
        $("#back").click(function () {
            window.location.href = "<c:url value='/render/toGroupDocuments/'/>${document.groupId}";
        })

        function compareObj(obj1, obj2) {
            var flag = true;

            function compre(obj1, obj2) {
                if (Object.keys(obj1).length != Object.keys(obj2).length) {
                    flag = false;
                } else {
                    for (var x in obj1) {
                        if (obj2.hasOwnProperty(x)) {
                            if (obj1[x] !== obj2[x]) {
                                compre(obj1[x], obj2[x]);
                            }
                        } else {
                            flag = false;
                        }
                    }
                }
                if (flag === false) {
                    return false;
                } else {
                    return true;
                }

            }

            return compre(obj1, obj2)
        }

        function domToString(node) {
            var tmpNode = document.createElement("div");
            //appendChild()  参数Node对象   返回Node对象  Element方法
            //cloneNode()  参数布尔类型  返回Node对象   Element方法
            tmpNode.appendChild(node.cloneNode(true));
            var str = tmpNode.innerHTML;
            tmpNode = node = null; // prevent memory leaks in IE
            return str;
        }

        //wangEditor编辑器
        var E = window.wangEditor
        var editor = new E('#docContent')
        var oldContent;
        var oldContentStringArray = new Array();
        //内容变化时触发的事件
        var bug = 0;
        editor.customConfig.onchange = function (html) {
            if (bug == 0) {
                bug++;
                return;
            }
            var newContent = editor.txt.html()  // 获取富文本框的内容
            var doms = $.parseHTML(newContent);
            var newContentStringArray = new Array();
            for (var i = 0; i < doms.length; i++) {
                newContentStringArray[i] = domToString(doms[i]);
            }
            //文档行数不变的修改
            if (newContentStringArray.length == oldContentStringArray.length) {
                var beginLocation = 0, endLocation = oldContentStringArray.length - 1;
                for (; beginLocation < newContentStringArray.length; beginLocation++) {
                    if (newContentStringArray[beginLocation] != oldContentStringArray[beginLocation]) break;
                }
                for (; endLocation >= 0; endLocation--) {
                    if (newContentStringArray[endLocation] != oldContentStringArray[endLocation]) break;
                }
                //新的内容
                var json = new Object();
                json.documentId =${document.id};
                json.type = 3;
                json.operationNodeList = new Array();
                var j = 0;
                for (var i = beginLocation; i <= endLocation; i++) {
                    json.operationNodeList[j] = new Object();
                    json.operationNodeList[j].index = i;
                    json.operationNodeList[j].content = newContentStringArray[i];
                    //更新旧变量
                    oldContentStringArray[i] = newContentStringArray[i];
                    j++;
                }
                console.log(json)
                //将操作列表发送给服务器，防止修改多行
                webSocket.send(JSON.stringify(json));
            } else if (newContentStringArray.length > oldContentStringArray.length) {//回车或复制操作
                console.log(newContentStringArray);
                console.log(oldContentStringArray);
                var minLength = newContentStringArray.length < oldContentStringArray.length ? newContentStringArray.length : oldContentStringArray.length;
                var beginLineIndex;
                for (beginLineIndex = 0; beginLineIndex < minLength; beginLineIndex++) {
                    if (newContentStringArray[beginLineIndex] != oldContentStringArray[beginLineIndex]) {
                        break;
                    }
                }
                if (beginLineIndex == minLength) {//尾部添加
                    var json = new Object();
                    var line = 0;
                    json.documentId =${document.id};
                    json.type = 2;
                    json.beginLineIndex = beginLineIndex;
                    json.operationNodeList = new Array();
                    for (var i = beginLineIndex; i < newContentStringArray.length; i++) {
                        json.operationNodeList[line] = new Object();
                        json.operationNodeList[line].index = i;
                        json.operationNodeList[line].content = newContentStringArray[i];
                        line++;
                    }
                    json.changeLineCount = line;
                    console.log(json)
                    webSocket.send(JSON.stringify(json));
                    oldContentStringArray = newContentStringArray;
                } else {//中间插入
                    var json = new Object();
                    var line = 0;
                    json.documentId =${document.id};
                    json.type = 2;
                    json.beginLineIndex = beginLineIndex;
                    json.operationNodeList = new Array();
                    for (var i = beginLineIndex; i < newContentStringArray.length; i++) {
                        if (newContentStringArray[i] == oldContentStringArray[beginLineIndex + 1]) {
                            break;
                        } else {
                            json.operationNodeList[line] = new Object();
                            json.operationNodeList[line].index = i;
                            json.operationNodeList[line].content = newContentStringArray[i];
                            line++;
                        }
                    }
                    json.changeLineCount = line;
                    console.log(json)
                    webSocket.send(JSON.stringify(json));
                    oldContentStringArray = newContentStringArray;
                }
            } else {//删除文本
                console.log(newContentStringArray);
                console.log(oldContentStringArray);
                var minLength = newContentStringArray.length < oldContentStringArray.length ? newContentStringArray.length : oldContentStringArray.length;
                var maxLength = newContentStringArray.length > oldContentStringArray.length ? newContentStringArray.length : oldContentStringArray.length;
                var lengthDiff = maxLength - minLength;
                var beginLineIndex;
                for (beginLineIndex = 0; beginLineIndex < minLength; beginLineIndex++) {
                    if (newContentStringArray[beginLineIndex] != oldContentStringArray[beginLineIndex]) {
                        break;
                    }
                }
                var oldEndLineIndex;
                for (oldEndLineIndex = oldContentStringArray.length - 1; oldEndLineIndex >= maxLength - minLength; oldEndLineIndex--) {
                    if (newContentStringArray[oldEndLineIndex - lengthDiff] != oldContentStringArray[oldEndLineIndex]) {
                        break;
                    }
                }
                var newEndLineIndex = oldEndLineIndex - lengthDiff;
                console.log("beginLineIndex:" + beginLineIndex);
                console.log("newEndLineIndex:" + newEndLineIndex);
                if (beginLineIndex > newEndLineIndex) {
                    //仅删除多个节点
                    var json = new Object();
                    json.documentId =${document.id};
                    json.type = 1;
                    json.beginLineIndex = beginLineIndex;
                    json.changeLineCount = oldEndLineIndex - beginLineIndex + 1;
                    console.log("changeLineCount" + json.changeLineCount);
                    webSocket.send(JSON.stringify(json));
                    oldContentStringArray = newContentStringArray;
                }
                if (beginLineIndex == newEndLineIndex) {
                    //删除多个节点并将首尾合并
                    var json = new Object();
                    json.documentId =${document.id};
                    json.type = 1;
                    json.beginLineIndex = beginLineIndex;
                    json.changeLineCount = oldEndLineIndex - beginLineIndex + 1;
                    json.operationNodeList = new Array();
                    json.operationNodeList[0] = new Object();
                    json.operationNodeList[0].index = beginLineIndex;
                    json.operationNodeList[0].content = newContentStringArray[beginLineIndex];
                    console.log(json)
                    webSocket.send(JSON.stringify(json));
                    oldContentStringArray = newContentStringArray;
                }
            }
        }
        editor.create()

        var webSocket = new WebSocket("ws://<%=request.getServerName()%>:8081/doc/webSocketServer");
        webSocket.onopen = function (event) {
            console.log("连接成功");
            console.log(event);
            var json = new Object();
            json.documentId =${document.id};
            //标识进入文档
            json.type = 0;
            webSocket.send(JSON.stringify(json));
        };
        webSocket.onerror = function (event) {
            console.log("连接失败");
            console.log(event);
        };
        webSocket.onclose = function (event) {
            console.log("Socket连接断开");
            console.log(event);
        };
        var colors = ["#666633", "#003333", "#993300", "#003399", "#663366", "#996600", "#663300", "#333333", "#999900", "#99CC99"];
        webSocket.onmessage = function (msg) {
            var data = $.parseJSON(msg.data);
            if (data.status.code == 1) {//文档段落库
                var node = "";
                for (var i = 0; i < data.result.length; i++) {
                    if (data.result[i].user != null && data.result[i].user.id !=${sessionScope.USER_SESSION.id}) {
                        node += "<ul contenteditable='false' class='nav nav-pills nav-stacked' ><li class='locking' style='padding-left:25px'><span style='background: " + colors[/*parseInt(Math.random() * 10)*/0] + ";" +
                            "padding:0px 10px 5px 10px;" +
                            "color: white;" +
                            "margin-left: 50px;" +
                            "border-radius: 0 0 10px 10px;'>" + data.result[i].user.nickName + "</span>" + data.result[i].content +
                            "</li></ul>";
                    } else {
                        node += data.result[i].content;
                    }
                }
                editor.txt.html(node);
                oldContent = node;
                var doms = $.parseHTML(oldContent);
                for (var i = 0; i < doms.length; i++) {
                    oldContentStringArray[i] = domToString(doms[i]);
                }
            } else if (data.status.code == 2) {
                $("#onlinePeople").text(data.result);
            }
        }
        //窗口关闭时，关闭连接
        window.unload = function () {
            webSocket.close();
        };
        $("input[name='docName']").change(function () {
            var json = new Object();
            json.documentId =${document.id};
            json.docName = $(this).val();
            //标识进入文档
            json.type = 4;
            console.log(json)
            webSocket.send(JSON.stringify(json));
        })
    })
</script>
</body>
</html>

