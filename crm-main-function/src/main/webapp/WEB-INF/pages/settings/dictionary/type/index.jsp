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
            //全选/全不选功能
            $("thead input[type='checkbox']").click(function () {
                $("tbody input[type='checkbox']").prop("checked", this.checked);
            });
            $("tbody input[type='checkbox']").click(function () {
                $("thead input[type='checkbox']").prop("checked",
                    $("tbody input[type='checkbox']:checked").size() == $("tbody input[type='checkbox']").size());
            });

            //删除数据字典类型
            $("#deleteBtn").click(function () {
                var $checkedDom = $("tbody input[type='checkbox']:checked");
                if ($checkedDom.size() == 0) {
                    alert("每次至少删除一条记录");
                    return;
                }
                if (!window.confirm("确认删除?")) {
                    return;
                }
                var param = "";
                $checkedDom.each(function () {
                    param += "code=" + this.value + "&";
                });
                param = param.substr(0, param.length - 1);
                $.ajax({
                    url: "settings/dictionary/type/deleteDicTypeByCodes.do",
                    data: param,
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //使用js删除, 代替刷新页面
                            $checkedDom.each(function () {
                                $("#tr_" + this.value).remove();
                            });
                        } else {
                            alert(resp.msg);
                        }
                    }
                });
            });
            //"编辑"按钮单击事件
            $("#editBtn").click(function () {
                var $checkDom = $("tbody input[type='checkbox']:checked");
                if ($checkDom.size() == 0) {
                    alert("请选择一条记录进行修改");
                    return;
                }
                if ($checkDom.size() > 1) {
                    alert("每次只能修改一条数据, 请检查");
                    return;
                }

                var code = $checkDom.val();
                window.location.href = "settings/dictionary/type/toEdit.do?code=" + code;
            });
        });
    </script>
</head>
<body>

<div>
    <div style="position: relative; left: 30px; top: -10px;">
        <div class="page-header">
            <h3>字典类型列表</h3>
        </div>
    </div>
</div>
<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
    <div class="btn-group" style="position: relative; top: 18%;">
        <button type="button" class="btn btn-primary"
                onclick="window.location.href='settings/dictionary/type/toSave.do'"><span
                class="glyphicon glyphicon-plus"></span> 创建
        </button>
        <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑
        </button>
        <button type="button" class="btn btn-danger" id="deleteBtn"><span class="glyphicon glyphicon-minus"></span> 删除
        </button>
    </div>
</div>
<div style="position: relative; left: 30px; top: 20px;">
    <table class="table table-hover">
        <thead>
        <tr style="color: #B3B3B3;">
            <td><input type="checkbox"/></td>
            <td>序号</td>
            <td>编码</td>
            <td>名称</td>
            <td>描述</td>
        </tr>
        </thead>
        <tbody>
        <%--<tr class="active">
            <td><input type="checkbox" /></td>
            <td>1</td>
            <td>sex</td>
            <td>性别</td>
            <td>性别包括男和女</td>
        </tr>--%>
        <c:forEach items="${dicTypeList}" var="dicType" varStatus="vs">
            <tr class="active" id="tr_${dicType.code}">
                <td><input type="checkbox" value="${dicType.code}"/></td>
                <td>${vs.count}</td>
                <td>${dicType.code}</td>
                <td>${dicType.name}</td>
                <td>${dicType.description}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

</body>
</html>