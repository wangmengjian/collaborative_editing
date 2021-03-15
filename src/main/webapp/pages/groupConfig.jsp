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
    <title>团队配置</title>
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
                            <a id="back"><i class="fa fa-fw fa-angle-left"></i>团队设置</a>
                        </div>
                        <!-- /.box-header -->
                        <form  role="form">
                        <div class="card-body row">
                            <div class="col-md-6 col-md-offset-1">
                                <!-- text input -->
                                <div class="form-group">
                                    <label>团队名称：</label>
                                    <input type="text" class="form-control" placeholder="Enter ..." value="${group.groupName}" name="groupName"/>
                                </div>
                                <div class="form-group">
                                    <label>团队描述：</label>
                                    <textarea class="form-control" rows="3" placeholder="Enter ..." name="groupDescription">${group.groupDescription}</textarea>
                                </div>

                                <!-- textarea -->
                                <div class="form-group">
                                    <label>创建人：</label>
                                    <input disabled type="text" class="form-control" placeholder="Enter ..." value="${group.createUsername}"/>
                                </div>
                                <div class="form-group">
                                    <label>创建时间：</label>
                                    <input disabled type="text" class="form-control" placeholder="Enter ..." value="${group.createTime}"/>
                                </div>
                            </div>
                        </div>
                        <!-- /.box-body -->
                        <div class="card-footer">
                            <c:if test="${groupMembers.roleId==0||groupMembers.roleId==1}">
                            <div class="col-md-6 col-md-offset-1" style="padding-left:0px;">
                                <button type="button" class="btn btn-primary saveGroupInf">保存</button>
                                <button type="button" class="btn btn-danger pull-right exitGroup">退出团队</button>
                            </div>
                            </c:if>
                            <c:if test="${groupMembers.roleId==2}">
                                <div class="col-md-6 col-md-offset-1" style="padding-left:0px;">
                                    <button type="button" class="btn btn-primary saveGroupInf">保存</button>
                                    <button type="button" class="btn btn-danger pull-right deleteGroup">删除团队</button>
                                </div>
                            </c:if>
                        </div>
                        </form>
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
        //保存团队信息
        $(".saveGroupInf").click(function(){
            var groupName=$("input[name='groupName']").val();
            var groupDescription=$("textarea[name='groupDescription']").val();
            if(groupName==null||groupName==""){
                $("#tipDialog .modal-title").text("团队名称不能为空")
                $("#tipDialog").modal('show');
                return;
            }
            var json={"groupName":groupName,"groupDescription":groupDescription,"id":${group.id}};
            $.ajax({
                type: "post",
                url: "<c:url value='/api/group/updateGroup'/>",
                dataType: "json",
                data: json,
                success: function (data) {
                    if (data.status.code == 1) {
                        $("#tipDialog .modal-title").text("信息更改成功");
                    } else {
                        $("#tipDialog .modal-title").text(data.status.message)
                    }
                    $("#tipDialog").modal('show');
                }
            })
        })
        //删除团队按钮事件
        $(".deleteGroup").click(function(){
            var json={"groupId":${group.id}};
            $.ajax({
                type: "post",
                url: "<c:url value='/api/group/deleteGroup'/>",
                dataType: "json",
                data: json,
                success: function (data) {
                    if (data.status.code == 1) {
                        $("#tipDialog .modal-title").text("成功删除团队");
                        window.location.href = "<c:url value='/render/toMyGroups'/>";
                    } else {
                        $("#tipDialog .modal-title").text(data.status.message)
                    }
                    $("#tipDialog").modal('show');
                }
            })
        })
        //退出团队按钮事件
        $(".exitGroup").click(function(){
            var json={"groupId":${group.id},"userId":${sessionScope.USER_SESSION.id}};
            $.ajax({
                type: "post",
                url: "<c:url value='/api/group/exitGroup'/>",
                dataType: "json",
                data: json,
                success: function (data) {
                    if (data.status.code == 1) {
                        $("#tipDialog .modal-title").text("成功退出团队");
                        window.location.href = "<c:url value='/render/toMyGroups'/>";
                    } else {
                        $("#tipDialog .modal-title").text(data.status.message)
                    }
                    $("#tipDialog").modal('show');
                }
            })
        })
        $("#back").click(function(){
            window.location.href = "<c:url value='/render/toGroupDocuments/'/>${group.id}";
        })
    });
</script>
<!-- AdminLTE for demo purposes -->
<script src="<c:url value="/dist/js/demo.js"/>"></script>
</body>
</html>

