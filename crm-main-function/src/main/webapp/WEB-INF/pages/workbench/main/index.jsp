<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    <style>
        div, #mypic{
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body>
<div><%--style="position: relative;top: -10px; left: -10px;  max-width: 100%; max-height:100%;"--%>
<img src="image/home.png" id="mypic"/>
</div>
</body>
</html>