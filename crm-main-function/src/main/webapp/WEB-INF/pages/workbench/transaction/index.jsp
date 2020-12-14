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
            $("#createTranBtn").click(function () {
                window.location.href = "workbench/transaction/toSave.do";
            });
            //页面加载完毕查询所有数据的第一页, 默认每页显示10条
            queryTranByConditionForPage(1, 10);
            //点击"查询"按钮,显示所有符合条件的数据的第一页，保持每页显示条数不变
            $("#queryTranBtn").click(function () {
                queryTranByConditionForPage(1, $("#pagination").bs_pagination("getOption", "rowsPerPage"));
            });
        });

        //分页查询交易
        function queryTranByConditionForPage(pageNo, pageSize) {
            var owner = $("#query-owner").val();
            var name = $("#query-name").val();
            var customerName = $("#query-customerName").val();
            var stage = $("#query-stage").val();
            var type = $("#query-type").val();
            var source = $("#query-source").val();
            var contactsName = $("#query-contactsName ").val();
            //计算起始页码
            var beginNo = (pageNo - 1) * pageSize;
            //发起请求
            $.ajax({
                url: "workbench/transaction/queryTranByConditionForPage.do",
                data: {
                    owner: owner,
                    name: name,
                    customerName: customerName,
                    stage: stage,
                    type: type,
                    source: source,
                    contactsName: contactsName,
                    beginNo: beginNo,
                    pageSize: pageSize
                },
                type: "post",
                dataType: "json",
                success: function (resp) {
                    //tranList, totalRows
                    //拼接字符串
                    var htmlStr = "";
                    $.each(resp.tranList, function (i, e) {
                        htmlStr += "<tr>";
                        htmlStr += "<td><input type=\"checkbox\" value=\"" + e.id + "\"/></td>";
                        htmlStr += "<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='detail.jsp';\">" + e.name + "</a></td>";
                        htmlStr += "<td>" + e.customerId + "</td>";
                        htmlStr += "<td>" + e.stage + "</td>";
                        htmlStr += "<td>" + e.type + "</td>";
                        htmlStr += "<td>" + e.owner + "</td>";
                        htmlStr += "<td>" + e.source + "</td>";
                        htmlStr += "<td>" + e.contactsId + "</td>";
                        htmlStr += "</tr>";
                    });
                    $("#queryTranResTbody").html(htmlStr);
                    //$("#totalRows").html(resp.totalRows);
                    //计算总页数
                    var totalPages = 0;
                    if (resp.totalRows % pageSize == 0) {
                        totalPages = resp.totalRows / pageSize;
                    } else {
                        totalPages = parseInt(resp.totalRows / pageSize) + 1;
                    }
                    //日历插件
                    $("#pagination").bs_pagination({
                        currentPage: pageNo,
                        rowsPerPage: pageSize,
                        maxRowsPerPage: 50,
                        totalPages: totalPages,
                        totalRows: resp.totalRows,

                        visiblePageLinks: 5,

                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        showRowsDefaultInfo: true,

                        onChangePage: function (event, pageObj) {
                            queryTranByConditionForPage(pageObj.currentPage, pageObj.rowsPerPage);
                        }
                    });
                }
            });
        }

    </script>
</head>
<body>


<div>
    <div style="position: relative; left: 10px; top: -10px;">
        <div class="page-header">
            <h3>交易列表</h3>
        </div>
    </div>
</div>

<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">

    <div style="width: 100%; position: absolute;top: 5px; left: 10px;">

        <div class="btn-toolbar" role="toolbar" style="height: 80px;">
            <form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">所有者</div>
                        <input class="form-control" type="text" id="query-owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="query-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input class="form-control" type="text" id="query-customerName">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">阶段</div>
                        <select class="form-control" id="query-stage">
                            <option></option>
                            <c:forEach items="${stageList}" var="stage">
                                <option value="${stage.id}">${stage.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">类型</div>
                        <select class="form-control" id="query-type">
                            <option></option>
                            <c:forEach items="${typeList}" var="type">
                                <option value="${type.id}">${type.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="query-source">
                            <option></option>
                            <c:forEach items="${sourceList}" var="source">
                                <option value="${source.id}">${source.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">联系人名称</div>
                        <input class="form-control" type="text" id="query-contactsName">
                    </div>
                </div>

                <button type="button" id="queryTranBtn" class="btn btn-default">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary" id="createTranBtn"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" onclick="window.location.href='edit.html';"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
            </div>


        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox"/></td>
                    <td>名称</td>
                    <td>客户名称</td>
                    <td>阶段</td>
                    <td>类型</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>联系人名称</td>
                </tr>
                </thead>
                <tbody id="queryTranResTbody">
                <%--<tr>
                    <td><input type="checkbox"/></td>
                    <td><a style="text-decoration: none; cursor: pointer;"
                           onclick="window.location.href='detail.jsp';">动力节点-交易01</a></td>
                    <td>动力节点</td>
                    <td>谈判/复审</td>
                    <td>新业务</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>李四</td>
                </tr>--%>
                </tbody>
            </table>
            <div id="pagination"></div>
        </div>

        <%--<div style="height: 50px; position: relative;top: 20px;">
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