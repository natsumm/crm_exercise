<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName()
            + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <base href="<%=basePath%>"/>
    <meta charset="UTF-8">
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        $(function () {
            //登录按钮的单击事件
            $("#loginBtn").click(function () {

                //检查参数
                var loginAct = $.trim($("#loginAct").val());
                var loginPwd = $.trim($("#loginPwd").val());
                var isRemPwd = $("#isRemPwd").prop("checked");

                if (loginAct == "" || loginPwd == "") {
                    $("#msg").html("用户名和密码均不能为空");
                    return;
                }
                $.ajax({
                    url: "settings/qx/user/login.do",
                    data: {
                        loginAct: loginAct,
                        loginPwd: loginPwd,
                        isRemPwd: isRemPwd
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //登录成功, 跳转页面
                            window.location.href = "workbench/toIndex.do";
                        } else {
                            //登录失败, 提示信息
                            $("#msg").html(resp.msg);
                        }
                    },
                    before: function () {
                        $("#msg").html("正在努力验证...");
                    }
                });
            });
            //回车登录
            $(window).keyup(function (event) {
                if (event.keyCode == 13) $("#loginBtn").click();
            })
        });
    </script>
</head>
<body>
<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
    <img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
</div>
<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
    <div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">
        CRM &nbsp;<span style="font-size: 12px;">&copy;2019&nbsp;动力节点</span></div>
</div>

<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
    <div style="position: absolute; top: 0px; right: 60px;">
        <div class="page-header">
            <h1>登录</h1>
        </div>
        <form action="workbench/index.html" class="form-horizontal" role="form">
            <div class="form-group form-group-lg">
                <div style="width: 350px;">
                    <input class="form-control" type="text" placeholder="用户名" id="loginAct"
                           value="${cookie.loginAct.value}">
                </div>
                <div style="width: 350px; position: relative;top: 20px;">
                    <input class="form-control" type="password" placeholder="密码" id="loginPwd"
                           value="${cookie.loginPwd.value}">
                </div>
                <div class="checkbox" style="position: relative;top: 30px; left: 10px;">
                    <label>
                        <c:if test="${not empty cookie.loginAct.value and not empty cookie.loginPwd.value}">
                            <input type="checkbox" id="isRemPwd" checked>
                        </c:if>
                        <c:if test="${empty cookie.loginAct.value or empty cookie.loginPwd.value}">
                            <input type="checkbox" id="isRemPwd">
                        </c:if>
                        记住密码
                    </label>
                    &nbsp;&nbsp;
                    <span id="msg" style="color:red"></span>
                </div>
                <button type="button" class="btn btn-primary btn-lg btn-block"
                        style="width: 350px; position: relative;top: 45px;" id="loginBtn">登录
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>