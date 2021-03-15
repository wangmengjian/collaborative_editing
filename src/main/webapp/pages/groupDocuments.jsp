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
    <title>我的团队</title>
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
        #back:hover{
            cursor:pointer;
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
                <!-- /.col -->
                <div class="col-md-12">
                    <div class="card card-default">
                        <div class="card-header">
                            <a id="back"><i class="fa fa-fw fa-angle-left"></i>团队文档</a>
                        </div>
                        <!-- /.box-header -->
                        <div class="card-body p-0">
                            <div class="mailbox-controls">
                                <!-- Check all button -->
                                <button type="button" class="btn btn-default btn-sm checkbox-toggle" title="全选"><i
                                        class="far fa-square"></i>
                                </button>
                                <div class="btn-group">
                                <button type="button" class="btn btn-default btn-sm" id="deleteBtn" title="删除"><i
                                        class="far fa-trash-alt"></i></button>
                                <!-- /.btn-group -->
                                <button type="button" class="btn btn-default btn-sm refresh" title="刷新"><i
                                        class="fas fa-sync-alt"></i></button>
                                <button type="button" class="btn btn-default btn-sm addDocBtn" title="新增文档"><i
                                        class="fa fa-plus"></i></button>
                                <button type="button" class="btn btn-default btn-sm manageMembers" title="成员管理"><i class="fa fa-users"></i></button>
                                <button type="button" class="btn btn-default btn-sm groupConfig" title="团队设置"><i class="fa fa-cog"></i></button>
                                </div>
                                <div class="float-right">
                                    总共 <span id="totalRecord"></span> 条记录
                                    当前页：<span id="nowPage"></span>/<span id="allPage"></span>
                                    <div class="btn-group">
                                        <button id="leftBtn" type="button" class="btn btn-default btn-sm"><i class="fas fa-chevron-left"></i></button>
                                        <button id="rightBtn" type="button" class="btn btn-default btn-sm"><i class="fas fa-chevron-right"></i></button>
                                    </div>
                                    <!-- /.btn-group -->
                                </div>
                                <!-- /.pull-right -->
                            </div>
                            <div class="table-responsive mailbox-messages">
                                <table class="table table-hover">
                                    <thead>
                                    <tr>
                                        <th></th>
                                        <th>文档名称</th>
                                        <th>最近修改时间</th>
                                        <th>最近修改人</th>
                                        <th>上传时间</th>
                                        <th>上传人</th>
                                        <th>文档大小</th>
                                    </tr>
                                    </thead>
                                    <tbody id="tableContent">
                                    </tbody>
                                </table>
                                <!-- /.table -->
                            </div>
                            <!-- /.mail-box-messages -->
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
    <div class="modal fade" id="deleteDialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-body">
                    <h4 class="modal-title">确认删除所选文档?</h4>
                    <form id="deleteForm">
                        <input type="hidden" name="id"/>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline pull-left" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-outline" id="confirmDeleteBtn">确认删除</button>
                </div>
            </div>
            <!-- /.modal-content -->
        </div>
        <!-- /.modal-dialog -->
    </div>
</div>
<!-- ./wrapper -->
<div class="modal fade" id="tipDialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
                <h5 class="modal-title"></h5>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-dismiss="modal">确定</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- jQuery -->
<script src="<c:url value="/plugins/jquery/jquery.min.js"/>"></script>
<!-- Bootstrap 4 -->
<script src="<c:url value="/plugins/bootstrap/js/bootstrap.bundle.min.js"/>"></script>
<!-- AdminLTE App -->
<script src="<c:url value="/dist/js/adminlte.min.js"/>"></script>
<script>
    $(function () {
        $("#back").click(function(){
            window.location.href = "<c:url value="/render/toMyGroups"/>";
        })
        $("#deleteBtn").click(function () {
            $("#deleteDialog").modal('show');
        })
        /*确认删除*/
        $("#confirmDeleteBtn").click(function () {
            var ids = "";
            $("#tableContent tr").each(function () {
                if ($(this).children("td").eq(0).children("div").children("input").prop("checked")) {
                    ids += $(this).attr("documentId") + ",";
                }
            })
            if(ids==""){
                $("#deleteDialog").modal('hide');
                $("#tipDialog .modal-title").text("请选择删除对象");
                $("#tipDialog").modal('show');
            }
            ids = ids.substring(0, ids.length - 1);
            var json = {ids: ids};
            $.ajax({
                type: "post",
                url: "<c:url value='/api/document/deleteDocuments'/>",
                dataType: "json",
                data: json,
                success: function (data) {
                    $("#deleteDialog").modal('hide');
                    if (data.status.code == 1) {
                        $("#tipDialog .modal-title").text("删除成功")
                        Bootstrap_paging(1,10);
                    } else {
                        $("#tipDialog .modal-title").text(data.status.message)
                    }
                    $("#tipDialog").modal('show');
                }
            })
        })

        $(".addDocBtn").click(function () {
            window.location.href = "<c:url value='/render/toGroupAddDocuments/'/>${group.id}";
        })
        $(".manageMembers").click(function(){
            window.location.href = "<c:url value='/render/toGroupMembers/'/>${group.id}";
        })
        $(".groupConfig").click(function(){
            window.location.href = "<c:url value='/render/toGroupConfig/'/>${group.id}";
        })
        $('.checkbox-toggle').click(function () {
            var clicks = $(this).data('clicks')
            if (clicks) {
                //Uncheck all checkboxes
                $('.mailbox-messages input[type=\'checkbox\']').prop('checked', false)
                $('.checkbox-toggle .far.fa-check-square').removeClass('fa-check-square').addClass('fa-square')
            } else {
                //Check all checkboxes
                $('.mailbox-messages input[type=\'checkbox\']').prop('checked', true)
                $('.checkbox-toggle .far.fa-square').removeClass('fa-square').addClass('fa-check-square')
            }
            $(this).data('clicks', !clicks)
        })
        $(".refresh").click(function () {
            Bootstrap_paging(1,10)
        })
        Bootstrap_paging(1,10)
        var nowPage;
        function Bootstrap_paging(page,pageSize) {
            nowPage=page;
            $("#leftBtn").attr('disabled',false);
            $("#rightBtn").attr('disabled',false);
            var json = new Object();
            json.pageNumber = page;//页码
            json.pageSize = pageSize;//页面大小
            json.groupId=${group.id}
            console.log(json)
            $.ajax({
                type: "GET",
                url: "<c:url value='/api/group/queryGroupDocuments'/>",
                dataType: "json",
                data: json,
                beforeSend:function () {
                    $("#tableContent").html("\n" +
                        "                                    <tr>\n" +
                        "                                        <td colspan=\"7\">\n" +
                        "                                            <div class=\"text-center\">\n" +
                        "                                            <i class=\"fa fa-spinner fa-pulse fa-3x fa-fw\"></i>\n" +
                        "                                            <span class=\"sr-only\">Loading...</span>\n" +
                        "                                            </div>\n" +
                        "                                        </td>\n" +
                        "                                    </tr>")
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
                    $("#tableContent").html("")
                    if (data.result.total == 0) {
                        $("#tableContent").html("<tr style='display:none;'><td colspan='7'></td></tr><tr><td colspan='7'><p class='text-center' style='color:#777;padding-top:20px;'>暂无数据</p></td></tr>")
                        return;
                    }
                    for (var i = 0; i < data.result.size; i++) {
                        var doc_size;
                        if(data.result.data[i].docSize<1024){
                            doc_size=data.result.data[i].docSize;
                        }else{
                            doc_size=(data.result.data[i].docSize/1024).toFixed(1)+"K";
                        }
                        var node = "<tr documentId=" + data.result.data[i].id + ">" +
                            "                    <td><div class='icheck-primary' ><input type=\"checkbox\" id='" + data.result.data[i].id + "'><label for='" + data.result.data[i].id + "'></label></div></td>" +
                            "                    <td class='docName'><a target=\"_blank\" href='<c:url value="/render/toGroupEdit/"/>" + data.result.data[i].id + "'>" + data.result.data[i].docName + "</a></td>" +
                            "                    <td>" + data.result.data[i].updateTime + "</td>" +
                            "                    <td>" + data.result.data[i].recentUpdateUsername + "</td>" +
                            "                    <td>" + data.result.data[i].createTime + "</td>" +
                            "                    <td>" + data.result.data[i].createUsername + "</td>" +
                            "                    <td>" + doc_size + "B</td>" +
                            "                    </tr>";
                        $("#tableContent").append(node);
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

