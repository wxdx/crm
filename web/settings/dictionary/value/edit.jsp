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
			var id = "${param.id}";
			var typeCode1;

            $.ajaxSetup({
                async : false
            });
			$.get(
				"settings/dictionary/value/getOneValue.do",
				{"id":id},
				function (data) {
					$("#id").val(data.id);
					typeCode1 = data.typeCode;
					$("#value").val(data.value);
					$("#text").val(data.text);
					$("#orderNo").val(data.orderNo);
                    $.ajaxSetup({
                        async : true
                    });
				},
				"json"
			);

            $.get(
                "settings/dictionary/value/getTypeName.do",
                {"typeCode1": typeCode1},
                function (data) {
                    $("#typeCode").val(data.name);
                },
                "json"
            );

			$("#value").blur(function () {
				var value = $.trim(this.value);
				if (value == ""){
					$("#valueErrorMsg").text("字典值不能为空");
				} else {
					$("#valueErrorMsg").text("");
				}
			});
			$("#value").focus(function () {
				if ($("#valueErrorMsg").text() != "") {
					$("#value").val("");
					$("#valueErrorMsg").text("");
				}
			});

			$("#orderNo").blur(function () {
				var orderNo = $.trim(this.value);
				var regExp = /^[0-9]+$/;
				var ok = regExp.test(orderNo);
				if (ok){
					$("#orderNoErrorMsg").text("");
				} else {
					$("#orderNoErrorMsg").text("排序号只能是数字");
				}

			});
			$("#orderNo").focus(function () {
				if ($("#orderNoErrorMsg").text() != "") {
					$("#orderNo").val("");
					$("#orderNoErrorMsg").text("");
				}
			});
			$("#UpdateBtn").click(function () {
				//校验表单
				$("#value").blur();
				$("#orderNo").blur();
				//提交表单
				if ($("#valueErrorMsg").text() == "" && $("#orderNoErrorMsg").text() == ""){
					$("#valueUpdateForm").submit();
				}
			});


        })
	</script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>修改字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="UpdateBtn">更新</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" action="settings/dictionary/value/update.do" method="post" role="form" id="valueUpdateForm">
		<input type="hidden" name="id" id="id">
		<div class="form-group">
			<label for="edit-dicTypeCode" class="col-sm-2 control-label">字典类型编码</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="typeCode" id="typeCode" style="width: 200%;" value="性别" readonly>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-dicValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="value" id="value" style="width: 200%;" value="m">
				<span id="valueErrorMsg" style="color: red;font-size: 12px"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="text" id="text" style="width: 200%;" value="男">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" name="orderNo" id="orderNo" style="width: 200%;" value="1">
				<span id="orderNoErrorMsg" style="color: red;font-size: 12px"></span>

			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>