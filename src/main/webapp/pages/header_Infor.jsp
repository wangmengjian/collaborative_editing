<%--
  Created by IntelliJ IDEA.
  User: micah
  Date: 2019/7/29
  Time: 19:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="main-header navbar navbar-expand-md navbar-light navbar-white">
    <a href="<c:url value="/render/toSearchIndex"/>" class="navbar-brand">
        <img src="<c:url value="/dist/img/AdminLTELogo.png"/>" alt="AdminLTE Logo" class="brand-image img-circle elevation-3"
             style="opacity: .8">
        <span class="brand-text font-weight-light">Cloud DOC</span>
    </a>
    <button class="navbar-toggler order-1" type="button" data-toggle="collapse" data-target="#navbarCollapse" aria-controls="navbarCollapse" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
    </button>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse order-3" id="navbarCollapse">

        <ul class="navbar-nav">
            <li class="nav-item dropdown">
                <a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown" aria-expanded="true">我的文档 <span class="caret"></span></a>
                <ul class="dropdown-menu border-0 shadow" role="menu">
                    <li><a class="dropdown-item" href="<c:url value="/render/toSearchIndex"/>">文档搜索</a></li>
                    <li class="dropdown-divider"></li>
                    <li><a class="dropdown-item" href="<c:url value="/render/toMyDocuments"/>">文档管理</a></li>
                </ul>
            </li>
            <li class="nav-item"><a class="nav-link" href="<c:url value="/render/toMyGroups"/>">我的团队</a></li>
            <li class="nav-item"><a class="nav-link" href="<c:url value="/render/toRecycle"/>">回收站</a></li>
        </ul>
    </div>
    <ul class="order-1 order-md-3 navbar-nav navbar-no-expand ml-auto">
        <!-- Notifications Dropdown Menu -->
        <li class="nav-item dropdown">
            <a class="nav-link" data-toggle="dropdown" href="#">
                <span>${sessionScope.USER_SESSION.nickName}</span>
            </a>
            <div class="dropdown-menu dropdown-menu-md-right dropdown-menu-right">
                <a href="<c:url value="/render/toInfor"/>" class="dropdown-item">
                    <i class="fas fa-user-alt mr-2"></i> 个人信息
                </a>
                <div class="dropdown-divider"></div>
                <a href="<c:url value="/api/common/login/outLogin"/>" class="dropdown-item">
                    <i class="fas fa-sign-out-alt mr-2"></i> 退出登录
                </a>
            </div>
        </li>
    </ul>
</nav>
