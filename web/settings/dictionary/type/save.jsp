<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">


	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<script>
		$(function () {
		    rollback();
			function rollback() {
				$("#code").blur(function () {
					var code = $.trim(this.value);
					if (code == ""){
					    $("#codeErrorMsg").text("编码不能为空");
					} else {
                        var regExp = /^[a-zA-Z0-9]+$/;
                        var ok = regExp.test(code);
                        if (ok) {
                            $("#codeErrorMsg").text("");

							$.ajaxSetup({
								async : false
							});
                            //验证编码是否重复
                            $.ajax({
								type:"get",
								url:"settings/dictionary/type/checkCode.do",
								data:{"code" : code,"_":new Date().getTime()},
								success:function (json) {
									if (json.success){
                                        //可用的编码
                                        $("#codeErrorMsg").text("");
                                    } else {
                                        //不可用
                                        $("#codeErrorMsg").text("该编码已存在!");
                                    }
                                    $.ajaxSetup({
                                        async : true
                                    });
                                }
							});
                        } else {
                            $("#codeErrorMsg").text("编码只能包含字母和数字");
                        }
                    }
                });
                $("#code").focus(function () {
                    if ($("#codeErrorMsg").text() != "") {
                        $("#code").val("");
                        $("#codeErrorMsg").text("");
                    }
                });
				$("#addTypeBtn").click(function () {
					//校验表单
					$("#code").blur();
					//校验通过提交表单
					if ($("#codeErrorMsg").text() == ""){
					    $("#addTypeForm").submit();
					}
                });
            }
        })
	</script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>新增字典类型</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="addTypeBtn">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" id="addTypeForm" action="settings/dictionary/type/save.do" method="post" role="form">
					
		<div class="form-group">
			<label for="create-code" class="col-sm-2 control-label">编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="code" id="code" style="width: 200%;" placeholder="编码作为主键，不能是中文">
				<span id="codeErrorMsg" style="color: red;font-size: 12px"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-name" class="col-sm-2 control-label">名称</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="name" id="name" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 300px;">
				<textarea class="form-control" rows="3" name="description" id="description" style="width: 200%;"></textarea>
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>