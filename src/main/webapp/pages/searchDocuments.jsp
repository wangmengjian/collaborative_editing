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
    <![endif]-->
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
            display: inline-block;
            font-weight: 400;
            font-size: medium;
            margin-bottom:5px;
            cursor:pointer;
            text-decoration: underline;
        }
        .paragraph .time{
            color:darkgray;
        }
        .paragraph .content{
        }
        .paragraph .keyCount{
            color:gray;
        }
        .docContent{
            overflow: hidden;display: -webkit-box;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 3;  //需要显示时文本行数
            overflow: hidden;
        }
    </style>
</head>
<body class="hold-transition skin-blue layout-top-nav">
<div class="wrapper">

    <jsp:include page="header_myDocument.jsp"/>

    <!-- Content Wrapper. Contains page content -->
    <div class="content-wrapper">

        <!-- Main content -->
        <section class="content" style="margin-top:15px;">
            <div class="row">
                <!-- /.col -->
                <div class="col-md-12">
                    <div class="card card-default">
                        <div class="card-header">
                            <div class="row" style="margin-bottom: 15px;">
                                <div class="col-lg-4">
                                    <div class="input-group">
                                        <input type="text" class="form-control" placeholder=""
                                               id="inputBox" value="${key}">
                                        <span class="input-group-append">
                                            <button class="btn btn-primary" type="button" id="queryBtn">搜索</button>
                                        </span>
                                    </div>
                                </div><!-- /.col-lg-6 -->
                            </div>
                        </div>
                        <!-- /.box-header -->
                        <div class="card-body">
                            <div class="row">
                            <div class="col-md-8" id="queryResult">
                            </div>
                            </div>
                        </div>
                        <!-- /.box-body -->
                        <div class="card-footer">
                                总共 <span id="totalRecord"></span> 条记录
                                当前页：<span id="nowPage"></span>/<span id="allPage"></span>
                                <div class="btn-group">
                                    <button id="leftBtn" type="button" class="btn btn-default btn-sm"><i class="fas fa-chevron-left"></i></button>
                                    <button id="rightBtn" type="button" class="btn btn-default btn-sm"><i class="fas fa-chevron-right"></i></button>
                                </div>
                        </div>
                    </div>
                </div>
                <!-- /.col -->
            </div>
            <!-- /.row -->
        </section>
        <!-- /.content -->
    </div>
    <footer class="main-footer">
        <!-- To the right -->
        <div class="float-right d-none d-sm-inline">
            Anything you want
        </div>
        <!-- Default to the left -->
        <strong>Copyright © 2014-2019 <a href="https://adminlte.io">AdminLTE.io</a>.</strong> All rights reserved.
    </footer>
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
                Bootstrap_paging(1,10)
            }
        };
        Bootstrap_paging(1,10)
        var nowPage=1;
        $("#queryBtn").click(function(){
            Bootstrap_paging(1,10)
        })
        function Bootstrap_paging(page,pageSize) {
            nowPage=page;
            $("#leftBtn").attr('disabled',false);
            $("#rightBtn").attr('disabled',false);
            var json = new Object();
            json.pageNumber = page;//页码
            json.pageSize = pageSize;//页面大小
            json.key=$("#inputBox").val();
            console.log(json)
            $.ajax({
                type: "GET",
                url: "<c:url value='/api/document/queryDocumentsByKey'/>",
                dataType: "json",
                data: json,
                beforeSend:function () {
                    $("#queryResult").html("\n" +
                        "                                <div class=\"text-center\">\n" +
                        "                                <i class=\"fa fa-spinner fa-pulse fa-3x fa-fw\"></i>\n" +
                        "                                <span class=\"sr-only\">Loading...</span>\n" +
                        "                                </div>")
                },
                success: function (data) {
                    //分页按钮
                    var allPage=Math.ceil(data.result.total/pageSize)>0?Math.ceil(data.result.total/pageSize):1;
                    $("#nowPage").text(page);
                    $("#allPage").text(allPage);
                    $("#totalRecord").text(data.result.total);
                    if(page==1){
                        $("#leftBtn").attr('disabled',true);
                    }
                    if(page==allPage){
                        $("#rightBtn").attr('disabled',true);
                    }
                    $("#queryResult").html("")
                    if (data.result.total == 0) {
                        $("#queryResult").html("<div class='paragraph'>暂无数据</div>")
                        return;
                    }
                    for (var i = 0; i < data.result.size; i++) {
                        var node = "<div class=\"paragraph\">\n" +
                            "<a target=\"_blank\" class='title' href='<c:url value="/render/toEditDocuments/"/>" + data.result.data[i].id + "'>" + data.result.data[i].docName + "</a>"+
                            "                                    <p>\n" +
                            "                                        <time class=\"time\">"+data.result.data[i].updateTime+"</time>\n" +
                            "                                        <span class=\"docContent\">"+data.result.data[i].docContent+"</span>\n" +
                            "                                    </p>\n" +
                            "                                    <p class=\"keyCount\">关键词出现次数："+data.result.data[i].wordAccount+"　　　文档ID："+data.result.data[i].id+"</p>\n" +
                            "                                </div>";
                        $("#queryResult").append(node);
                    }
                }
            });
        }
        $("#leftBtn").click(function(){
            Bootstrap_paging(nowPage-1,10);
        })
        $("#rightBtn").click(function(){
            Bootstrap_paging(nowPage+1,10);
        })
    });
</script>
<!-- AdminLTE for demo purposes -->
<script src="<c:url value="/dist/js/demo.js"/>"></script>
</body>
</html>

