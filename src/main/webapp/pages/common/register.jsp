<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>欢迎注册云文档系统</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
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
  <style>
  </style>
</head>
<body class="hold-transition register-page">
<div class="register-box">
  <div class="register-logo">
    <a href="#"><b>Cloud</b>DOC</a>
  </div>
  <div class="card">
    <div class="card-body register-card-body">
      <p class="login-box-msg">注册账号</p>
      <form>
      <div class="form-group has-feedback">
        <input type="email" class="form-control" placeholder="邮箱" name="email">
        <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
      </div>
      <div class="form-group row">
        <div class="col-md-6">
          <input type="text" class="form-control" placeholder="验证码" name="code">
        </div>
        <div class="col-md-offset-1 col-md-5">
          <input type="button" id="sendCode" class="btn btn-primary btn-block" value="发送验证码"/>
        </div>
      </div>
      <div class="form-group has-feedback">
        <input type="text" class="form-control" placeholder="姓名" name="nickName">
        <span class="glyphicon glyphicon-user form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input type="password" class="form-control" placeholder="密码" name="password">
        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input type="password" class="form-control" placeholder="确认密码" name="confirmPassword">
        <span class="glyphicon glyphicon-log-in form-control-feedback"></span>
      </div>
      <div class="row">
        <div class="col-8">
          <div class="icheck-primary">
            <p class="mb-1">
              <a href="<c:url value="/render/common/toLogin"/>">已有账号？返回登陆</a>
            </p>
          </div>
        </div>
        <!-- /.col -->
        <div class="col-4">
          <button type="button" class="btn btn-primary btn-block" id="register">注册</button>
        </div>
        <!-- /.col -->
      </div>
    </form>
    </div>
  </div>
  <!-- /.form-box -->
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
<div class="modal fade" id="registerSuccessDialog">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
        <h5 class="modal-title">账号注册成功</h5>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-outline" data-dismiss="modal" id="registerSuccessDialogBtn">返回登录</button>
      </div>
    </div>
    <!-- /.modal-content -->
  </div>
  <!-- /.modal-dialog -->
</div>
<!-- /.register-box -->
<!-- jQuery -->
<script src="<c:url value="/plugins/jquery/jquery.min.js"/>"></script>
<!-- Bootstrap 4 -->
<script src="<c:url value="/plugins/bootstrap/js/bootstrap.bundle.min.js"/>"></script>
<!-- AdminLTE App -->
<script src="<c:url value="/dist/js/adminlte.min.js"/>"></script>
<script>
  $(function () {
    $("#password").keydown(function() {
      if (event.keyCode == "13") {//keyCode=13是回车键
        $('#register').click();
      }
    });
    //发送验证码
    $("#sendCode").click(function(){
      $.ajax({
        type: "GET",
        contentType:"application/x-www-form-urlencoded",
        url: "<c:url value='/api/common/register/isExistEmail'/>",
        data: {"email":$("input[name='email']").val()},
        dataType: "json",
        success:function(data) {
          if(data.result==false){
            $("#tipDialog .modal-title").text("邮箱已被注册！")
            $("#tipDialog").modal('show');
          }else{
            //发送激活码
            $.ajax({
              type: "GET",
              contentType:"application/x-www-form-urlencoded",
              url: "<c:url value='/api/common/register/sendVerificationCode'/>",
              data: {"email":$("input[name='email']").val()},
              dataType: "json",
              success:function(data) {
                if(data.status.code==1){
                  $("#tipDialog .modal-title").text("发送成功，请前往邮箱查看")
                }else{
                  $("#tipDialog .modal-title").text("发送失败")
                }
                $("#tipDialog").modal('show');
              },
              error:function(){
                console.log("发送失败");
              }
            })
          }
        },
        error:function(){
          console.log("发送失败");
        }
      })
    })
    $("#register").click(function(){
      var nickName=$("input[name='nickName']").val();
      var email=$("input[name='email']").val();
      var password=$("input[name='password']").val();
      var confirmPassword=$("input[name='confirmPassword']").val();
      if (nickName==null||nickName=="") {
        $("#tipDialog .modal-title").text("用户名不能为空！")
        $("#tipDialog").modal('show');
        return;
      }
      if (!email.match("^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$")) {
        $("#tipDialog .modal-title").text("邮箱格式错误！")
        $("#tipDialog").modal('show');
        return;
      }
      if(password!=confirmPassword){
        $("#tipDialog .modal-title").text("两次密码输入不一致！")
        $("#tipDialog").modal('show');
        return;
      }
      $.ajax({
        type: "post",
        contentType:"application/x-www-form-urlencoded",
        url: "<c:url value='/api/common/register/addUser'/>",
        data: {"nickName":nickName,"email":email,"code":$("input[name='code']").val(),"password":password},
        dataType: "json",
        success:function(data){
          if(data.status.code==1){
            $("#registerSuccessDialog").modal('show');
            return;
          }else{
            $("#tipDialog .modal-title").text(data.status.message)
            $("#tipDialog").modal('show');
          }
        }
      })

    })
    $("#registerSuccessDialogBtn").click(function(){
      window.location.href="<c:url value='/render/common/toLogin'/>";
    })
  });
</script>
</body>
</html>
