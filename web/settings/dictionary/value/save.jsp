<%@ page import="com.wkcto.crm.utils.UUIDGenerator" %>
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
		callback();
		function callback() {
			$.get(
			    "settings/dictionary/value/getType.do",
				function (data) {
					$(data).each(function () {
						$("#typeCode").append("<option value='"+this.code+"'>"+this.name+"</option>");
                    });
                },
				"json"
			);
			$("#value").blur(function () {
			    var value = $("#value").val();
                if (value == ""){
                    $("#valueErrorMsg").text("字典值不能为空");
                } else {
                    var typeCode = $.trim($("#typeCode").val());
                    $.ajaxSetup({
                        async : false
                    });
					$.get(
					    "settings/dictionary/value/checkValue.do",
						{"typeCode":typeCode,"value":value},
						function (data) {
							if (data.result){
                                $("#valueErrorMsg").text("");
							} else {
                                $("#valueErrorMsg").text("所选字典类型下该字典值已存在");
							}
                            $.ajaxSetup({
                                async : true
                            });
                        },
						"json"
					)

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
                var regExp = /^[1-9][0-9]*$/;
                var ok = regExp.test(orderNo);
                if (ok){
                    $("#orderNoErrorMsg").text("");
				} else {
                    if (orderNo != "") {
                        $("#orderNoErrorMsg").text("排序号只能是正整数");
                    }
				}
			});
            $("#orderNo").focus(function () {
                if ($("#orderNoErrorMsg").text() != "") {
                    $("#orderNo").val("");
                    $("#orderNoErrorMsg").text("");
                }
            });
			$("#save").click(function () {
			    //校验表单
                $("#value").blur();
                $("#orderNo").blur();
				//提交表单
                if ($("#valueErrorMsg").text() == "" && $("#orderNoErrorMsg").text() == ""){
                    $("#valueForm").submit();
                }

            });

        }
    })
</script>
</head>
<body>

	<div style="position:  relative; left: 30px;">
		<h3>新增字典值</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="save">保存</button>
			<button type="button" class="btn btn-default" onclick="window.history.back();">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" action="settings/dictionary/value/save.do" method="post" role="form" id="valueForm">
		<input type="hidden" name="id" value="<%=UUIDGenerator.generate()%>">
		<div class="form-group">
			<label for="create-dicTypeCode" class="col-sm-2 control-label">字典类型编码<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="typeCode" name="typeCode" style="width: 200%;">
				 <%-- <option></option>
				  <option>性别</option>
				  <option>机构类型</option>--%>
				</select>
				<span id="codeErrorMsg" style="color: red;font-size: 12px"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-dicValue" class="col-sm-2 control-label">字典值<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="value" name="value" style="width: 200%;">
				<span id="valueErrorMsg" style="color: red;font-size: 12px"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-text" class="col-sm-2 control-label">文本</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="text" name="text" style="width: 200%;">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-orderNo" class="col-sm-2 control-label">排序号</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="orderNo" name="orderNo" style="width: 200%;">
				<span id="orderNoErrorMsg" style="color: red;font-size: 12px"></span>
			</div>
		</div>
	</form>
	
	<div style="height: 200px;"></div>
</body>
</html>