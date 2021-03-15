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
    <title>文档搜索</title>
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
    <style>
        .docName {
            max-width: 300px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        #tableContent tr td{
            vertical-align:middle;
        }
        .paragraph{
            margin-top:5px;
        }
        .paragraph .title{
            display: block;
            font-weight: 400;
            font-size: medium;
            margin-bottom:5px;
            cursor:pointer;
        }
        .paragraph .time{
            color:darkgray;
            font-size:12px;
        }
        .paragraph .content{
            font-size:12px;
        }
        .paragraph .keyCount{
            color:gray;
            font-size:12px;
        }
        .origin{
            width:400px;height:50px;border: 1px solid #dfe1e5;
        }
        .focus{
            width:400px;height:50px;border: 1px solid #dfe1e5;box-shadow: 0 1px 6px 0 rgba(32,33,36,0.28);
            border-color: rgba(223,225,229,0);
        }
    </style>
</head>
<body class="hold-transition skin-blue layout-top-nav">
<div class="wrapper" style="background-color:white;">

    <jsp:include page="header_myDocument.jsp"/>

    <div class="lockscreen-wrapper" style="margin-top: 15%;">
        <div class="lockscreen-logo">
            <a href="<c:url value="/render/toSearchIndex"/>"><b>Cloud</b>DOC</a>
        </div>

        <!-- START LOCK SCREEN ITEM -->
        <div id="searchFrame" class="lockscreen-item origin">
            <div class="lockscreen-credentials" style="margin-left: 10px;height:50px;">
                <div class="input-group" style="height:50px;">
                    <input id="searchBox" type="text" class="form-control" style="height:48px;" placeholder="文档检索">
                    <div class="input-group-btn" style="height:45px;">
                        <button id="queryBtn" type="button" class="btn" style="height:47px;width: 50px;"><i class="fa fa-search text-muted"></i></button>
                    </div>
                </div>
            </div>
        </div>
    </div>

</div>
<!-- ./wrapper -->
<!-- jQuery -->
<script src="<c:url value="/plugins/jquery/jquery.min.js"/>"></script>
<!-- Bootstrap 4 -->
<script src="<c:url value="/plugins/bootstrap/js/bootstrap.bundle.min.js"/>"></script>
<!-- AdminLTE App -->
<script src="<c:url value="/dist/js/adminlte.min.js"/>"></script>
<script type="text/javascript" src="<c:url value='/dist/js/bootstrap-paginator.js'/>"></script>
<!-- Page Script -->
<script>
    $(function () {
        function query(){
            var queryContent=$("#searchBox").val();
            if(queryContent==""){return;}
            console.log("<c:url value='/render/toSearchDocuments?key='/>"+queryContent)
            window.location.href = "<c:url value='/render/toSearchDocuments?key='/>"+queryContent;
        }
        $("#queryBtn").click(query)
        document.onkeydown=function(event){
            var e = event || window.event || arguments.callee.caller.arguments[0];
            if(e && e.keyCode==27){ // 按 Esc
                //要做的事情
            }
            if(e && e.keyCode==113){ // 按 F2
                //要做的事情
            }
            if(e && e.keyCode==13){ // enter 键
                //要做的事情
                query()
            }
        };
        $("#searchBox").mouseover(function(){
            $("#searchFrame").removeClass("origin");
            $("#searchFrame").addClass("focus");
        })
        $("#searchBox").mouseleave(function(){
            $("#searchFrame").addClass("origin");
            $("#searchFrame").removeClass("focus");
        })
    });
</script>
<!-- AdminLTE for demo purposes -->
<script src="<c:url value="/dist/js/demo.js"/>"></script>
</body>
</html>

