<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">


    <!-- jquery -->
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
    <!-- bootstrap 3-->
    <link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <!-- bootstrap datetimepicker-->
    <link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css"
          rel="stylesheet"/>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <!-- bootstrap pagination-->
    <link href="jquery/bootstrap_pagination/jquery.bs_pagination.css" type="text/css" rel="stylesheet"/>
    <script type="text/javascript" src="jquery/bootstrap_pagination/jquery.bs_pagination.js"></script>
    <script type="text/javascript" src="jquery/bootstrap_pagination/en.js"></script>

    <script type="text/javascript">

        $(function () {

            //定制字段
            $("#definedColumns > li").click(function (e) {
                //防止下拉菜单消失
                e.stopPropagation();
            });
            display(1, 5);
            $("#pageQueryBtn").click(function () {
                $("#h-owner").val($.trim($("#q-owner").val()));
                $("#h-name").val($.trim($("#q-name").val()));
                $("#h-customerName").val($.trim($("#q-customerName").val()));
                $("#h-stage").val($.trim($("#q-stage").val()));
                $("#h-type").val($.trim($("#q-type").val()));
                $("#h-source").val($.trim($("#q-source").val()));
                $("#h-contactName").val($.trim($("#q-contactName").val()));
                display(1, $("#tranPagination").bs_pagination("getOption", "rowsPerPage"));
            });
            $("#qx").click(function () {
                $(":checkbox[name='id']").prop("checked", this.checked);
                $("#tBody").on("click", ":checkbox[name='id']", function () {
                    $("#qx").prop("checked", $(":checkbox[name='id']").size() == $(":checkbox[name='id']:checked").size());
                });
            });
            $("#editBtn").click(function () {
                var $xz = $(":checkbox[name='id']:checked");
                if ($xz.length == 0) {
                    alert("请选择一条记录来修改");
                } else if ($xz.length > 1) {
                    alert("不能同时修改多条记录");
                } else {
                    var id = $xz[0].value;
                    window.location.href = "workbench/tran/edit.do?id=" + id;
                }
            });
            $("#deleteBtn").click(function () {
                var $id = $(":checkbox[name='id']:checked");
                if ($id.length == 0) {
                    alert("请至少选择一条记录来删除");
                } else {
                    if (confirm("你确定删除吗?")) {
                        var path = "";
                        for (var i = 0; i < $id.length; i++) {
                            if (i === 0) {
                                path += "id=" + $id[i].value;
                            } else {
                                path += "&id=" + $id[i].value;
                            }
                        }
                        $("#qx").prop("checked", false);
                        $.post(
                            "workbench/tran/delete.do",
                            path,
                            function (json) {
                                if (json.success) {
                                    display(1, $("#tranPagination").bs_pagination("getOption", "rowsPerPage"));
                                }
                            }
                        );

                    }
                }
            });
            $("#exportAllBtn").click(function () {
                if (confirm("你确定导出全部数据吗?")) {
                    window.location.href = "workbench/tran/exportAll.do";
                }
            });
            $("#exportAllCheckBtn").click(function () {
                var $xz = $(":checkbox[name='id']:checked");
                if ($xz.length == 0) {
                    alert("请选择要导出的数据")
                } else {
                    var path = "";
                    for (var i = 0; i < $xz.length; i++) {
                        path += "&id=" + $xz[i].value;
                    }
                    path = path.substr(1);
                    if (confirm("你确定导出选中的数据吗?")) {
                        window.location.href = "workbench/tran/exportCheckAll.do?" + path;
                    }
                }
            });
            $("#importExcelBtn").click(function () {
                $.ajax({
                    type: "post",
                    url: "workbench/tran/import.do",
                    data: new FormData($('#importFileForm')[0]),
                    processData: false,
                    contentType: false,
                    success: function (json) {
                        if (json.success) {
                            $("#importClueModal").modal("hide");
                            display(1, $("#tranPagination").bs_pagination("getOption", "rowsPerPage"));
                        } else {
                            alert("导入失败!");
                        }
                    }

                });
            });

        });

        function display(pageNo, pageSize) {
            $("#tBody").html("");
            $("#qx").prop("checked", false);
            $.get(
                "workbench/tran/page.do",
                {
                    "pageNo": pageNo,
                    "pageSize": pageSize,
                    "owner": $("#h-owner").val(),
                    "name": $("#h-name").val(),
                    "customerName": $("#h-customerName").val(),
                    "stage": $("#h-stage").val(),
                    "type": $("#h-type").val(),
                    "source": $("#h-source").val(),
                    "contactName": $("#h-contactName").val(),
                    "_": new Date().getTime()
                },
                function (json) {
                    $(json.aList).each(function () {
                        $("#tBody").append('<tr> <td><input type="checkbox" name="id" value="' + this.id + '" /></td> <td><a style="text-decoration: none; cursor: pointer;" onclick=\'window.location.href="workbench/tran/detail.do?id=' + this.id + '";\'>' + this.name + '</a></td> <td>' + this.customerName + '</td> <td>' + this.stage + '</td> <td>' + this.type + '</td> <td>' + this.owner + '</td> <td>' + this.source + '</td> <td>' + this.contactName + '</td> </tr>');
                    });
                    var totalPages = Math.ceil(json.total / pageSize);
                    $("#tranPagination").bs_pagination({
                        currentPage: pageNo, //页码pageNo
                        rowsPerPage: pageSize, //每页显示条数 pageSize
                        totalPages: totalPages,//总页数
                        totalRows: json.total,//总记录条数
                        visiblePageLinks: 3,//显示的卡片数
                        showGoToPage: true,
                        showRowsPerPage: true,
                        showRowsInfo: true,
                        onChangePage: function (event, data) {
                            $("#q-owner").val($.trim($("#h-owner").val()));
                            $("#q-name").val($.trim($("#h-name").val()));
                            $("#q-customerName").val($.trim($("#h-customerName").val()));
                            $("#q-stage").val($.trim($("#h-stage").val()));
                            $("#q-type").val($.trim($("#h-type").val()));
                            $("#q-source").val($.trim($("#h-source").val()));
                            $("#q-contactName").val($.trim($("#h-contactName").val()));
                            display(data.currentPage, data.rowsPerPage);
                        }
                    });

                }
            )
        };

    </script>
</head>
<body>

<input type="hidden" id="h-owner">
<input type="hidden" id="h-name">
<input type="hidden" id="h-customerName">
<input type="hidden" id="h-stage">
<input type="hidden" id="h-type">
<input type="hidden" id="h-source">
<input type="hidden" id="h-contactName">

<!-- 导入交易的模态窗口 -->
<div class="modal fade" id="importClueModal" role="dialog">
    <div class="modal-dialog" role="document" style="width: 85%;">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">
                    <span aria-hidden="true">×</span>
                </button>
                <h4 class="modal-title" id="myModalLabel">导入交易</h4>
            </div>
            <div class="modal-body" style="height: 350px;">
                <div style="position: relative;top: 20px; left: 50px;">
                    请选择要上传的文件：
                    <small style="color: gray;">[仅支持.xls或.xlsx格式]</small>
                </div>
                <div style="position: relative;top: 40px; left: 50px;">
                    <form id="importFileForm">
                        <input type="file" name="f1">
                    </form>
                </div>
                <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;">
                    <h3>重要提示</h3>
                    <ul>
                        <li>给定文件的第一行将视为字段名。</li>
                        <li>请确认您的文件大小不超过5MB。</li>
                        <li>从XLS/XLSX文件中导入全部重复记录之前都会被忽略。</li>
                        <li>复选框值应该是1或者0。</li>
                        <li>日期值必须为MM/dd/yyyy格式。任何其它格式的日期都将被忽略。</li>
                        <li>日期时间必须符合MM/dd/yyyy hh:mm:ss的格式，其它格式的日期时间将被忽略。</li>
                        <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                        <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                    </ul>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="importExcelBtn">导入</button>
            </div>
        </div>
    </div>
</div>

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
                        <input class="form-control" type="text" id="q-owner">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">名称</div>
                        <input class="form-control" type="text" id="q-name">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">客户名称</div>
                        <input class="form-control" type="text" id="q-customerName">
                    </div>
                </div>

                <br>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">阶段</div>
                        <select class="form-control" id="q-stage">
                            <option value=""></option>
                            <c:forEach items="${stageList}" var="s">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">类型</div>
                        <select class="form-control" id="q-type">
                            <option value=""></option>
                            <c:forEach items="${transactionTypeList}" var="s">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">来源</div>
                        <select class="form-control" id="q-source">
                            <option value=""></option>
                            <c:forEach items="${sourceList}" var="s">
                                <option value="${s.value}">${s.text}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">联系人名称</div>
                        <input class="form-control" type="text" id="q-contactName">
                    </div>
                </div>

                <button type="button" class="btn btn-default" id="pageQueryBtn">查询</button>

            </form>
        </div>
        <div class="btn-toolbar" role="toolbar"
             style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-primary"
                        onclick="window.location.href='workbench/transaction/save.jsp';"><span
                        class="glyphicon glyphicon-plus"></span> 创建
                </button>
                <button type="button" class="btn btn-default" id="editBtn"><span
                        class="glyphicon glyphicon-pencil"></span> 修改
                </button>
                <button type="button" class="btn btn-danger" id="deleteBtn"><span
                        class="glyphicon glyphicon-minus"></span> 删除
                </button>
            </div>
            <div class="btn-group" style="position: relative; top: 18%;">
                <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importClueModal"><span
                        class="glyphicon glyphicon-import"></span> 导入
                </button>
                <button type="button" class="btn btn-default" id="exportAllCheckBtn"><span
                        class="glyphicon glyphicon-export"></span> 导出选中
                </button>
                <button type="button" class="btn btn-default" id="exportAllBtn"><span
                        class="glyphicon glyphicon-export"></span> 导出全部
                </button>
            </div>

        </div>
        <div style="position: relative;top: 10px;">
            <table class="table table-hover">
                <thead>
                <tr style="color: #B3B3B3;">
                    <td><input type="checkbox" id="qx"/></td>
                    <td>名称</td>
                    <td>客户名称</td>
                    <td>阶段</td>
                    <td>类型</td>
                    <td>所有者</td>
                    <td>来源</td>
                    <td>联系人名称</td>
                </tr>
                </thead>
                <tbody id="tBody">
                <%--<tr>
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.jsp';">动力节点-交易01</a></td>
                    <td>动力节点</td>
                    <td>谈判/复审</td>
                    <td>新业务</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>李四</td>
                </tr>
                <tr class="active">
                    <td><input type="checkbox" /></td>
                    <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='workbench/transaction/detail.jsp';">动力节点-交易01</a></td>
                    <td>动力节点</td>
                    <td>谈判/复审</td>
                    <td>新业务</td>
                    <td>zhangsan</td>
                    <td>广告</td>
                    <td>李四</td>
                </tr>--%>
                </tbody>
            </table>
            <div id="tranPagination"></div>
        </div>
    </div>

</div>
</body>
</html>