<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName()
            + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <title>Title</title>
    <base href="<%=basePath%>"/>
    <%--引入jquery, bootstrap--%>
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <%--引入bs_typehead--%>
    <script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
    <script type="text/javascript">
        $(function () {
            /*$("#typeahead").typeahead({
                source:function (query, process) {
                    return ["a1", "a2", "b1", "b2", "b3"];
                }
            });*/
            // Workaround for bug in mouse item selection
            /*$.fn.typeahead.Constructor.prototype.blur = function() {
                var that = this;
                setTimeout(function () { that.hide() }, 250);
            };*/

            //使用typeahead发送异步请求, 将数据填充至建议列表
            $('#typeahead').typeahead({
                source: function (query, process) {
                    $.ajax({
                        url: "workbench/transaction/queryActivityByName.do",
                        data: {
                            activityName: $.trim(query)
                        },
                        type: "get",
                        dataType: "json",
                        success: function (resp) {
                            process(resp);
                        }
                    });
                },
                updater: function (item) {
                    $("#typeahead").after("<br/><b>" + item.id + "</b>");
                    return "==" + item.name + "==";
                }
            });

            /*//测试typeahead的事件函数
            $('.typeahead').bind('typeahead:select', function(ev, suggestion) {
                console.log('Selection: ' + suggestion);
            });*/

            /*,
            select:function() {
                //console.log(ev+ " ==== " + suggestion +" ==== "+this.value);
                console.log(" ==== "+this.value);
            }*/
        });
    </script>
</head>
<body>
<input type="text" id="typeahead"/>
</body>
</html>
