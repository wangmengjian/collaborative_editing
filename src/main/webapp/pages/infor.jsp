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
    <title>个人信息</title>
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
</head>
<body class="hold-transition skin-blue layout-top-nav">
<div class="wrapper" style="background-color:white;">

    <jsp:include page="header_Infor.jsp"/>
    <section class="content" style="margin-top:15px;">
        <div class="container-fluid">
            <div class="row">
                <!-- left column -->
                <div class="col-md-6">
                    <!-- jquery validation -->
                    <div class="card card-default">
                        <div class="card-header">
                            <h3 class="card-title">个人信息</h3>
                        </div>
                        <!-- /.card-header -->
                        <!-- form start -->
                        <form role="form" id="quickForm">
                            <div class="card-body">
                                <div class="form-group">
                                    <label for="email">电子邮件</label>
                                    <input disabled value="${sessionScope.USER_SESSION.email}" type="email" name="email" class="form-control" id="email" placeholder="enter email">
                                </div>
                                <div class="form-group">
                                    <label for="nickName">昵称</label>
                                    <input type="text" value="${sessionScope.USER_SESSION.nickName}" name="nickName" class="form-control" id="nickName" placeholder="enter nickName">
                                </div>
                                <div class="form-group">
                                    <label for="password">登录密码</label>
                                    <input type="password" name="password" class="form-control" id="password" placeholder="Password">
                                </div>
                                <div class="form-group">
                                    <label for="password1">确认密码</label>
                                    <input type="password" name="password1" class="form-control" id="password1" placeholder="confirm Password">
                                </div>
                            </div>
                            <!-- /.card-body -->
                            <div class="card-footer">
                                <button type="submit" class="btn btn-primary" id="confirmUpdateBtn">确认修改</button>
                            </div>
                        </form>
                    </div>
                    <!-- /.card -->
                </div>
            </div>
            <!-- /.row -->
        </div><!-- /.container-fluid -->
    </section>

</div>
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
<div class="modal fade" id="successUpdateDialog">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-body">
                <h5 class="modal-title"></h5>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" data-dismiss="modal" id="confirmUpdateDialogBtn">确定</button>
            </div>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<!-- ./wrapper -->
<!-- jQuery -->
<script src="<c:url value="/plugins/jquery/jquery.min.js"/>"></script>
<!-- Bootstrap 4 -->
<script src="<c:url value="/plugins/bootstrap/js/bootstrap.bundle.min.js"/>"></script>
<!-- AdminLTE App -->
<script src="<c:url value="/dist/js/adminlte.min.js"/>"></script>
<script type="text/javascript" src="<c:url value='/dist/js/bootstrap-paginator.js'/>"></script>
<!-- AdminLTE for demo purposes -->
<script src="<c:url value="/dist/js/demo.js"/>"></script>
<script src="<c:url value="/plugins/jquery-validation/jquery.validate.min.js"/>"></script>
<script src="<c:url value="/plugins/jquery-validation/additional-methods.min.js"/>"></script>
<!-- Page Script -->
<script>
    $(function () {
        $("#confirmUpdateDialogBtn").click(function(){
            window.location.href = "<c:url value="/api/common/login/outLogin"/>";
        })
        $.validator.setDefaults({
            submitHandler: function () {
                var email=$("input[name='email']").val();
                var nickName=$("input[name='nickName']").val();
                var password=$("#password").val();
                var password1=$("#password1").val();
                var json=new Object();
                json.email=email;
                json.nickName=nickName;
                json.password=password;
                console.log(json);
                $.ajax({
                    type:"post",
                    url:"<c:url value="/api/user/updateUserInfor"/>",
                    dataType:"json",
                    data:json,
                    success:function(data){
                        if (data.status.code == 1) {
                            $("#successUpdateDialog .modal-title").text("信息更改成功");
                            $("#successUpdateDialog").modal('show');
                        } else {
                            $("#tipDialog .modal-title").text(data.status.message);
                            $("#tipDialog").modal('show');
                        }
                    },
                    error:function(){
                        console.log("更改失败");
                    }
                })
            }
        });
        $('#quickForm').validate({
            rules: {
                password: {
                    required: true,
                    minlength: 5
                },
                password1: {
                    required: true,
                    equalTo: "#password"
                },
                nickName:{
                    required: true,
                    minlength: 1
                }
            },
            messages: {
                password: {
                    required: "请输入密码",
                    minlength: "密码至少5个字符"
                },
                password1: {
                    required: "请重新输入密码",
                    equalTo: "两次密码输入不一致"
                },
                nickName:{
                    required: "请输入昵称",
                    minlength: "昵称不能为空"
                }
            },
            errorElement: 'span',
            errorPlacement: function (error, element) {
                error.addClass('invalid-feedback');
                element.closest('.form-group').append(error);
            },
            highlight: function (element, errorClass, validClass) {
                $(element).addClass('is-invalid');
            },
            unhighlight: function (element, errorClass, validClass) {
                $(element).removeClass('is-invalid');
            }
        });
    });
</script>
</body>
</html>

