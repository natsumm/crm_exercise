<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName()
            + ":" + request.getServerPort() + request.getContextPath() + "/";
%>
<html>
<head>
    <title>测试echarts插件</title>
    <base href="<%=basePath%>"/>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <script type="text/javascript" src="jquery/echarts/echarts.min.js"></script>
    <script type="text/javascript">
        $(function () {
            //页面加载完毕时发送ajax的异步请求
            $.ajax({
                url: "workbench/chart/transaction/queryCountOfTranGroupByStage.do",
                type: "post",
                dataType: "json",
                success: function (resp) {
                    //1)基于准备好的dom，初始化echarts实例
                    var myChart = echarts.init(document.getElementById('main'));

                    //2)指定图表的配置项和数据
                    var option = {
                        title: {
                            text: '交易统计图表',
                            subtext: '各个阶段的统计数据'
                        },
                        tooltip: {
                            trigger: 'item',
                            formatter: "{a} <br/>{b} : {c}"
                        },
                        toolbox: {
                            feature: {
                                dataView: {readOnly: false},
                                restore: {},
                                saveAsImage: {}
                            }
                        },
                        series: [
                            {
                                name: '数据量',
                                type: 'funnel',
                                left: '10%',
                                width: '75%',
                                label: {
                                    formatter: '{b}'
                                },
                                labelLine: {
                                    show: false
                                },
                                itemStyle: {
                                    opacity: 0.8
                                },
                                emphasis: {
                                    label: {
                                        position: 'inside',
                                        formatter: '{b}: {c}'
                                    }
                                },
                                data: resp
                            }
                        ]
                    };

                    //3)使用刚指定的配置项和数据显示图表。
                    myChart.setOption(option);
                }
            });
        });
    </script>
</head>
<body>
<!-- 为 ECharts 准备一个具备大小（宽高）的 DOM -->
<div id="main" style="width: 800px;height:600px;"></div>
</body>
</html>
