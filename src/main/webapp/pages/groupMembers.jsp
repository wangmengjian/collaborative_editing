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
    <title>团队成员管理</title>
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

        #tableContent tr td {
            vertical-align: middle;
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
                <!-- /.col -->
                <div class="col-md-12">
                    <div class="card card-default">
                        <div class="card-header">
                            <a id="back"><i class="fa fa-fw fa-angle-left"></i>团队成员</a>
                        </div>
                        <!-- /.box-header -->
                        <div class="card-body p-0">
                            <div class="mailbox-controls">
                                <c:if test="${groupMembers.roleId==0||groupMembers.roleId==2}">
                                    <button type="button" class="btn btn-default btn-sm checkbox-toggle" title="全选"><i
                                            class="far fa-square"></i>
                                    </button>
                                    <div class="btn-group">
                                        <button type="button" class="btn btn-default btn-sm" id="deleteBtn" title="删除">
                                            <i
                                                    class="far fa-trash-alt"></i></button>
                                        <!-- /.btn-group -->
                                        <button type="button" class="btn btn-default btn-sm refresh" title="刷新"><i
                                                class="fas fa-sync-alt"></i></button>
                                        <button type="button" class="btn btn-default btn-sm addMemberBtn" title="新增成员">
                                            <i
                                                    class="fa fa-plus"></i></button>
                                    </div>
                                </c:if>
                                <c:if test="${groupMembers.roleId==1}">
                                    <button disabled type="button" class="btn btn-default btn-sm checkbox-toggle"><i
                                            class="far fa-square"></i>
                                    </button>
                                    <div class="btn-group">
                                        <button disabled type="button" class="btn btn-default btn-sm" id="deleteBtn"><i
                                                class="far fa-trash-alt"></i></button>
                                        <!-- /.btn-group -->
                                        <button type="button" class="btn btn-default btn-sm refresh"><i
                                                class="fas fa-sync-alt"></i></button>
                                        <button disabled type="button" class="btn btn-default btn-sm addMemberBtn"><i
                                                class="fa fa-plus"></i></button>
                                    </div>
                                </c:if>
                                <div class="float-right">
                                    总共 <span id="totalRecord"></span> 条记录
                                    当前页：<span id="nowPage"></span>/<span id="allPage"></span>
                                    <div class="btn-group">
                                        <button id="leftBtn" type="button" class="btn btn-default btn-sm"><i class="fas fa-chevron-left"></i></button>
                                        <button id="rightBtn" type="button" class="btn btn-default btn-sm"><i class="fas fa-chevron-right"></i></button>
                                    </div>
                                    <!-- /.btn-group -->
                                </div>
                                <!-- /.mail-box-messages -->
                            </div>

                            <div class="table-responsive mailbox-messages">
                                <table class="table table-hover table-striped">
                                    <thead>
                                    <tr>
                                        <th></th>
                                        <th>昵称</th>
                                        <th>真实姓名</th>
                                        <th>性别</th>
                                        <th>邮箱</th>
                                        <th>角色</th>
                                        <th>入队时间</th>
                                    </tr>
                                    </thead>
                                    <tbody id="tableContent">
                                    </tbody>
                                </table>
                                <!-- /.table -->
                            </div>
                        </div>
                    </div>
                    <!-- /.col -->
                </div>
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
    <div class="modal fade modal-warning" id="deleteDialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-body">
                    <h4 class="modal-title">确认将所选成员移除团队?</h4>
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

    <%--新增团队成员弹出框--%>
    <div class="modal fade" id="addMemberDialog">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">新增团队成员</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="input-group">
                        <input id="inputNickName" type="text" class="form-control" placeholder="请输入昵称">
                        <div class="input-group-append">
                            <button type="button" class="btn btn-primary" id="searchUserBtn">
                                <i class="fas fa-search"></i>
                            </button>
                        </div>
                    </div>
                    <table class="table">
                        <thead>
                        <th>昵称</th>
                        <th>真实姓名</th>
                        <th>性别</th>
                        <th>邮箱</th>
                        </thead>
                        <tbody id="searchMembersContent">
                        </tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default pull-left" data-dismiss="modal">关闭</button>
                    <button type="button" class="btn btn-primary" disabled="disabled" id="confirmAddBtn">确认添加</button>
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
<!-- Page Script -->
<script>
    $(function () {
        var groupId =${groupId};
        var userId = null;//userId为搜索到的用户id
        $(".addMemberBtn").click(function () {
            $("#addMemberDialog").modal('show');
        })
        $("#deleteBtn").click(function () {
            $("#deleteDialog").modal('show');
        })
        $("#back").click(function () {
            window.location.href = "<c:url value='/render/toGroupDocuments/'/>${groupId}";
        })
        /**
         * 搜索用户按钮
         */
        $("#searchUserBtn").click(function () {
            var nickName = $("#inputNickName").val();
            var json = new Object();
            json.nickName = nickName;
            $.ajax({
                type: "get",
                url: "<c:url value='/api/user/queryUserByNickName'/>",
                dataType: "json",
                data: json,
                success: function (data) {
                    if (data.status.code == 1 && data.result != null) {
                        $("#searchMembersContent").html("<tr>\n" +
                            "                            <td>" + data.result.nickName + "</td>\n" +
                            "                            <td>" + (data.result.trueName == null ? "" : data.result.trueName) + "</td>\n" +
                            "                            <td>" + (data.result.sex == null ? "" : data.result.sex) + "</td>\n" +
                            "                            <td>" + data.result.email + "</td>\n" +
                            "                        </tr>");
                        $("#confirmAddBtn").removeAttr("disabled");
                        userId = data.result.id;
                    } else {
                        $("#searchMembersContent").html("<tr style='display:none;'><td colspan='4'></td></tr><tr><td colspan='4'><p class='text-center' style='color:#777;'>请核对用户昵称</p></td></tr>")
                        $("#confirmAddBtn").attr("disabled", "disabled");
                    }
                },
                error: function () {
                    console.log("error")
                }
            })
        })
        /**
         * 确认添加按钮
         */
        $("#confirmAddBtn").click(function () {
            var json = new Object();
            json.groupId = groupId;
            json.userId = userId;
            $.ajax({
                type: "post",
                url: "<c:url value='/api/group/addMember'/>",
                dataType: "json",
                data: json,
                success: function (data) {
                    $("#addMemberDialog").modal('hide');
                    if (data.status.code == 1) {
                        $("#tipDialog .modal-title").text("添加成功");
                        $("#tipDialog").modal('show');
                        Bootstrap_paging(1,10);
                    } else {
                        $("#tipDialog .modal-title").text(data.status.message);
                        $("#tipDialog").modal('show');
                    }
                },
                error: function () {
                    console.log("error")
                }
            })
        })
        /*确认删除*/
        $("#confirmDeleteBtn").click(function () {
            var ids = "";
            $("#tableContent tr").each(function () {
                if ($(this).children("td").eq(0).children("div").children("input").prop("checked")) {
                    ids += $(this).attr("userId") + ",";
                }
            })
            if(ids==""){
                $("#deleteDialog").modal('hide');
                $("#tipDialog .modal-title").text("请选择删除对象");
                $("#tipDialog").modal('show');
            }
            ids = ids.substring(0, ids.length - 1);
            var json = {userIds: ids, groupId:${groupId}};
            console.log(json)
            $.ajax({
                type: "post",
                url: "<c:url value='/api/group/deleteMembers'/>",
                dataType: "json",
                data: json,
                success: function (data) {
                    $("#deleteDialog").modal('hide');
                    if (data.status.code == 1) {
                        $("#tipDialog .modal-title").text("删除成功");
                        $("#tipDialog").modal('show');
                        Bootstrap_paging(1,10);
                    } else {
                        $("#tipDialog .modal-title").text(data.status.message);
                        $("#tipDialog").modal('show');
                    }
                }
            })
        })

        /**
         *全选框
         */
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
        //刷新按钮
        $(".refresh").click(function () {
            Bootstrap_paging(1, 10)
        })
        //初始化
        Bootstrap_paging(1, 10)

        var nowPage;

        /**
         * 分页查询团队成员
         * @param page
         * @constructor
         */
        function Bootstrap_paging(page, pageSize) {
            nowPage = page;
            $("#leftBtn").attr('disabled', false);
            $("#rightBtn").attr('disabled', false);
            var json = new Object();
            json.pageNumber = page;//页码
            json.pageSize = pageSize;//页面大小
            json.groupId =${groupId};
            console.log(json)
            $.ajax({
                type: "GET",
                url: "<c:url value='/api/group/queryMembers'/>",
                dataType: "json",
                data: json,
                success: function (data) {
                    //分页按钮
                    var allPage=Math.ceil(data.result.total/pageSize)>0?Math.ceil(data.result.total/pageSize):1;
                    $("#nowPage").text(page);
                    $("#allPage").text(allPage);
                    $("#totalRecord").text(data.result.total);
                    if (page == 1) {
                        $("#leftBtn").attr('disabled', true);
                    }
                    if (page == allPage) {
                        $("#rightBtn").attr('disabled', true);
                    }
                    $("#tableContent").html("")
                    if (data.result.total == 0) {
                        $("#tableContent").html("<tr style='display:none;'><td colspan='7'></td></tr><tr><td colspan='7'><p class='text-center' style='color:#777;padding-top:20px;'>暂无数据</p></td></tr>")
                        return;
                    }

                    for (var i = 0; i < data.result.size; i++) {
                        var node1;
                        var userRole =${groupMembers.roleId};
                        if (userRole == 0 || userRole == 2) {//登录的用户为管理员，群主
                            if (data.result.data[i].roleId == '0') {
                                node1 = "<select userId='" + data.result.data[i].id + "' class=\"form-control roleSelect\" style='max-width:120px;'>\n" +
                                    "                    <option value='0' selected>管理员</option>\n" +
                                    "                    <option value='1'>普通成员</option>\n" +
                                    "                  </select>"
                            } else if (data.result.data[i].roleId == '1') {
                                node1 = "<select userId='" + data.result.data[i].id + "' class=\"form-control roleSelect\" style='max-width:120px;'>\n" +
                                    "                    <option value='0' >管理员</option>\n" +
                                    "                    <option value='1' selected>普通成员</option>\n" +
                                    "                  </select>"
                            } else {
                                node1 = "<select disabled class=\"form-control roleSelect\" style='max-width:120px;'>\n" +
                                    "                    <option selected>创建人</option>\n" +
                                    "                  </select>"
                            }
                        } else {//登录的用户为普通用户
                            if (data.result.data[i].roleId == '0') {//该成员为管理员
                                node1 = "<select userId='" + data.result.data[i].id + "' disabled class=\"form-control roleSelect\" style='max-width:120px;'>\n" +
                                    "                    <option value='0' selected>管理员</option>\n" +
                                    "                    <option value='1'>普通成员</option>\n" +
                                    "                  </select>"
                            } else if (data.result.data[i].roleId == '1') {//该成员为普通成员
                                node1 = "<select userId='" + data.result.data[i].id + "' disabled class=\"form-control roleSelect\" style='max-width:120px;'>\n" +
                                    "                    <option value='0' >管理员</option>\n" +
                                    "                    <option value='1' selected>普通成员</option>\n" +
                                    "                  </select>"
                            } else {
                                node1 = "<select disabled class=\"form-control roleSelect\" style='max-width:120px;'>\n" +
                                    "                    <option selected>创建人</option>\n" +
                                    "                  </select>"
                            }
                        }
                        var node2;
                        if (userRole == 0 || userRole == 2) {//登录的用户为管理员，群主
                            if (data.result.data[i].roleId == '2' || data.result.data[i].id ==${groupMembers.userId}) {
                                node2 = "<div class='icheck-primary' ><input disabled type=\"checkbox\" id='" + data.result.data[i].id + "'><label for='" + data.result.data[i].id + "'></label></div>";
                            } else {
                                node2 = "<div class='icheck-primary' ><input type=\"checkbox\" id='" + data.result.data[i].id + "'><label for='" + data.result.data[i].id + "'></label></div>";
                            }
                        } else {
                            node2 = "<input disabled type=\"checkbox\"/>";
                        }
                        var node = "<tr userId=" + data.result.data[i].id + ">" +
                            "                    <td>" + node2 + "</td>" +
                            "                    <td>" + data.result.data[i].nickName + "</a></td>" +
                            "                    <td>" + (data.result.data[i].trueName == null ? "" : data.result.data[i].trueName) + "</td>" +
                            "                    <td>" + (data.result.data[i].sex == null ? "" : data.result.data[i].sex) + "</td>" +
                            "                    <td>" + data.result.data[i].email + "</td>" +
                            "                    <td>" + node1 + "</td>" +
                            "                    <td>" + data.result.data[i].joinTime + "</td>" +
                            "                    </tr>";
                        $("#tableContent").append(node);
                    }
                    $(".roleSelect").change(function () {
                        var user_id = $(this).attr("userId");
                        var roleId = $(this).val();
                        var group_id =${groupId};
                        var json = new Object();
                        json.userId = user_id;
                        json.roleId = roleId;
                        json.groupId = group_id;
                        $.ajax({
                            type: "post",
                            url: "<c:url value='/api/group/updateMember'/>",
                            dataType: "json",
                            data: json,
                            success: function (data) {
                                if (data.status.code == 1) {
                                    $("#tipDialog .modal-title").text("角色更改成功");
                                    $("#tipDialog").modal('show');
                                    Bootstrap_paging(1,10);
                                } else {
                                    $("#tipDialog .modal-title").text(data.status.message);
                                    $("#tipDialog").modal('show');
                                }
                            }
                        })
                    })
                }
            });
        }

        $("#leftBtn").click(function () {
            Bootstrap_paging(nowPage - 1, 10);
        })
        $("#rightBtn").click(function () {
            Bootstrap_paging(nowPage + 1, 10);
        })
    });
</script>
<!-- AdminLTE for demo purposes -->
<script src="<c:url value="/dist/js/demo.js"/>"></script>
</body>
</html>

