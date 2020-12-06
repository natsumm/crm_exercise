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
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $("#code").keyup(function () {
                var code = $.trim(this.value);
                $.ajax({
                    url: "settings/dictionary/type/queryDicTypeByCode.do",
                    data: {
                        code: code
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            $("#repeatFlag").html("*");
                            $("#saveCreateBtn").removeAttr("disabled");
                        } else {
                            $("#repeatFlag").html(resp.msg);
                            $("#saveCreateBtn").attr("disabled", "disabled");
                        }
                    },
                    before: function () {
                        if (code == "") {
                            $("#repeatFlag").html("*");
                            return false;
                        }
                        $("#repeatFlag").html("正在查询是否重复..");
                        return true;
                    }
                });
            });

            $("#saveCreateBtn").click(function () {
                var code = $.trim($("#code").val());
                var name = $.trim($("#name").val());
                var description = $.trim($("#description").val());
                if (code == "") {
                    alert("编码不能为空");
                    return;
                }
                $.ajax({
                    url: "settings/dictionary/type/saveCreateDicType.do",
                    data: {
                        code: code,
                        name: name,
                        description: description
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //跳转页面
                            window.location.href = "settings/dictionary/type/toIndex.do";
                        } else {
                            alert(resp.msg);
                        }
                    }
                });
            });
        })
    </script>
</head>
<body>

<div style="position:  relative; left: 30px;">
    <h3>新增字典类型</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary" id="saveCreateBtn">保存</button>
        <button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form">

    <div class="form-group">
        <label for="code" class="col-sm-2 control-label">编码</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="code" style="width: 200%;">
            <span style="font-size: 15px; color: red;" id="repeatFlag">*</span>
        </div>
    </div>

    <div class="form-group">
        <label for="name" class="col-sm-2 control-label">名称</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="name" style="width: 200%;">
        </div>
    </div>

    <div class="form-group">
        <label for="description" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 300px;">
            <textarea class="form-control" rows="3" id="description" style="width: 200%;"></textarea>
        </div>
    </div>
</form>

<div style="height: 200px;"></div>
</body>
</html>