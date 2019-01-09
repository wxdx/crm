<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script>
		$(function () {
		    rollback();
		    function rollback() {
                var i = 1;
                $.get(
                    "settings/dictionary/value/list.do",
                    function (data) {
                        $(data).each(function () {
                            $("#tBody").append("<tr class='active'><td><input type='checkbox' name='valueId' value='"+this.id+"'></td><td>"
								+(i++)+"</td><td>"
								+this.value+"</td><td>"
								+this.text+"</td><td>"
								+this.orderNo+"</td><td>"
								+this.typeCode+"</td></tr>");
                        })
                    },
                    "json"
                )
            }
            $("#valueEditBtn").click(function () {
                var $valueId = $("input:checkbox[name='valueId']:checked");
                if ($valueId.length == 0){
                    alert("请选择一条记录来修改");
				} else if ($valueId.length > 1){
                    alert("不能同时修改多条记录");
				} else {
                    window.location.href="settings/dictionary/value/edit.jsp?id=" +$valueId.val();
				}
            });
            $("#valueDeleteBtn").click(function () {
                var $valueId = $("input:checkbox[name='valueId']:checked");
                if ($valueId.length == 0){
                    alert("请至少选择一条记录来修改");
                } else {
                    if (confirm("你确定删除吗?")) {
                        var path = "?";
                        for (var i = 0; i < $valueId.length; i++) {
                            if (i === 0) {
                                path += "id=" + $valueId[i].value;
                            } else {
                                path += "&id=" + $valueId[i].value;
                            }
                        }
                        window.location.href = "settings/dictionary/value/delete.do" + path;
                    }
                }
            });
            $("#qx").click(function () {
                var $qx = $("#qx");
                var $xz = $("input:checkbox[name='valueId']");
                if ($qx[0].checked){
                    for (var i = 0;i < $xz.length;i++){
                        $xz[i].checked = true;
                    }
                }  else {
                    for (var i = 0;i < $xz.length;i++){
                        $xz[i].checked = false;
                    }
                }
            })

        })
	</script>
</head>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典值列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settings/dictionary/value/save.jsp'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" id="valueEditBtn" class="btn btn-default" ><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" id="valueDeleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="qx"></td>
					<td>序号</td>
					<td>字典值</td>
					<td>文本</td>
					<td>排序号</td>
					<td>字典类型编码</td>
				</tr>
			</thead>
			<tbody id="tBody">
				<%--<tr class="active">
					<td><input type="checkbox" /></td>
					<td>1</td>
					<td>m</td>
					<td>男</td>
					<td>1</td>
					<td>sex</td>
				</tr>
				<tr>
					<td><input type="checkbox" /></td>
					<td>2</td>
					<td>f</td>
					<td>女</td>
					<td>2</td>
					<td>sex</td>
				</tr>
				<tr class="active">
					<td><input type="checkbox" /></td>
					<td>3</td>
					<td>1</td>
					<td>一级部门</td>
					<td>1</td>
					<td>orgType</td>
				</tr>
				<tr>
					<td><input type="checkbox" /></td>
					<td>4</td>
					<td>2</td>
					<td>二级部门</td>
					<td>2</td>
					<td>orgType</td>
				</tr>
				<tr class="active">
					<td><input type="checkbox" /></td>
					<td>5</td>
					<td>3</td>
					<td>三级部门</td>
					<td>3</td>
					<td>orgType</td>
				</tr>--%>
			</tbody>
		</table>
	</div>
	
</body>
</html>