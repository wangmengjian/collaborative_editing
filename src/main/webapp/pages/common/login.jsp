<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>欢迎登录云文档系统</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <!-- Font Awesome -->
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

<body class="hold-transition login-page">
<div class="login-box">
    <div class="login-logo">
        <a href="#"><b>Cloud</b>DOC</a>
    </div>
    <!-- /.login-logo -->
    <div class="card">
        <div class="card-body login-card-body" style="">
            <p class="login-box-msg">登录</p>
            <form>
                <div class="input-group mb-3">
                    <input type="email" id="email" class="form-control" placeholder="邮箱">
                    <div class="input-group-append">
                        <div class="input-group-text">
                            <span class="fas fa-envelope"></span>
                        </div>
                    </div>
                </div>
                <div class="input-group mb-3">
                    <input type="password" id="password" class="form-control" placeholder="密码">
                    <div class="input-group-append">
                        <div class="input-group-text">
                            <span class="fas fa-lock"></span>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-8">
                        <div class="icheck-primary">
                            <p class="mb-1">
                                <a href="<c:url value="/render/common/toRegister"/>">注册账号</a>
                            </p>
                        </div>
                    </div>
                    <!-- /.col -->
                    <div class="col-4">
                        <button type="button" id="login_button" class="btn btn-primary btn-block">登录</button>
                    </div>
                    <!-- /.col -->
                </div>
            </form>

        </div>
        <!-- /.login-card-body -->
    </div>
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
<!-- /.login-box -->
<!-- jQuery -->
<script src="<c:url value="/plugins/jquery/jquery.min.js"/>"></script>
<!-- Bootstrap 4 -->
<script src="<c:url value="/plugins/bootstrap/js/bootstrap.bundle.min.js"/>"></script>
<!-- AdminLTE App -->
<script src="<c:url value="/dist/js/adminlte.min.js"/>"></script>
<script>
    $(function () {
        $("#password").keydown(function () {
            if (event.keyCode == "13") {//keyCode=13是回车键
                $('#login_button').click();
            }
        });

        $("#login_button").click(function () {
            var email = $("#email").val();
            var password = $("#password").val();
            if (email == null || email == "" || password == null || password == "") {
                $("#tipDialog .modal-title").text("邮箱和密码不能为空！")
                $("#tipDialog").modal('show');
                return;
            }
            $.ajax({
                type: "POST",
                contentType: "application/x-www-form-urlencoded",
                url: "<c:url value="/api/common/login/login"/>",
                data: {"email": $("#email").val(), "password": $("#password").val()},
                dataType: "json",
                success: function (data) {
                    if (data.status.code == 1) {
                        window.location.href = "<c:url value='/render/toSearchIndex'/>";
                    } else {
                        $("#tipDialog .modal-title").text("邮箱或密码输入错误！")
                        $("#tipDialog").modal('show');
                    }
                },
                error: function () {
                    console.log("发送失败")
                }
            });
        })

    });
</script>
</body>
</html>
