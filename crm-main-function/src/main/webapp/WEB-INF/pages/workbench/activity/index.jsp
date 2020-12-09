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
            //"创建市场活动"按钮单击事件, 弹出模态窗口
            $("#createActivityBtn").click(function () {
                //初始化工作, 弹出模态窗口
                $("#createActivityForm")[0].reset();
                $("#createActivityModal").modal("show");
            });
            //"保存"创建的市场活动
            $("#saveCreateActivityBtn").click(function () {
                //收集参数
                var owner = $.trim($("#create-owner").val());
                var name = $.trim($("#create-name").val());
                var startDate = $.trim($("#create-startDate").val());
                var endDate = $.trim($("#create-endDate").val());
                var cost = $.trim($("#create-cost").val());
                var description = $.trim($("#create-description").val());
                /**
                 * 所有者和名称不能为空
                 * 如果开始日期和结束日期都不为空,则结束日期不能比开始日期小
                 * 成本只能为非负整数
                 */
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (name == "") {
                    alert("名称不能为空");
                    return;
                }
                if (startDate != "" && endDate != "" && startDate > endDate) {
                    alert("开始日期不能晚于结束日期");
                    return;
                }
                if (!/^(([1-9]\d*)|0)$/.test(cost)) {
                    alert("成本只能是非负整数");
                    return;
                }
                $.ajax({
                    url: "workbench/activity/saveCreateActivity.do",
                    data: {
                        owner: owner,
                        name: name,
                        startDate: startDate,
                        endDate: endDate,
                        cost: cost,
                        description: description
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //创建成功之后,关闭模态窗口
                            $("#createActivityModal").modal("hide");
                            //刷新市场活动列，显示第一页数据，保持每页显示条数不变
                            queryActivityByConditionForPage(1, $("#pagination").bs_pagination("getOption", "rowsPerPage"));
                        } else {
                            alert(resp.msg);
                            $("#createActivityModal").modal("show");
                        }
                    }
                });
            });
            //页面加载完毕, 显示所有数据的第一页, 默认每页显示10条数据
            queryActivityByConditionForPage(1, 10);
            //用户在市场活动主页面填写查询条件,点击"查询"按钮,显示所有符合条件的数据的第一页，保持每页显示条数不变;
            $("#queryActivityBtn").click(function () {
                queryActivityByConditionForPage(1, $("#pagination").bs_pagination("getOption", "rowsPerPage"));
            });
            //"删除"市场活动按钮单击事件
            $("#deleteActivityBtn").click(function () {
                var $checkedDom = $("#queryActivityResTbody input[type='checkbox']:checked");
                if($checkedDom.size()==0){
                    alert("每次至少删除一条记录");
                    return;
                }
                var param="";
                $checkedDom.each(function () {
                    param+="id="+this.value+"&";
                });
                param=param.substr(0, param.length-1);
                if(!window.confirm("确认删除?")){
                    return;
                }
                $.ajax({
                    url:"workbench/activity/deleteActivityByIds.do",
                    data:param,
                    type:"post",
                    dataType:"json",
                    success:function (resp) {
                        if(resp.code=="1"){
                            alert("成功删除 "+resp.retData+" 条数据; ");
                            //删除成功之后,刷新市场活动列表,显示第一页数据,保持每页显示条数不变
                            queryActivityByConditionForPage(1, $("#pagination").bs_pagination("getOption", "rowsPerPage"));
                        }else{
                            //删除失败,提示信息,列表不刷新
                            alert(resp.msg);
                        }
                    }
                });
            });

            //"修改"按钮的单击事件: 从表中查询一条记录, 弹出模态窗口
            $("#editActivityBtn").click(function () {
                var $checkedDom = $("#queryActivityResTbody input[type='checkbox']:checked");
                if ($checkedDom.size() == 0) {
                    alert("请选中一条记录进行修改");
                    return;
                }
                if ($checkedDom.size() > 1) {
                    alert("每次只能修改一条记录");
                    return;
                }
                var activityId = $checkedDom.val();
                $.ajax({
                    url: "workbench/activity/queryActivityById.do",
                    data: {
                        id: activityId
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        //接收到相应信息, 直接赋值给模态窗口中
                        $("#edit-id").val(resp.id); //隐藏域
                        $("#edit-owner").val(resp.owner);
                        $("#edit-name").val(resp.name);
                        $("#edit-startDate").val(resp.startDate);
                        $("#edit-endDate").val(resp.endDate);
                        $("#edit-cost").val(resp.cost);
                        $("#edit-description").val(resp.description);
                        //弹出模态窗口
                        $("#editActivityModal").modal("show");

                    }
                });
            });
            //修改窗口的"更新"按钮单击事件
            $("#updateActivityBtn").click(function () {
                var id = $.trim($("#edit-id").val());
                var owner = $.trim($("#edit-owner").val());
                var name = $.trim($("#edit-name").val());
                var startDate = $.trim($("#edit-startDate").val());
                var endDate = $.trim($("#edit-endDate").val());
                var cost = $.trim($("#edit-cost").val());
                var description = $.trim($("#edit-description").val());
                /**
                 * 表单验证, 条件与创建时相同;
                 */
                if (owner == "") {
                    alert("所有者不能为空");
                    return;
                }
                if (name == "") {
                    alert("名称不能为空");
                    return;
                }
                if (startDate != "" && endDate != "" && startDate > endDate) {
                    alert("开始日期不能晚于结束日期");
                    return;
                }
                if (!/^(([1-9]\d*)|0)$/.test(cost)) {
                    alert("成本只能是非负整数");
                    return;
                }
                $.ajax({
                    url: "workbench/activity/saveEditActivity.do",
                    data: {
                        id: id,
                        owner: owner,
                        name: name,
                        startDate: startDate,
                        endDate: endDate,
                        cost: cost,
                        description: description
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //修改成功之后,关闭模态窗口,刷新市场活动列表,保持页号和每页显示条数都不变
                            $("#editActivityModal").modal("hide");
                            queryActivityByConditionForPage($("#pagination").bs_pagination("getOption", "currentPage"),
                                $("#pagination").bs_pagination("getOption", "rowsPerPage"))
                        } else {
                            //修改失败,提示信息,模态窗口不关闭,列表也不刷新
                            alert(resp.msg);
                            $("#editActivityModal").modal("show");
                        }
                    }
                });
            });

            //"批量导出"单击事件
            $("#exportActivityAllBtn").click(function () {
                //文件下载的请求必须是: 浏览器发送到同步请求, ajax不能处理文件 即使是同步请求, 页面也不会刷新;
                window.location.href = "workbench/activity/exportAllActivity.do";
            });

            //"选择导出"单击事件
            $("#exportActivityXzBtn").click(function () {
                var $checkedDom = $("#queryActivityResTbody input[type='checkbox']:checked");
                //表单验证
                if ($checkedDom.size() == 0) {
                    alert("至少选择一条记录导出");
                    return;
                }
                var param = "";
                $checkedDom.each(function () {
                    param += "id=" + this.value + "&";
                });
                param = param.substr(0, param.length - 1);
                alert("===准备发送请求==");
                window.location.href = "workbench/activity/exportActivitySelective.do?" + param;
            });

            //导入市场活动模态窗口"导入"按钮单击事件
            $("#importActivityBtn").click(function () {
                //获取文件名
                var activityFile = $("#activityFile").val();
                if (activityFile == "") {
                    alert("请选择文件后上传");
                    return;
                }
                //只支持.xls
                var fileSuffix = activityFile.substr(activityFile.lastIndexOf(".") + 1).toLowerCase();
                if (fileSuffix != "xls") {
                    alert("只支持.xls文件, 请检查");
                    return;
                }
                //文件大小不超过5MB
                var file = $("#activityFile")[0].files[0];
                if (file.size > 5 * 1024 * 1024) {
                    alert("文件大小不能超过5MB");
                    return;
                }
                var formData = new FormData();
                formData.append("activityFile", file);

                $.ajax({
                    url: "workbench/activity/importActivity.do",
                    data: formData,
                    type: "post",
                    dataType: "json",
                    processData: false,
                    contentType: false,
                    success: function (resp) {
                        if (resp.code == "1") {
                            //导入成功之后,提示成功导入记录条数,关闭模态窗口,刷新市场活动列表,显示第一页数据,保持每页显示条数不变
                            alert("成功导入 " + resp.retData + " 条记录");
                            $("#importActivityModal").modal("hide");
                            $("#activityFile").val("");
                            queryActivityByConditionForPage(1, $("#pagination").bs_pagination("getOption", "rowsPerPage"));
                        } else {
                            //导入失败,提示信息,模态窗口不关闭,列表也不刷新
                            alert(resp.msg);
                            $("#importActivityModal").modal("show");
                        }
                    }
                });

            });
        });

        function queryActivityByConditionForPage(pageNo, pageSize) {
            var name = $("#query-name").val();
            var owner = $("#query-owner").val();
            var startDate = $("#query-startDate").val();
            var endDate = $("#query-endDate").val();
            /*var pageNo = 1;
            var pageSize = 10;*/
            //计算起始行数;
            var beginNo = (pageNo - 1) * pageSize;
            $.ajax({
                url: "workbench/activity/queryActivityByConditionForPage.do",
                data: {
                    name: name,
                    owner: owner,
                    startDate: startDate,
                    endDate: endDate,
                    beginNo: beginNo,
                    pageSize: pageSize
                },
                type: "post",
                dataType: "json",
                success: function (resp) {
                    var htmlStr = "";
                    $.each(resp.activityList, function () {
                        htmlStr += "<tr class=\"active\">";
                        htmlStr += "<td><input type=\"checkbox\" value=\"" + this.id + "\"/></td>";
                        htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/toDetail.do?id=" + this.id + "'\">" + this.name + "</a></td>";
                        htmlStr += "<td>" + this.owner + "</td>";
                        htmlStr += "<td>" + this.startDate + "</td>";
                        htmlStr += "<td>" + this.endDate + "</td>";
                        htmlStr += "</tr>";
                    });
                    $("#queryActivityResTbody").html(htmlStr);
                    //$("#totalRows").html(resp.totalRows);

                    //计算总页数 总行数 / 每页显示行数 向上取整
                    var totalPages=0;
                    if(resp.totalRows%pageSize==0){
                        totalPages=resp.totalRows/pageSize;
                    }else{
                        totalPages=window.parseInt(resp.totalRows/pageSize) +1;
                    }
                    //日历插件:
                    $("#pagination").bs_pagination({
                        currentPage: pageNo, //当前页
                        rowsPerPage: pageSize, //每页显示行数
                        maxRowsPerPage: 50, //最大每页显示行数
                        totalPages: totalPages, //总页数, 需要从参数中计算
                        totalRows: resp.totalRows, //总行数, 从相应信息中得到

                        visiblePageLinks: 5, //显示的卡片数

                        showGoToPage: true, //显示跳转"xx页"按钮
                        showRowsPerPage: true, //显示每页显示行数
                        showRowsInfo: true, //显示行数信息
                        showRowsDefaultInfo: true, //显示默认的行数信息
                        onChangePage: function (event,pageObj) {
                            //console.log(pageObj.currentPage+" === "+pageObj.rowsPerPage);
                            queryActivityByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });
        }

    </script>
</head>
<body>

<!-- 创建市场活动的模态窗口 -->
<div class="modal fade" id="createActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form" id="createActivityForm">

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
                        <label for="create-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-name">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myCal" id="create-startDate" readonly>
                        </div>
                        <label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myCal" id="create-endDate" readonly>
                        </div>
                    </div>
                    <div class="form-group">

                        <label for="create-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="create-cost">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="create-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="create-description"></textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="saveCreateActivityBtn">保存</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改市场活动的模态窗口 -->
<div class="modal fade" id="editActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal" role="form">
                    <input type="hidden" id="edit-id"/>
                    <div class="form-group">
                        <label for="edit-owner" class="col-sm-2 control-label">所有者<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <select class="form-control" id="edit-owner">
                                <%--<option>zhangsan</option>--%>
                                <c:forEach items="${userList}" var="user">
                                    <option value="${user.id}">${user.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <label for="edit-name" class="col-sm-2 control-label">名称<span
                                style="font-size: 15px; color: red;">*</span></label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-name" value="发传单">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myCal" id="edit-startDate" value="2020-10-10"
                                   readonly>
                        </div>
                        <label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control myCal" id="edit-endDate" value="2020-10-20" readonly>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-cost" class="col-sm-2 control-label">成本</label>
                        <div class="col-sm-10" style="width: 300px;">
                            <input type="text" class="form-control" id="edit-cost" value="5,000">
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="edit-description" class="col-sm-2 control-label">描述</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
                        </div>
                    </div>

                </form>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateActivityBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 导入市场活动的模态窗口 -->
<div class="modal fade" id="importActivityModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    请选择要上传的文件：
                    <small style="color: gray;">[仅支持.xls]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <input type="file" id="activityFile">
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;">
                    <h3>重要提示</h3>
                    <ul>
                        <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                        <li>给定文件的第一行将视为字段名。</li>
                        <li>请确认您的文件大小不超过5MB。</li>
                        <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                        <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                        <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                        <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
            </div>
        </div>
    </div>
</div>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>市场活动列表</h3>
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
                        <div class="input-group-addon">开始日期</div>
                        <input class="form-control myCal" type="text" id="query-startDate" readonly/>
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">结束日期</div>
                        <input class="form-control myCal" type="text" id="query-endDate" readonly>
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createActivityBtn">
                    <span class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editActivityBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteActivityBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal">
                    <span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）
                </button>
                <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）
                </button>
                <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span
                        class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）
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
                    <td>开始日期</td>
                    <td>结束日期</td>
                </tr>
                </thead>
                <tbody id="queryActivityResTbody">
                <%--<tr class="active">
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='detdetail.jsp>发传单</a></td>
                    <td>zhangsan</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                    </tr>--%>
                </tbody>
            </table>
            <div id="pagination"></div>
        </div>

        <%--<div style="height: 50px; position: relative;top: 30px;">
            <div>
                <button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRows"></b>条记录</button>
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