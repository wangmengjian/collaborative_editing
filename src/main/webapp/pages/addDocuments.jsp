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
    <title>新增我的文档</title>
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
            height: 600px !important; /*!important是重点，因为原div是行内样式设置的高度300px*/
        }

        #back:hover {
            cursor: pointer;
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
                <div class="col-md-12">
                    <!-- /.box -->
                    <div class="card">
                        <div class="card-header">
                            <a id="back"><i class="fa fa-fw fa-angle-left"></i>新增文档</a>
                        </div>
                        <form>
                            <div class="card-body">
                                <div class="row">
                                    <div class="form-group col-md-6">
                                        <input type="text" class="form-control" placeholder="请输入标题"
                                               value=""
                                               name="docName">
                                    </div>
                                    <div class="form-group col-md-1 col-md-offset-5">
                                        <input type="button" class="form-control" id="save" value="保存">
                                    </div>
                                </div>
                                <div class="form-group" id="docContent">
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <!-- /.col-->
            </div>
            <!-- ./row -->
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
<!-- AdminLTE for demo purposes -->
<script src="<c:url value="/dist/js/demo.js"/>"></script>
<script src="<c:url value="/dist/js/wangEditor.js"/>"></script>
<script>
    $(function () {
        $("#back").click(function () {
            window.location.href = "<c:url value='/render/toMyDocuments'/>";
        })
        //bootstrap WYSIHTML5 - text editor
        var E = window.wangEditor
        var editor = new E('#docContent')
        // 或者 var editor = new E( document.getElementById('editor') )
        editor.create()
        var fileId;
        $("#save").click(function () {
            var docName = $("input[name='docName']").val();
            var docContent = editor.txt.html();
            if (docName == null || docName == "") {
                $("#tipDialog .modal-title").text("请输入文章标题");
                $("#tipDialog").modal('show');
                return;
            }
            if (docContent == null || docContent == "") {
                $("#tipDialog .modal-title").text("请输入文章内容");
                $("#tipDialog").modal('show');
                return;
            }
            if (fileId == null) {
                var json = {docName: docName, docContent: docContent};
                $.ajax({
                    type: "post",
                    url: "<c:url value='/api/document/addDocument'/>",
                    contentType: "application/x-www-form-urlencoded; charset=utf-8",
                    dataType: "json",
                    data: json,
                    success: function (data) {
                        if (data.status.code == 1) {
                            $("#tipDialog .modal-title").text("新增成功");
                            $("#tipDialog").modal('show');
                            fileId = data.result;
                        } else {
                            $("#tipDialog .modal-title").text(data.status.message);
                            $("#tipDialog").modal('show');
                        }
                    },
                    error: function () {
                        console.log("error");
                    }
                })
            } else {
                var json = {id: fileId, docName: docName, docContent: docContent};
                $.ajax({
                    type: "post",
                    url: "<c:url value='/api/document/editDocument'/>",
                    contentType: "application/x-www-form-urlencoded; charset=utf-8",
                    dataType: "json",
                    data: json,
                    success: function (data) {
                        if (data.status.code == 1) {
                            $("#tipDialog .modal-title").text("保存成功");
                            $("#tipDialog").modal('show');
                        } else {
                            $("#tipDialog .modal-title").text(data.status.message);
                            $("#tipDialog").modal('show');
                        }
                    },
                    error: function () {
                        console.log("error");
                    }
                })
            }

        })
    })
</script>
</body>
</html>

