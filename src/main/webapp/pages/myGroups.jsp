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
        .groupDescription {
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        #tableContent tr td{
            vertical-align:middle;
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
            <div class="card card-default card-outline">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-edit"></i>
                        团队管理
                    </h3>
                </div>
                <div class="card-body">
                    <div class="row">
                        <div class="col-5 col-sm-3">
                            <div class="nav flex-column nav-tabs h-100" id="vert-tabs-tab" role="tablist" aria-orientation="vertical">
                                <a class="nav-link active" id="vert-tabs-table-tab" data-toggle="pill" href="#vert-tabs-profile" role="tab" aria-controls="vert-tabs-profile" aria-selected="false">所有团队</a>
                                <a class="nav-link " id="vert-tabs-home-tab" data-toggle="pill" href="#vert-tabs-home" role="tab" aria-controls="vert-tabs-home" aria-selected="true">新增团队</a>
                            </div>
                        </div>
                        <div class="col-7 col-sm-9">
                            <div class="tab-content" id="vert-tabs-tabContent">
                                <div class="tab-pane fade " id="vert-tabs-home" role="tabpanel" aria-labelledby="vert-tabs-home-tab">
                                    <div class="card card-default" id="newGroupTap">
                                        <div class="card-header">
                                            <h3 class="card-title">创建团队</h3>
                                        </div>
                                        <!-- /.box-header -->
                                        <!-- form start -->
                                            <div class="card-body">
                                                <div class="form-group">
                                                    <label for="exampleInputEmail1">团队名称</label>
                                                    <input type="email" class="form-control" id="exampleInputEmail1" name="groupName" placeholder="">
                                                </div>
                                                <div class="form-group">
                                                    <label for="exampleInputPassword1">团队描述</label>
                                                    <textarea type="password" class="form-control" rows="3" id="exampleInputPassword1" name="groupDescription"></textarea>
                                                </div>
                                            </div>

                                            <div class="card-footer">
                                                <button type="button" id="addGroupBtn" class="btn btn-primary">新建团队</button>
                                            </div>
                                    </div>
                                </div>
                                <div class="tab-pane fade show active" id="vert-tabs-profile" role="tabpanel" aria-labelledby="vert-tabs-table-tab">

                                    <div class="card card-default" id="queryGroupTap">
                                        <div class="card-header">
                                            <h3 id="groupType" class="card-title">所有团队</h3>
                                        </div>
                                        <div class="card-body p-0">
                                            <div class="table-responsive mailbox-messages">
                                                <table class="table table-hover">
                                                    <thead>
                                                    <tr>
                                                        <th>团队名称</th>
                                                        <th>团队描述</th>
                                                        <th>创建人</th>
                                                        <th>创建时间</th>
                                                    </tr>
                                                    </thead>
                                                    <tbody id="tableContent">
                                                    </tbody>
                                                </table>
                                                <!-- /.table -->
                                            </div>
                                            <!-- /.mail-box-messages -->
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
                            </div>
                        </div>
                    </div>
                </div>
                <!-- /.card -->
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
<!-- Page Script -->
<script>
    $(function () {
        $("#addGroupBtn").click(function(){
            var groupName=$("input[name='groupName']").val();
            var groupDescription=$("textarea[name='groupDescription']").val();
            if(groupName==null||groupName==""){
                $("#tipDialog .modal-title").text("团队名称不能为空");
                $("#tipDialog").modal('show');
                return;
            }
            var json={"groupName":groupName,"groupDescription":groupDescription};
            $.ajax({
                type: "post",
                url: "<c:url value='/api/group/addGroup'/>",
                dataType: "json",
                data: json,
                success: function (data) {
                    if (data.status.code == 1) {
                        $("#tipDialog .modal-title").text("创建成功");
                        $("#tipDialog").modal('show');
                        Bootstrap_paging(1,0,10);
                    } else {
                        $("#tipDialog .modal-title").text("data.status.message");
                        $("#tipDialog").modal('show');
                    }
                }
            })
        })

        Bootstrap_paging(1,0,10);
        var nowPage;
        function Bootstrap_paging(page,status,pageSize) {
            nowPage=page;
            $("#leftBtn").attr('disabled',false);
            $("#rightBtn").attr('disabled',false);
            $(".checkbox-toggle").data("clicks", false);
            $(".checkbox-toggle i").removeClass("fa-check-square-o").addClass('fa-square-o');
            var json = new Object();
            json.pageNumber = page;//页码
            json.pageSize = pageSize;//页面大小
            json.status=status;
            console.log(json)
            var url;
            $.ajax({
                type: "GET",
                url: "<c:url value='/api/group/queryGroup'/>",
                dataType: "json",
                data: json,
                beforeSend:function () {
                    $("#tableContent").html("\n" +
                        "                                    <tr>\n" +
                        "                                        <td colspan=\"4\">\n" +
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
                        $("#tableContent").html("<tr style='display:none;'><td colspan='4'></td></tr><tr><td colspan='4'><p class='text-center' style='color:#777;padding-top:20px;'>暂无团队</p></td></tr>")
                        return;
                    }
                    for (var i = 0; i < data.result.size; i++) {
                        var node = "<tr groupId=" + data.result.data[i].id + ">" +
                            "                    <td><a href='<c:url value="/render/toGroupDocuments/"/>" + data.result.data[i].id + "'>" + data.result.data[i].groupName + "</a></td>" +
                            "                    <td class='groupDescription'>" + (data.result.data[i].groupDescription==null?"无":data.result.data[i].groupDescription) + "</td>" +
                            "                    <td>" + data.result.data[i].createUsername+ "</td>" +
                            "                    <td>" + data.result.data[i].createTime + "</td>" +
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

