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
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>

    <%--引入bs_typehead--%>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">
        $(function () {
            //-----------------------------------------------
            //切记事件绑定要放在入口函数中
            $(".myDate").datetimepicker({ //日历
                language: "zh-CN",
                format: "yyyy-mm-dd",
                minView: "month",
                initialDate: new Date(),
                todayBtn: true,
                clearBtn: true,
                autoclose: true,
                todayHighlight: true,
                pickerPosition: "top-right"
            });
            //-----------------------------------------------
            //查找市场活动图标的单击事件 --> 初始化完成后, 弹出模态窗口
            $("#queryActivityA").click(function () {
                //初始化, 清空输入框, 清空表格内容
                $("#queryActivityName").val("");
                $("#queryActivityResTbody").empty();
                //弹出模态窗口
                $("#findMarketActivity").modal("show");
            });
            //市场活动名称搜索框的键盘弹起事件
            $("#queryActivityName").keyup(function () {
                var activityName = this.value;
                $.ajax({
                    url: "workbench/transaction/queryActivityByName.do",
                    data: {
                        activityName: activityName
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        //拼接字符串
                        var htmlStr = "";
                        $.each(resp, function (index, element) {
                            htmlStr += "<tr>";
                            htmlStr += "<td><input type=\"radio\" name=\"activity\" value=\"" + element.id + "\" activityName=\"" + element.name + "\"/></td>";
                            htmlStr += "<td>" + element.name + "</td>";
                            htmlStr += "<td>" + element.startDate + "</td>";
                            htmlStr += "<td>" + element.endDate + "</td>";
                            htmlStr += "<td>" + element.owner + "</td>";
                            htmlStr += "</tr>";
                        });
                        $("#queryActivityResTbody").html(htmlStr);
                    }
                });
            });

            //-----------------------------------------------
            //市场活动表格的单选按钮单击事件--> 将activityId放入隐藏域, 将activityName放入输入框, 关闭模态窗口
            //$("#queryActivityResTbody input[type='radio']").click(function () { //这里绑定事件应当使用on的方式, input标签不是固有元素, 是动态生成的元素
            $("#queryActivityResTbody").on("click", "input[type='radio']", function () {
                $("#create-activityId").val(this.value);
                $("#create-activityName").val($(this).attr("activityName"));
                $("#findMarketActivity").modal("hide");
            });

            //-----------------------------------------------
            //联系人的搜索按钮单击事件, --> 初始化完成后, 弹出模态窗口
            $("#queryContactsA").click(function () {
                //初始化
                $("#queryContactsName").val("");
                $("#queryContactsResTbody").empty();
                //弹出模态窗口
                $("#findContacts").modal("show");
            });
            //联系人搜索框键盘弹起事件
            $("#queryContactsName").keyup(function () {
                var contactsName = this.value;
                $.ajax({
                    url: "workbench/transaction/queryContactsByFullname.do",
                    data: {
                        contactsName: contactsName
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        var htmlStr = "";
                        $.each(resp, function () {
                            htmlStr += "<tr>";
                            htmlStr += "<td><input type=\"radio\" value=\"" + this.id + "\" contactsName=\"" + this.fullname + "\" name=\"activity\"/></td>";
                            htmlStr += "<td>" + this.fullname + "</td>";
                            htmlStr += "<td>" + this.email + "</td>";
                            htmlStr += "<td>" + this.mphone + "</td>";
                            htmlStr += "</tr>";
                        });
                        $("#queryContactsResTbody").html(htmlStr);
                    }
                });
            });
            //联系人表格单选按钮单击事件, --> 将contactsId放入隐藏域, contactsNam放入输入框中, 关闭模态窗口
            $("#queryContactsResTbody").on("click", "input[type='radio']", function () {
                var contactsId = this.value;
                var contactsName = $(this).attr("contactsName");
                $("#create-contactsId").val(contactsId);
                $("#create-contactsName").val(contactsName);
                $("#findContacts").modal("hide");
            });
            //-----------------------------------------------
            //客户名称自动补全
            $("#create-customerName").typeahead({
                source: function (query, process) {
                    var customerName = $.trim(query);
                    $.ajax({
                        url: "workbench/transaction/queryCustomerByName.do",
                        data: {
                            customerName: customerName
                        },
                        type: "post",
                        dataType: "json",
                        success: function (resp) {
                            process(resp);
                        }
                    });
                },
                updater: function (item) {
                    //客户id赋值到隐藏域
                    $("#create-customerId").val(item.id);
                    //客户名称显示到输入框, 直接return即可, 不需要再另外赋值, 这个函数的返回值就是最终显示到输入框中的内容
                    //$("#create-customerName").val(item.name);
                    return item.name;
                }
            });
        });
    </script>
</head>
<body>

<!-- 查找市场活动模态窗口 -->
<div class="modal fade" id="findMarketActivity" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找市场活动</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="queryActivityName" class="form-control" style="width: 300px;"
                                   placeholder="请输入市场活动名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable3" class="table table-hover"
                       style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                    </tr>
                    </thead>
                    <tbody id="queryActivityResTbody">
                    <%--<tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- 查找联系人模态窗口 -->
<div class="modal fade" id="findContacts" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">查找联系人</h4>
            </div>
            <div class="modal-body">
                <div class="btn-group" style="position: relative; top: 18%; left: 8px;">
                    <form class="form-inline" role="form">
                        <div class="form-group has-feedback">
                            <input type="text" id="queryContactsName" class="form-control" style="width: 300px;"
                                   placeholder="请输入联系人名称，支持模糊查询">
                            <span class="glyphicon glyphicon-search form-control-feedback"></span>
                        </div>
                    </form>
                </div>
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td></td>
                        <td>名称</td>
                        <td>邮箱</td>
                        <td>手机</td>
                    </tr>
                    </thead>
                    <tbody id="queryContactsResTbody">
                    <%--<tr>
                        <td><input type="radio" name="activity"/></td>
                        <td>李四</td>
                        <td>lisi@bjpowernode.com</td>
                        <td>12345678901</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>


<div style="position:  relative; left: 30px;">
    <h3>创建交易</h3>
    <div style="position: relative; top: -40px; left: 70%;">
        <button type="button" class="btn btn-primary">保存</button>
        <button type="button" class="btn btn-default">取消</button>
    </div>
    <hr style="position: relative; top: -40px;">
</div>
<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
    <div class="form-group">
        <label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-owner">
                <c:forEach items="${userList}" var="user">
                    <option value="${user.id}">${user.name}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-money" class="col-sm-2 control-label">金额</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-money">
        </div>
    </div>

    <div class="form-group">
        <label for="create-name" class="col-sm-2 control-label">名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-name">
        </div>
        <label for="create-expectedDate" class="col-sm-2 control-label">预计成交日期<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control myDate" id="create-expectedDate" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-customerName" class="col-sm-2 control-label">客户名称<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="hidden" id="create-customerId">
            <input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
        </div>
        <label for="create-stage" class="col-sm-2 control-label">阶段<span
                style="font-size: 15px; color: red;">*</span></label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-stage">
                <option></option>
                <c:forEach items="${stageList}" var="stage">
                    <option value="${stage.id}">${stage.value}</option>
                </c:forEach>
            </select>
        </div>
    </div>

    <div class="form-group">
        <label for="create-type" class="col-sm-2 control-label">类型</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-type">
                <option></option>
                <c:forEach items="${typeList}" var="type">
                    <option value="${type.id}">${type.value}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-possibility" class="col-sm-2 control-label">可能性</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control" id="create-possibility">
        </div>
    </div>

    <div class="form-group">
        <label for="create-source" class="col-sm-2 control-label">来源</label>
        <div class="col-sm-10" style="width: 300px;">
            <select class="form-control" id="create-source">
                <option></option>
                <c:forEach items="${sourceList}" var="source">
                    <option value="${source.id}">${source.value}</option>
                </c:forEach>
            </select>
        </div>
        <label for="create-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                                            id="queryActivityA"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="hidden" id="create-activityId">
            <input type="text" class="form-control" id="create-activityName" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);"
                                                                                            id="queryContactsA"><span
                class="glyphicon glyphicon-search"></span></a></label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="hidden" id="create-contactsId">
            <input type="text" class="form-control" id="create-contactsName" readonly>
        </div>
    </div>

    <div class="form-group">
        <label for="create-description" class="col-sm-2 control-label">描述</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-description"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
        <div class="col-sm-10" style="width: 70%;">
            <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
        </div>
    </div>

    <div class="form-group">
        <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
        <div class="col-sm-10" style="width: 300px;">
            <input type="text" class="form-control myDate" id="create-nextContactTime" readonly>
        </div>
    </div>

</form>
</body>
</html>