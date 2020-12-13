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
    <link href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css" type="text/css" rel="stylesheet"/>

    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.min.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <script type="text/javascript">

        $(function () {

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });
            //日历插件
            $(".myCal").datetimepicker({
                language: "zh-CN",
                format: "yyyy-mm-dd",
                minView: "month",
                initialDate: new Date(),
                todayBtn: true,
                clearBtn: true,
                autoclose: true,
                todayHighlight: true
            });
            //"创建客户"按钮单击事件,   初始化模态窗口后弹出
            $("#createCustomerBtn").click(function () {
                //清空form表单
                $("#createCustomerForm").get(0).reset();
                $("#createCustomerModal").modal("show");
            });

            //创建客户"保存"按钮单击事件, 表单验证后发起请求
            $("#saveCreateCustomerBtn").click(function () {
                //收集参数
                var owner = $.trim($("#create-owner").val());
                var name = $.trim($("#create-name").val());
                var website = $.trim($("#create-website").val());
                var phone = $.trim($("#create-phone").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $.trim($("#create-nextContactTime").val());
                var description = $.trim($("#create-description").val());
                var address = $.trim($("#create-address").val());
                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (name == "") {
                    alert("名称不能为空");
                    return;
                }
                if (website != "" && !/[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?/.test(website)) {
                    alert("公司网站格式不正确");
                    return;
                }
                if (phone != "" && !/\d{3}-\d{8}|\d{4}-\d{7}/.test(phone)) {
                    alert("公司座机格式不正确");
                    return;
                }
                $.ajax({
                    url: "workbench/customer/saveCreateCustomer.do",
                    data: {
                        owner: owner,
                        name: name,
                        website: website,
                        phone: phone,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        description: description,
                        address: address
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //创建成功之后,关闭模态窗口
                            $("#createCustomerModal").modal("hide");
                            //刷新客户列表，显示第一页数据，保持每页显示条数不变
                            queryCustomerByConditionForPage(1, $("#pagination").bs_pagination("getOption", "rowsPerPage"));
                        } else {
                            //创建失败,提示信息创建失败,模态窗口不关闭, 客户列表也不刷新
                            alert(resp.msg);
                            $("#createCustomerModal").modal("show");
                        }
                    }
                });
            });
            //页面加载完毕, 显示所有数据的第一页, 默认每页十条数据
            queryCustomerByConditionForPage(1, 10);

            //"查询"按钮单击事件, 显示所有符合条件的数据的第一页，保持每页显示条数不变
            $("#queryCustomerBtn").click(function () {
                queryCustomerByConditionForPage(1, $("#pagination").bs_pagination("getOption", "rowsPerPage"));
            });

            //"删除"按钮单击事件
            $("#deleteCustomerBtn").click(function () {
                var $checkedDom = $("#queryCustomerResTbody input[type='checkbox']:checked");
                if ($checkedDom.size() == 0) {
                    alert("每次至少删除一条数据");
                    return;
                }
                //拼接参数
                var param = "";
                $checkedDom.each(function () {
                    param += "id=" + this.value + "&";
                });
                param.substr(0, param.length - 1);
                //弹起对话框
                if (!window.confirm("确认删除?")) return;
                //发起请求
                $.ajax({
                    url: "workbench/customer/deleteCustomerByIds.do",
                    data: param,
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //删除成功之后,刷新客户列表,显示第一页数据,保持每页显示条数不变
                            queryCustomerByConditionForPage(1, $("#pagination").bs_pagination("getOption", "rowsPerPage"));
                        } else {
                            //删除失败,提示信息,列表不刷新
                            alert(resp.msg);
                        }
                    }
                });
            });

            //"修改"按钮单击事件, 根据id查询客户, 写入数据, 并弹出模态窗口
            $("#editCustomerBtn").click(function () {
                var $checkedDom = $("#queryCustomerResTbody input[type='checkbox']:checked");
                if ($checkedDom.size() == 0) {
                    alert("请选择一条数据进行修改");
                    return;
                }
                if ($checkedDom.size() > 1) {
                    alert("每次只能修改一条数据");
                    return;
                }
                var id = $checkedDom.val();
                $.ajax({
                    url: "workbench/customer/queryCustomerById.do",
                    data: {
                        id: id
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        $("#edit-id").val(resp.id);
                        $("#edit-owner").val(resp.owner);
                        $("#edit-name").val(resp.name);
                        $("#edit-website").val(resp.website);
                        $("#edit-phone").val(resp.phone);
                        $("#edit-contactSummary").val(resp.contactSummary);
                        $("#edit-nextContactTime").val(resp.nextContactTime);
                        $("#edit-description").val(resp.description);
                        $("#edit-address").val(resp.address);
                        //弹出模态窗口
                        $("#editCustomerModal").modal("show");
                    }
                });
            });

            //保存修改的客户记录
            $("#saveEditCustomerBtn").click(function () {
                var id = $.trim($("#edit-id").val());
                var owner = $.trim($("#edit-owner").val());
                var name = $.trim($("#edit-name").val());
                var website = $.trim($("#edit-website").val());
                var phone = $.trim($("#edit-phone").val());
                var contactSummary = $.trim($("#edit-contactSummary").val());
                var nextContactTime = $.trim($("#edit-nextContactTime").val());
                var description = $.trim($("#edit-description").val());
                var address = $.trim($("#edit-address").val());
                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (name == "") {
                    alert("名称不能为空");
                    return;
                }
                if (website != "" && !/[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?/.test(website)) {
                    alert("公司网站格式不正确");
                    return;
                }
                if (phone != "" && !/\d{3}-\d{8}|\d{4}-\d{7}/.test(phone)) {
                    alert("公司座机格式不正确");
                    return;
                }
                $.ajax({
                    url: "workbench/customer/saveEditCustomer.do",
                    data: {
                        id: id,
                        owner: owner,
                        name: name,
                        website: website,
                        phone: phone,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        description: description,
                        address: address
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //修改成功之后,关闭模态窗口,刷新客户列表,保持页号和每页显示条数都不变
                            $("#editCustomerModal").modal("hide");
                            queryCustomerByConditionForPage(getPaginationOption("currentPage"), getPaginationOption("rowsPerPage"));
                        } else {
                            //修改失败,提示信息,模态窗口不关闭,列表也不刷新
                            alert(resp.msg);
                            $("#editCustomerModal").modal("show");
                        }
                    }
                });
            });
        });

        //通过参数来活动分页插件的当前属性;
        function getPaginationOption(option) {
            return $("#pagination").bs_pagination("getOption", option);
        }

        function queryCustomerByConditionForPage(pageNo, pageSize) {
            //收集参数
            var owner = $("#query-owner").val();
            var name = $("#query-name").val();
            var website = $("#query-website").val();
            var phone = $("#query-phone").val();
            /*var pageNo=1;
            var pageSize=10;*/
            var beginNo = (pageNo - 1) * pageSize;

            //发起请求
            $.ajax({
                url: "workbench/customer/queryCustomerByConditionForPage.do",
                data: {
                    owner: owner,
                    name: name,
                    website: website,
                    phone: phone,
                    beginNo: beginNo,
                    pageSize: pageSize
                },
                type: "post",
                dataType: "json",
                success: function (resp) {
                    //遍历数组
                    var htmlStr = "";
                    $.each(resp.customerList, function () {
                        htmlStr += "<tr>";
                        htmlStr += "<td><input type=\"checkbox\" value=\"" + this.id + "\"/></td>";
                        htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.html';\">" + this.name + "</a></td>";
                        htmlStr += "<td>" + this.owner + "</td>";
                        htmlStr += "<td>" + this.phone + "</td>";
                        htmlStr += "<td>" + this.website + "</td>";
                        htmlStr += "</tr>";
                    });
                    $("#queryCustomerResTbody").html(htmlStr);
                    //取出总行数并赋值
                    //$("#totalRows").html(resp.totalRows);

                    //计算总页数
                    var totalPages = 0;
                    if (resp.totalRows % pageSize == 0) {
                        totalPages = resp.totalRows / pageSize;
                    } else {
                        totalPages = parseInt(resp.totalRows / pageSize) + 1;
                    }
                    //分页插件
                    $("#pagination").bs_pagination({
                        currentPage: pageNo, //当前页
                        rowsPerPage: pageSize, //每页显示条数
                        maxRowsPerPage: 50, //最大每页显示行数
                        totalPages: totalPages, //总页数, 需要从响应信息中计算
                        totalRows: resp.totalRows, //总行数

                        visiblePageLinks: 5, //显示可以跳转的卡片数目

                        showGoToPage: true, //显示"跳转"按钮
                        showRowsPerPage: true, //显示每页显示数目按钮
                        showRowsInfo: true, //显示行数信息
                        showRowsDefaultInfo: true, //显示默认的行数信息

                        onChangePage: function (event, pageObj) {
                            //console.log(pageObj.currentPage+"======"+pageObj.rowsPerPage);
                            queryCustomerByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });
        }
    </script>
</head>
<body>

<!-- 创建客户的模态窗口 -->
<div class="modal fade" id="createCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" id="createCustomerForm" role="form">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>
                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myCal" id="create-nextContactTime" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="create-address"></textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCreateCustomerBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改客户的模态窗口 -->
<div class="modal fade" id="editCustomerModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改客户</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id"/><%--修改客户的id隐藏域--%>
                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="http://www.bjpowernode.com">
                        </div>
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description"></textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myCal" id="edit-nextContactTime" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveEditCustomerBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>客户列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="query-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="query-owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司座机</div>
                        <input class="form-control" type="text" id="query-phone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司网站</div>
                        <input class="form-control" type="text" id="query-website">
                    </div>
                </div>

                <button type="button" id="queryCustomerBtn" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createCustomerBtn">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editCustomerBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteCustomerBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox"/></td>
                    <td>名称</td>
                    <td>所有者</td>
                    <td>公司座机</td>
                    <td>公司网站</td>
                </tr>
                </thead>
                <tbody id="queryCustomerResTbody">
                <%--<tr>
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='detail.html';">动力节点</a></td>
                    <td>zhangsan</td>
                    <td>010-84846003</td>
                    <td>http://www.bjpowernode.com</td>
                </tr>--%>
                </tbody>
            </table>
            <div id="pagination"></div>
        </div>

        <%--<div style="height: 50px; position: relative;top: 30px;">
            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRows">50</b>条记录</button>
            </div>
            <div class="btn-group" style="position: relative;top: -34px; left: 110px;">
                <button type="button" class="btn btn-default" style="cursor: default;">显示</button>
                <div class="btn-group">
                    <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
                        10
                        <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu">
                        <li><a href="#">20</a></li>
                        <li><a href="#">30</a></li>
                    </ul>
                </div>
                <button type="button" class="btn btn-default" style="cursor: default;">条/页</button>
            </div>
            <div style="position: relative;top: -88px; left: 285px;">
                <nav>
                    <ul class="pagination">
                        <li class="disabled"><a href="#">首页</a></li>
                        <li class="disabled"><a href="#">上一页</a></li>
                        <li class="active"><a href="#">1</a></li>
                        <li><a href="#">2</a></li>
                        <li><a href="#">3</a></li>
                        <li><a href="#">4</a></li>
                        <li><a href="#">5</a></li>
                        <li><a href="#">下一页</a></li>
                        <li class="disabled"><a href="#">末页</a></li>
                    </ul>
                </nav>
            </div>
        </div>--%>

    </div>

</div>
</body>
</html>