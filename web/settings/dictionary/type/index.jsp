<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">

	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
</head>
<script>
	$(function () {
		getList();
		function getList() {
		    var i = 1;
			$.get(
			    "settings/dictionary/type/list.do",
				function (data) {
					$(data).each(function () {
						$("#tBody").append("<tr class='active'><td><input type='checkbox' name='dicTypeNo' value="+this.code+"></td><td>"+(i++)+
							"</td><td>"+this.code+
							"</td><td>"+this.name+
							"</td><td>"+this.description+
							"</td></tr>");
                    })
                },
				"json"
			)
        }
        $("#typeEditBtn").click(function () {
			var $dicTypeNO = $("input:checkbox[name='dicTypeNo']:checked");
			if ($dicTypeNO.length == 0){
			    alert("请选择一条记录来修改");
			} else if ($dicTypeNO.length > 1) {
			    alert("不能同时修改多条记录")
			} else {
                window.location.href="settings/dictionary/type/edit.jsp?code=" +$dicTypeNO.val();
			}
        });
        $("#typeDeleteBtn").click(function () {
            var $dicTypeNO = $("input:checkbox[name='dicTypeNo']:checked");
            if ($dicTypeNO.length == 0){
                alert("请至少选择一条记录来删除");
            } else {
                if (confirm("你确定删除吗?")) {
                    var path = "?";
                    for (var i = 0; i < $dicTypeNO.length; i++) {
                        if (i === 0) {
                            path += "code=" + $dicTypeNO[i].value;
                        } else {
                            path += "&code=" + $dicTypeNO[i].value;
                        }
                    }
                    window.location.href = "settings/dictionary/type/delete.do" + path;
                }
            }
        });
		$("#qx").click(function () {
		    var $qx = $("#qx");
			var $xz = $("input:checkbox[name='dicTypeNo']");
			if ($qx[0].checked){
			    for (var i = 0;i < $xz.length;i++){
			        $xz[i].checked = true;
				}
			}  else {
                for (var i = 0;i < $xz.length;i++){
                    $xz[i].checked = false;
                }
            }
        });

    })
</script>
<body>

	<div>
		<div style="position: relative; left: 30px; top: -10px;">
			<div class="page-header">
				<h3>字典类型列表</h3>
			</div>
		</div>
	</div>
	<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;left: 30px;">
		<div class="btn-group" style="position: relative; top: 18%;">
		  <button type="button" class="btn btn-primary" onclick="window.location.href='settings/dictionary/type/save.jsp'"><span class="glyphicon glyphicon-plus"></span> 创建</button>
		  <button type="button" id="typeEditBtn" class="btn btn-default"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
		  <button type="button" id="typeDeleteBtn" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	<div style="position: relative; left: 30px; top: 20px;">
		<table class="table table-hover">
			<thead>
				<tr style="color: #B3B3B3;">
					<td><input type="checkbox" id="qx"></td>
					<td>序号</td>
					<td>编码</td>
					<td>名称</td>
					<td>描述</td>
				</tr>
			</thead>
			<tbody id="tBody">
				<%--<tr class="active">
					<td><input type="checkbox" /></td>
					<td>1</td>
					<td>sex</td>
					<td>性别</td>
					<td>性别包括男和女</td>
				</tr>--%>
			</tbody>
		</table>
	</div>
	
</body>
</html>