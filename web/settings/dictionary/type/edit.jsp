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
			   var codeValue;
				var code = "${param.code}";
				$.get(
				    "settings/dictionary/type/getOneType.do",
					{"code":code},
					function (data) {
						$("#code").val(data.code);
						codeValue = data.code;
						$("#oldCode").val(data.code);
						$("#name").val(data.name);
						$("#description").val(data.description);
                    },
					"json"
				)

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
                                    if ($("#code").val() == codeValue) {
                                        $("#codeErrorMsg").text("");
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
                $("#UpdateBtn").click(function () {
                    //校验表单
                    $("#code").blur();
                    //校验通过提交表单

                    if ($("#codeErrorMsg").text() == ""){
                        $("#updateForm").submit();
                    }
                });
            }

        })
	</script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>修改字典类型</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="UpdateBtn">更新</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" action="settings/dictionary/type/update.do" method="post" role="form" id="updateForm">
					
		<div class="form-group">
			<label for="create-code" class="col-sm-2 control-label">编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="code" name="code" style="width: 200%;" placeholder="编码作为主键，不能是中文" >
				<span id="codeErrorMsg" style="color: red;font-size: 12px"></span>
			</div>
		</div>
		<input type="hidden" id="oldCode" name="oldCode">
		
		<div class="form-group">
			<label for="create-name" class="col-sm-2 control-label">名称</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="name" name="name" style="width: 200%;"  >
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 300px;">
				<textarea class="form-control" rows="3" id="description" name="description" style="width: 200%;">描述信息</textarea>
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>