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

        //默认情况下取消和保存按钮是隐藏的
        var cancelAndSaveBtnDefault = true;

        $(function () {
            $("#remark").focus(function () {
                if (cancelAndSaveBtnDefault) {
                    //设置remarkDiv的高度为130px
                    $("#remarkDiv").css("height", "130px");
                    //显示
                    $("#cancelAndSaveBtn").show("2000");
                    cancelAndSaveBtnDefault = false;
                }
            });

            $("#cancelBtn").click(function () {
                //显示
                $("#cancelAndSaveBtn").hide();
                //设置remarkDiv的高度为130px
                $("#remarkDiv").css("height", "90px");
                cancelAndSaveBtnDefault = true;
            });
            // $(".remarkDiv").mouseover(function () {
            $("#queryRemarkListDiv").on("mouseover", ".remarkDiv", function () {
                $(this).children("div").children("div").show();
            });

            //$(".remarkDiv").mouseout(function () {
            $("#queryRemarkListDiv").on("mouseout", ".remarkDiv", function () {
                $(this).children("div").children("div").hide();
            });

            //$(".myHref").mouseover(function () {
            $("#queryRemarkListDiv").on("mouseover", ".myHref", function () {
                $(this).children("span").css("color", "red");
            });

            //$(".myHref").mouseout(function () {
            $("#queryRemarkListDiv").on("mouseout", ".myHref", function () {
                $(this).children("span").css("color", "#E6E6E6");
            });

            //关联市场活动a标签单击事件--> 初始化工作完成后, 弹出模态窗口
            $("#bundActivityA").click(function () {
                //初始化工作-->清空模态窗口输入框和表格内容
                $("#queryActivityName").val("");
                $("#queryActivityResTbody").empty();
                //弹出模态窗口
                $("#bundModal").modal("show");
            });

            //关联市场活动模态窗口, 输入框的键盘弹起事件-->每次键盘弹起都根据名称查询没有关联过的市场活动, 将其覆盖到表格中
            //需要输入的数据时使用-->键盘弹起, 只需要事件时使用-->键盘按下
            $("#queryActivityName").keyup(function () {
                var name = this.value;
                var clueId = "${clue.id}";
                $.ajax({
                    url: "workbench/clue/queryActivityForDetailByNameAndClueId.do",
                    data: {
                        name: name,
                        clueId: clueId
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        var htmlStr = "";
                        $.each(resp, function () {
                            htmlStr += "<tr>";
                            htmlStr += "<td><input type=\"checkbox\" value=\"" + this.id + "\"/></td>";
                            htmlStr += "<td>" + this.name + "</td>";
                            htmlStr += "<td>" + this.startDate + "</td>";
                            htmlStr += "<td>" + this.endDate + "</td>";
                            htmlStr += "<td>" + this.owner + "</td>";
                            htmlStr += "</tr>";
                        });
                        //覆盖显示
                        $("#queryActivityResTbody").html(htmlStr);
                    }
                });
            });
            //关联市场活动模态窗口的"关联"按钮单击事件
            $("#bundActivityBtn").click(function () {
                var $checkedDom = $("#queryActivityResTbody input[type='checkbox']:checked");
                if ($checkedDom.size() == 0) {
                    alert("请选择要关联的市场活动");
                    return;
                }
                var param = "";
                $checkedDom.each(function () {
                    param += "activityId=" + this.value + "&";
                });
                param += "clueId=${clue.id}";
                //发起请求
                $.ajax({
                    url: "workbench/clue/saveBundActivity.do",
                    data: param,
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //关联成功之后,关闭模态窗口,刷新已经关联过的市场活动列表
                            //关闭模态窗口
                            $("#bundModal").modal("hide");
                            var htmlStr = "";
                            $.each(resp.retData, function (index, element) {
                                htmlStr += "<tr id=\"tr_" + element.id + "\">";
                                htmlStr += "<td>" + element.name + "</td>";
                                htmlStr += "<td>" + element.startDate + "</td>";
                                htmlStr += "<td>" + element.endDate + "</td>";
                                htmlStr += "<td>" + element.owner + "</td>";
                                htmlStr += "<td><a href=\"javascript:void(0);\" activityId=\"" + element.id + "\" style=\"text-decoration: none;\">";
                                htmlStr += "<span class=\"glyphicon glyphicon-remove\"></span>解除关联</a></td>";
                                htmlStr += "</tr>";
                            });
                            //追加写入
                            $("#bundActivityTbody").append(htmlStr);
                        } else {
                            //关联失败,提示信息,模态窗口不关闭,已经关联过的市场活动列表也不刷新
                            alert(resp.msg);
                            $("#bundModal").modal("show");
                        }
                    }
                });
            });

            //"解除关联市场活动"a标签单击事件, 使用on的方式绑定事件, 因为tbody标签下只有一个a标签, 所以直接选择
            $("#bundActivityTbody").on("click", "a", function () {
                //收集参数
                var activityId = $(this).attr("activityId");
                var clueId = "${clue.id}";

                //弹出确认解除的窗口
                if (!window.confirm("确认解除关联市场活动?")) {
                    return;
                }
                //发起请求
                $.ajax({
                    url: "workbench/clue/saveUnbundActivity.do",
                    data: {
                        activityId: activityId,
                        clueId: clueId
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //解除成功之后,刷新已经关联的市场活动列表
                            //直接移除当前行
                            $("#tr_" + activityId).remove();
                        } else {
                            //解除失败,提示信息,列表也不刷新
                            alert(resp.msg);
                        }
                    }
                });
            });

            //备注的"保存"按钮单击事件, --> 表单验证后, 发送请求
            $("#saveCreateRemarkBtn").click(function () {
                var noteContent = $.trim($("#remark").val());
                var clueId = "${clue.id}";
                if (noteContent == "") {
                    alert("备注内容不能为空");
                    return;
                }

                $.ajax({
                    url: "workbench/clue/saveCreateClueRemark.do",
                    data: {
                        noteContent: noteContent,
                        clueId: clueId
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //添加成功之后,清空输入框,刷新备注列表
                            $("#remark").val("");
                            var htmlStr = "";
                            htmlStr += "<div class=\"remarkDiv\" id=\"div_" + resp.retData.id + "\" style=\"height: 60px;\">";
                            htmlStr += "<img title=\"${sessionUser.name}\" src=\"image/user-thumbnail.png\" style=\"width: 30px; height:30px;\">";
                            htmlStr += "<div style=\"position: relative; top: -40px; left: 40px;\">";
                            htmlStr += "<h5>" + noteContent + "</h5>";
                            htmlStr += "<font color=\"gray\">线索</font> <font color=\"gray\">-</font> <b>${clue.fullname}${clue.appellation}-${clue.company}</b>";
                            htmlStr += "<small style=\"color: gray;\"> " + resp.retData.createTime + " 由${sessionUser.name}创建</small>";
                            htmlStr += "<div style=\"position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;\">";
                            htmlStr += "<a class=\"myHref\" name=\"editRemarkA\" remarkId=\"" + resp.retData.id + "\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-edit\"";
                            htmlStr += " style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr += "&nbsp;&nbsp;&nbsp;&nbsp;";
                            htmlStr += "<a class=\"myHref\" name=\"deleteRemarkA\" remarkId=\"" + resp.retData.id + "\" href=\"javascript:void(0);\"><span class=\"glyphicon glyphicon-remove\"";
                            htmlStr += " style=\"font-size: 20px; color: #E6E6E6;\"></span></a>";
                            htmlStr += "</div>";
                            htmlStr += "</div>";
                            htmlStr += "</div>";
                            $("#remarkDiv").before(htmlStr);
                        } else {
                            //添加失败,提示信息,输入框不清空,列表也不刷新
                            alert(resp.msg);
                        }
                    }
                });
            });

            //"删除备注"图标单击事件
            $("#queryRemarkListDiv").on("click", "a[name='deleteRemarkA']", function () {
                var remarkId = $(this).attr("remarkId");
                $.ajax({
                    url: "workbench/clue/deleteClueRemarkById.do",
                    data: {
                        remarkId: remarkId
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //删除成功之后,刷新备注列表
                            $("#div_" + remarkId).remove();
                        } else {
                            //删除失败,提示信息,备注列表不刷新
                            alert(resp.msg);
                        }
                    }
                });
            });

            //"修改备注"图标单击事件, -->remarkId放入隐藏域, noteContent放入输入框, 弹出模态窗口
            $("#queryRemarkListDiv").on("click", "a[name='editRemarkA']", function () {
                var remarkId = $(this).attr("remarkId");
                var noteContent = $("#div_" + remarkId + " h5").html();
                //remarkId放入隐藏域, noteContent放入输入框
                $("#remarkId").val(remarkId);
                $("#edit-noteContent").val(noteContent);
                $("#editRemarkModal").modal("show");
            });

            //修改备注模态创库"更新"按钮的单击事件-->表单验证, 发起请求, 接收响应
            $("#updateRemarkBtn").click(function () {
                //收集参数
                var remarkId = $("#remarkId").val();
                var noteContent = $.trim($("#edit-noteContent").val());
                if (noteContent == "") {
                    alert("备注内容不能为空");
                    return;
                }
                $.ajax({
                    url: "workbench/clue/saveEditClueRemark.do",
                    data: {
                        id: remarkId,
                        noteContent: noteContent
                    },
                    type: "post",
                    dataType: "json",
                    success: function (resp) {
                        if (resp.code == "1") {
                            //删除成功之后,刷新备注列表
                            //关闭模态窗口
                            $("#editRemarkModal").modal("hide");
                            //更新被修改记录的 noteContent, editTime, editBy
                            $("#div_" + remarkId + " h5").html(noteContent);
                            $("#div_" + remarkId + " small").html(resp.retData.editTime + " 由${sessionUser.name}修改");
                        } else {
                            //删除失败,提示信息,备注列表不刷新
                            alert(resp.msg);
                            $("#editRemarkModal").modal("show");
                        }
                    }
                });
            });
        });

    </script>

</head>
<body>

<!-- 关联市场活动的模态窗口 -->
<div class="modal fade" id="bundModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 80%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title">关联市场活动</h4>
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
                <table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
                    <thead>
                    <tr style="color: #B3B3B3;">
                        <td><input type="checkbox"/></td>
                        <td>名称</td>
                        <td>开始日期</td>
                        <td>结束日期</td>
                        <td>所有者</td>
                        <td></td>
                    </tr>
                    </thead>
                    <tbody id="queryActivityResTbody">
                    <%--<tr>
                        <td><input type="checkbox"/></td>
                        <td>发传单</td>
                        <td>2020-10-10</td>
                        <td>2020-10-20</td>
                        <td>zhangsan</td>
                    </tr>--%>
                    </tbody>
                </table>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" class="btn btn-primary" id="bundActivityBtn">关联</button>
            </div>
        </div>
    </div>
</div>

<!-- 修改线索备注的模态窗口 -->
<div class="modal fade" id="editRemarkModal" role="dialog">
    <%-- 备注的id --%>
    <input type="hidden" id="remarkId">
    <div class="modal-dialog" role="document" style="width: 40%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">修改备注</h4>
            </div>
            <div class="modal-body">
                <form class="form-horizontal" role="form">
                    <div class="form-group">
                        <label for="edit-noteContent" class="col-sm-2 control-label">内容</label>
                        <div class="col-sm-10" style="width: 81%;">
                            <textarea class="form-control" rows="3" id="edit-noteContent"></textarea>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
            </div>
        </div>
    </div>
</div>

<!-- 返回按钮 -->
<div style="position: relative; top: 35px; left: 10px;">
    <a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left"
                                                                         style="font-size: 20px; color: #DDDDDD"></span></a>
</div>

<!-- 大标题 -->
<div style="position: relative; left: 40px; top: -30px;">
    <div class="page-header">
        <h3>李四先生
            <small>动力节点</small>
        </h3>
    </div>
    <div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
        <button type="button" class="btn btn-default"
                onclick="window.location.href='workbench/clue/toConvert.do?id=${clue.id}';"><span
                class="glyphicon glyphicon-retweet"></span> 转换
        </button>

    </div>
</div>

<br/>
<br/>
<br/>

<!-- 详细信息 -->
<div style="position: relative; top: -70px;">
    <div style="position: relative; left: 40px; height: 30px;">
        <div style="width: 300px; color: gray;">名称</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;">
            <b>${clue.fullname}${clue.appellation}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.owner}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 10px;">
        <div style="width: 300px; color: gray;">公司</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.company}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.job}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 20px;">
        <div style="width: 300px; color: gray;">邮箱</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.email}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.phone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 30px;">
        <div style="width: 300px; color: gray;">公司网站</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.website}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.mphone}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 40px;">
        <div style="width: 300px; color: gray;">线索状态</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.state}</b></div>
        <div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
        <div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${clue.source}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 50px;">
        <div style="width: 300px; color: gray;">创建者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.createBy}&nbsp;&nbsp;</b>
            <small style="font-size: 10px; color: gray;">${clue.createTime}</small>
        </div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 60px;">
        <div style="width: 300px; color: gray;">修改者</div>
        <div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${clue.editBy}&nbsp;&nbsp;</b>
            <small style="font-size: 10px; color: gray;">${clue.editTime}</small>
        </div>
        <div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 70px;">
        <div style="width: 300px; color: gray;">描述</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>${clue.description}</b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 80px;">
        <div style="width: 300px; color: gray;">联系纪要</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>${clue.contactSummary}</b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 90px;">
        <div style="width: 300px; color: gray;">下次联系时间</div>
        <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${clue.nextContactTime}</b></div>
        <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
    </div>
    <div style="position: relative; left: 40px; height: 30px; top: 100px;">
        <div style="width: 300px; color: gray;">详细地址</div>
        <div style="width: 630px;position: relative; left: 200px; top: -20px;">
            <b>${clue.address}</b>
        </div>
        <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
    </div>
</div>

<!-- 备注 -->
<div style="position: relative; top: 40px; left: 40px;" id="queryRemarkListDiv">
    <div class="page-header">
        <h4>备注</h4>
    </div>

    <!-- 备注1 -->
    <%--<div class="remarkDiv" style="height: 60px;">
        <img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
        <div style="position: relative; top: -40px; left: 40px;">
            <h5>哎呦！</h5>
            <font color="gray">线索</font> <font color="gray">-</font> <b>李四先生-动力节点</b>
            <small style="color: gray;"> 2017-01-22 10:10:10 由zhangsan</small>
            <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-edit"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
                &nbsp;&nbsp;&nbsp;&nbsp;
                <a class="myHref" href="javascript:void(0);"><span class="glyphicon glyphicon-remove"
                                                                   style="font-size: 20px; color: #E6E6E6;"></span></a>
            </div>
        </div>
    </div>--%>

    <c:forEach items="${clueRemarkList}" var="remark">
        <div class="remarkDiv" style="height: 60px;" id="div_${remark.id}">
            <img title="${remark.createBy}" src="image/user-thumbnail.png" style="width: 30px; height:30px;">
            <div style="position: relative; top: -40px; left: 40px;" id="div_${remark.id}">
                <h5>${remark.noteContent}</h5>
                <font color="gray">线索</font> <font color="gray">-</font>
                <b>${clue.fullname}${clue.appellation}-${clue.company}</b>
                <small style="color: gray;">
                        ${remark.editFlag=="0"?remark.createTime:remark.editTime}
                    由${remark.editFlag=="0"?remark.createBy:remark.editBy}${remark.editFlag=="0"?"创建":"修改"}
                </small>
                <div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">
                    <a class="myHref" name="editRemarkA" remarkId="${remark.id}" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-edit"
                            style="font-size: 20px; color: #E6E6E6;"></span></a>
                    &nbsp;&nbsp;&nbsp;&nbsp;
                    <a class="myHref" name="deleteRemarkA" remarkId="${remark.id}" href="javascript:void(0);"><span
                            class="glyphicon glyphicon-remove"
                            style="font-size: 20px; color: #E6E6E6;"></span></a>
                </div>
            </div>
        </div>
    </c:forEach>

    <div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
        <form role="form" style="position: relative;top: 10px; left: 10px;">
            <textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"
                      placeholder="添加备注..."></textarea>
            <p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
                <button id="cancelBtn" type="button" class="btn btn-default">取消</button>
                <button type="button" id="saveCreateRemarkBtn" class="btn btn-primary">保存</button>
            </p>
        </form>
    </div>
</div>

<!-- 市场活动 -->
<div>
    <div style="position: relative; top: 60px; left: 40px;">
        <div class="page-header">
            <h4>市场活动</h4>
        </div>
        <div style="position: relative;top: 0px;">
            <table class="table table-hover" style="width: 900px;">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td>名称</td>
                    <td>开始日期</td>
                    <td>结束日期</td>
                    <td>所有者</td>
                    <td></td>
                </tr>
                </thead>
                <tbody id="bundActivityTbody">
                <%--<tr>
                    <td>发传单</td>
                    <td>2020-10-10</td>
                    <td>2020-10-20</td>
                    <td>zhangsan</td>
                    <td><a href="javascript:void(0);" style="text-decoration: none;"><span
                            class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                </tr>--%>
                <c:forEach items="${activityList}" var="activity">
                    <tr id="tr_${activity.id}">
                        <td>${activity.name}</td>
                        <td>${activity.startDate}</td>
                        <td>${activity.endDate}</td>
                        <td>${activity.owner}</td>
                        <td><a href="javascript:void(0);" activityId="${activity.id}"
                               style="text-decoration: none;"><span
                                class="glyphicon glyphicon-remove"></span>解除关联</a></td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>

        <div>
            <a href="javascript:void(0);" id="bundActivityA" style="text-decoration: none;"><span
                    class="glyphicon glyphicon-plus"></span>关联市场活动</a>
        </div>
    </div>
</div>


<div style="height: 200px;"></div>
</body>
</html>