<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">
    <!-- jquery -->
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <!-- baidu-echarts --->
    <script type="text/javascript" src="jquery/baidu-echarts/echarts.js"></script>
    <script type="text/javascript">
        $(function () {
            var showList;
            var max;
            var maxArray = new Array();
            var nameArray = new Array();
            $.ajaxSetup({
                async:false
            });
            $.get(
                "workbench/chart/tran.do",
                function (json) {
                    showList = json;
                    $.each(json,function (i,n) {
                        maxArray[i] = n.value;
                        nameArray[i] = n.name;
                    })
                    $.ajaxSetup({
                        async:true
                    });
                    max = Math.max.apply(null,maxArray);
                }
            )
            var tranChart = echarts.init($("#main")[0]);
            option = {
                title: {
                    text: '交易漏斗图',
                    subtext: '交易各阶段所占比重'
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
                legend: {
                    data: nameArray
                },
                calculable: true,
                series: [
                    {
                        name:'交易漏斗图',
                        type:'funnel',
                        left: '10%',
                        top: 60,
                        bottom: 60,
                        width: '80%',
                        min: 0,
                        max: max,
                        minSize: '0%',
                        maxSize: '100%',
                        sort: 'descending',
                        gap: 2,
                        label: {
                            normal: {
                                show: true,
                                position: 'inside'
                            },
                            emphasis: {
                                textStyle: {
                                    fontSize: 20
                                }
                            }
                        },
                        labelLine: {
                            normal: {
                                length: 10,
                                lineStyle: {
                                    width: 1,
                                    type: 'solid'
                                }
                            }
                        },
                        itemStyle: {
                            normal: {
                                borderColor: '#fff',
                                borderWidth: 1
                            }
                        },
                        data: showList
                    }
                ]
            };
            tranChart.setOption(option);
        });
    </script>
</head>
<body>
    <div id="main" style="width: 1000px;height:700px;"></div>
</body>
</html>