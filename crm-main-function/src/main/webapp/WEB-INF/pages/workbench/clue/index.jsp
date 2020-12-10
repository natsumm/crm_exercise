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
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript"
            src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

    <script type="text/javascript">

        $(function () {
            //日历插件
            $(".myDate").datetimepicker({
                language: "zh-CN", //指定语言
                format: "yyyy-mm-dd", //日期格式
                minView: "month", //最小视图, 最小的可点击单位
                initialDate: new Date(), //默认显示日期
                todayBtn: true, //"今天"按钮
                clearBtn: true, //"清空"按钮
                autoclose: true, //选择日期后自动关闭
                todayHighlight: true, //"今天"高亮显示
                pickerPosition: "top-left" //日历的显示位置
            });
            //"创建"按钮单击事件 --> 初始化工作完成后, 弹出模态窗口
            $("#createClueBtn").click(function () {
                //初始化
                $("#createClueForm")[0].reset(); //reset()是dom对象的方法
                $("#createClueModal").modal("show");
            });
            //床架窗口"保存"按钮单击事件 --> 表单验证, 发起请求, 刷新页面
            $("#saveCreateClueBtn").click(function () {
                //收集参数
                var fullname = $.trim($("#create-fullname").val());
                var appellation = $.trim($("#create-appellation").val());
                var owner = $.trim($("#create-owner").val());
                var company = $.trim($("#create-company").val());
                var job = $.trim($("#create-job").val());
                var email = $.trim($("#create-email").val());
                var phone = $.trim($("#create-phone").val());
                var website = $.trim($("#create-website").val());
                var mphone = $.trim($("#create-mphone").val());
                var state = $.trim($("#create-state").val());
                var source = $.trim($("#create-source").val());
                var description = $.trim($("#create-description").val());
                var contactSummary = $.trim($("#create-contactSummary").val());
                var nextContactTime = $.trim($("#create-nextContactTime").val());
                var address = $.trim($("#create-address").val());
                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (company == "") {
                    alert("公司不能为空");
                    return;
                }
                if (fullname == "") {
                    alert("姓名不能为空");
                    return;
                }
                if (email != "" && !/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(email)) {
                    alert("邮箱格式不合法");
                    return;
                }
                if (phone != "" && !/\d{3}-\d{8}|\d{4}-\d{7}/.test(phone) && !/((\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)/.test(phone)) {
                    alert("公司座机格式不合法");
                    return;
                }
                if (website != "" && !/[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?/.test(website)) {
                    alert("公司网站不合法");
                    return;
                }
                if (mphone != "" && !/^(13[0-9]|14[5|7]|15[0|1|2|3|4|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/.test(mphone)) {
                    alert("手机格式不合法");
                    return;
                }
                //发起请求
                $.ajax({
                    url: "workbench/clue/saveCreateClue.do",
                    data: {
                        fullname: fullname,
                        appellation: appellation,
                        owner: owner,
                        company: company,
                        job: job,
                        email: email,
                        phone: phone,
                        website: website,
                        mphone: mphone,
                        state: state,
                        source: source,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //创建成功之后，关闭模态窗口
                            $("#createClueModal").modal("hide");
                            //刷新线索列表，显示第一页数据，保持每页显示条数不变
                            queryClueByConditionForPage(1, $("#pagination").bs_pagination("getOption", "rowsPerPage"));
                        } else {
                            //创建失败，提示信息，模态窗口不关闭，列表也不刷新。
                            alert(resp.msg);
                            $("#createClueModal").modal("show");
                        }
                    }
                });
            });
            //页面加载完成之后,显示所有数据的第一页, 默认每页显示10条数据
            queryClueByConditionForPage(1, 10);
            //条件查询按钮的单击事件:
            $("#queryClueBtn").click(function () {
                //用户在线索主页面填写查询条件,点击"查询"按钮,显示所有符合条件的数据的第一页, 每页显示条数不变
                queryClueByConditionForPage(1, $("#pagination").bs_pagination("getOption", "rowsPerPage"));
            });

            //"删除"按钮单击事件 -->根据id删除线索记录, 可以批量删除
            $("#deleteClueBtn").click(function () {
                //获取参数
                var $checkedDom = $("#queryClueResultTbody input[type='checkbox']:checked");
                if ($checkedDom.size() == 0) {
                    alert("至少删除一条数据");
                    return;
                }
                if (!window.confirm("确认删除" + $checkedDom.size() + "条数据?")) {
                    return;
                }
                var param = "";
                $checkedDom.each(function (index, element) {
                    param += "id=" + this.value + "&";
                });
                param = param.substr(0, param.length - 1);
                //发送请求
                $.ajax({
                    url: "workbench/clue/deleteClueByIds.do",
                    data: param,
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //删除成功之后,刷新线索列表,显示第一页数据,保持每页显示条数不变
                            queryClueByConditionForPage(1, $("#pagination").bs_pagination("getOption", "rowsPerPage"));
                        } else {
                            //删除失败,提示信息,列表不刷新
                            alert(resp.msg);
                        }
                    }
                });
            });

            //"修改"按钮单击事件
            $("#editClueBtn").click(function () {
                var $checkedDom = $("#queryClueResultTbody input[type='checkbox']:checked");
                if ($checkedDom.size() == 0) {
                    alert("请选择一条记录进行修改");
                    return;
                }
                if ($checkedDom.size() > 1) {
                    alert("每次只能修改一条记录");
                    return;
                }
                var id = $checkedDom.val();
                //**id放入隐藏域
                $("#clueId").val(id);
                $.ajax({
                    url: "workbench/clue/queryClueById.do",
                    data: {
                        id: id
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        $("#edit-fullname").val(resp.fullname);
                        $("#edit-appellation").val(resp.appellation);
                        $("#edit-owner").val(resp.owner);
                        $("#edit-company").val(resp.company);
                        $("#edit-job").val(resp.job);
                        $("#edit-email").val(resp.email);
                        $("#edit-phone").val(resp.phone);
                        $("#edit-website").val(resp.website);
                        $("#edit-mphone").val(resp.mphone);
                        $("#edit-state").val(resp.state);
                        $("#edit-source").val(resp.source);
                        $("#edit-description").val(resp.description);
                        $("#edit-contactSummary").val(resp.contactSummary);
                        $("#edit-nextContactTime").val(resp.nextContactTime);
                        $("#edit-address").val(resp.address);
                        //弹出模态窗口
                        $("#editClueModal").modal("show");
                    }
                });
            });

            //修改模态窗口"更新"按钮单击事件
            $("#saveEditClueBtn").click(function () {
                var id = $("#clueId").val();
                var fullname = $.trim($("#edit-fullname").val());
                var appellation = $.trim($("#edit-appellation").val());
                var owner = $.trim($("#edit-owner").val());
                var company = $.trim($("#edit-company").val());
                var job = $.trim($("#edit-job").val());
                var email = $.trim($("#edit-email").val());
                var phone = $.trim($("#edit-phone").val());
                var website = $.trim($("#edit-website").val());
                var mphone = $.trim($("#edit-mphone").val());
                var state = $.trim($("#edit-state").val());
                var source = $.trim($("#edit-source").val());
                var description = $.trim($("#edit-description").val());
                var contactSummary = $.trim($("#edit-contactSummary").val());
                var nextContactTime = $.trim($("#edit-nextContactTime").val());
                var address = $.trim($("#edit-address").val());

                //表单验证
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (company == "") {
                    alert("公司不能为空");
                    return;
                }
                if (fullname == "") {
                    alert("姓名不能为空");
                    return;
                }
                if (email != "" && !/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(email)) {
                    alert("邮箱格式不合法");
                    return;
                }
                if (phone != "" && !/\d{3}-\d{8}|\d{4}-\d{7}/.test(phone) && !/((\d{11})|^((\d{7,8})|(\d{4}|\d{3})-(\d{7,8})|(\d{4}|\d{3})-(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1})|(\d{7,8})-(\d{4}|\d{3}|\d{2}|\d{1}))$)/.test(phone)) {
                    alert("公司座机格式不合法");
                    return;
                }
                if (website != "" && !/[a-zA-Z0-9][-a-zA-Z0-9]{0,62}(\.[a-zA-Z0-9][-a-zA-Z0-9]{0,62})+\.?/.test(website)) {
                    alert("公司网站不合法");
                    return;
                }
                if (mphone != "" && !/^(13[0-9]|14[5|7]|15[0|1|2|3|4|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\d{8}$/.test(mphone)) {
                    alert("手机格式不合法");
                    return;
                }

                $.ajax({
                    url: "workbench/clue/saveEditClue.do",
                    data: {
                        id: id,
                        fullname: fullname,
                        appellation: appellation,
                        owner: owner,
                        company: company,
                        job: job,
                        email: email,
                        phone: phone,
                        website: website,
                        mphone: mphone,
                        state: state,
                        source: source,
                        description: description,
                        contactSummary: contactSummary,
                        nextContactTime: nextContactTime,
                        address: address
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //修改成功之后,关闭模态窗口,刷新线索列表,保持页号和每页显示条数都不变
                            $("#editClueModal").modal("hide");
                            queryClueByConditionForPage($("#pagination").bs_pagination("getOption", "currentPage"),
                                $("#pagination").bs_pagination("getOption", "rowsPerPage"));
                        } else {
                            //修改失败,提示信息,模态窗口不关闭,列表也不刷新
                            alert(resp.msg);
                            $("#editClueModal").modal("show");
                        }
                    }
                });
            });
        });

        function queryClueByConditionForPage(pageNo, pageSize) {
            //收集参数, 查询请求可以不去除空格, 不做表单验证
            var fullname = $("#query-fullname").val();
            var owner = $("#query-owner").val();
            var company = $("#query-company").val();
            var phone = $("#query-phone").val();
            var mphone = $("#query-mphone").val();
            var state = $("#query-state").val();
            var source = $("#query-source").val();
            /*var pageNo = 1;
            var pageSize = 10;*/
            var beginNo = (pageNo - 1) * pageSize;
            //发起请求
            $.ajax({
                url: "workbench/clue/queryClueByConditionForPage.do",
                data: {
                    fullname: fullname,
                    owner: owner,
                    company: company,
                    phone: phone,
                    mphone: mphone,
                    state: state,
                    source: source,
                    beginNo: beginNo,
                    pageSize: pageSize
                },
                type: "post",
                dataType: "json",
                success: function (resp) {
                    //resp:{clueList:{[id,name],[id,name]}, totalRows:5}
                    var htmlStr = "";
                    $.each(resp.clueList, function (index, element) {
                        htmlStr += "<tr class=\"active\">";
                        htmlStr += "<td><input type=\"checkbox\" value=\"" + element.id + "\"/></td>";
                        htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/clue/toDetail.do?id=" + element.id + "'\">" + element.fullname + element.appellation + "</a></td>";
                        htmlStr += "<td>" + element.company + "</td>";
                        htmlStr += "<td>" + element.phone + "</td>";
                        htmlStr += "<td>" + element.mphone + "</td>";
                        htmlStr += "<td>" + element.source + "</td>";
                        htmlStr += "<td>" + element.owner + "</td>";
                        htmlStr += "<td>" + element.state + "</td>";
                        htmlStr += "</tr>";
                    });
                    $("#queryClueResultTbody").html(htmlStr);
                    // $("#totalRows").html(resp.totalRows);

                    //计算总页数
                    var totalPages = 0;
                    if (resp.totalRows % pageSize == 0) {
                        //能整除, 直接赋值
                        totalPages = resp.totalRows / pageSize;
                    } else {
                        //不能整除, 取整后+1
                        totalPages = window.parseInt(resp.totalRows / pageSize) + 1;
                    }
                    $("#pagination").bs_pagination({
                        currentPage: pageNo, //当前页
                        rowsPerPage: pageSize, //每页显示条数
                        maxRowsPerPage: 50, //每页最大显示行数
                        totalPages: totalPages, //总页数, 需要计算
                        totalRows: resp.totalRows, //总行数, 从响应信息中获取

                        visiblePageLinks: 5, //卡片数目

                        showGoToPage: true, //显示跳转页按钮
                        showRowsPerPage: true, //显示每页显示行数输入框
                        showRowsInfo: true, //显示行数信息
                        showRowsDefaultInfo: true, //显示阿黑行数的默认信息

                        onChangePage: function (event, pageObj) { // returns page_num and rows_per_page after a link has clicked
                            //页码数目, 每页显示行数改变时的事件函数
                            //alert(pageObj.currentPage+ " ==== "+pageObj.rowsPerPage);
                            queryClueByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });


        }

    </script>
</head>
<body>

<!-- 创建线索的模态窗口 -->
<div class="modal fade" id="createClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">创建线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form" id="createClueForm">

                    <div class="form-group">
                        <label for="create-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-owner">
                                <%--<option>zhangsan</option>--%>
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-company">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-appellation">
                                <option></option>
                                <c:forEach items="${appellationList}" var="appellation">
                                    <option value="${appellation.id}">${appellation.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="create-fullname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-fullname">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-job">
                        </div>
                        <label for="create-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-email">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-phone">
                        </div>
                        <label for="create-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-website">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-mphone">
                        </div>
                        <label for="create-state" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-state">
                                <option></option>
                                <c:forEach items="${clueStateList}" var="state">
                                    <option value="${state.id}">${state.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="create-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>


                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">线索描述</label>
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
                                <input type="text" class="form-control myDate" id="create-nextContactTime" readonly>
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
                <button type="button" class="btn btn-primary" id="saveCreateClueBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索的模态窗口 -->
<div class="modal fade" id="editClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 90%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">修改线索</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <input type="hidden" id="clueId">
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
                        <label for="edit-company" class="col-sm-2 control-label">公司<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-company" value="动力节点">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-appellation">
                                <option></option>
                                <c:forEach items="${appellationList}" var="appellation">
                                    <option value="${appellation.id}">${appellation.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-fullname" class="col-sm-2 control-label">姓名<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-fullname" value="李四">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-job" class="col-sm-2 control-label">职位</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-job" value="CTO">
                        </div>
                        <label for="edit-email" class="col-sm-2 control-label">邮箱</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-phone" value="010-84846003">
                        </div>
                        <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-website"
                                   value="http://www.bjpowernode.com">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-mphone" class="col-sm-2 control-label">手机</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-mphone" value="12345678901">
                        </div>
                        <label for="edit-state" class="col-sm-2 control-label">线索状态</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-state">
                                <option></option>
                                <c:forEach items="${clueStateList}" var="state">
                                    <option value="${state.id}">${state.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-source">
                                <option></option>
                                <c:forEach items="${sourceList}" var="source">
                                    <option value="${source.id}">${source.value}</option>
                                </c:forEach>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                    <div style="position: relative;top: 15px;">
                        <div class="form-group">
                            <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control myDate" id="edit-nextContactTime"
                                       value="2017-05-01" readonly>
                            </div>
                        </div>
                    </div>

                    <div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                    <div style="position: relative;top: 20px;">
                        <div class="form-group">
                            <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                            <div class="col-sm-10" style="width: 81%;">
                                <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                            </div>
                        </div>
                    </div>
                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveEditClueBtn">更新</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>线索列表</h3>
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
                        <input class="form-control" type="text" id="query-fullname">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">公司</div>
                        <input class="form-control" type="text" id="query-company">
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
                        <div class="input-group-addon">线索来源</div>
                        <select class="form-control" id="query-source">
                            <option></option>
                            <c:forEach items="${sourceList}" var="source">
                                <option value="${source.id}">${source.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="query-owner">
                    </div>
                </div>


                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">手机</div>
                        <input class="form-control" type="text" id="query-mphone">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">线索状态</div>
                        <select class="form-control" id="query-state">
                            <option></option>
                            <c:forEach items="${clueStateList}" var="state">
                                <option value="${state.id}">${state.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="queryClueBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createClueBtn"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editClueBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" id="deleteClueBtn" class="btn btn-danger"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>


        </div>
        <div style="position: relative;top: 50px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox"/></td>
                    <td>名称</td>
                    <td>公司</td>
                    <td>公司座机</td>
                    <td>手机</td>
                    <td>线索来源</td>
                    <td>所有者</td>
                    <td>线索状态</td>
                </tr>
                </thead>
                <tbody id="queryClueResultTbody">
                <%--<tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detdetail.jsp>李四先生</a></td>
                    <td>动力节点</td>
                    <td>010-84846003</td>
                    <td>12345678901</td>
                    <td>广告</td>
                    <td>zhangsan</td>
                    <td>已联系</td>
                </tr>--%>
                </tbody>
            </table>
            <div id="pagination"></div>
        </div>

        <%--<div style="height: 50px; position: relative;top: 60px;">
            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRows"></b>条记录
                </button>
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