<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ taglib prefix="C" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">

	<!-- jquery -->
	<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
	<!-- bootstrap 3-->
	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
	<!-- bootstrap datetimepicker-->
	<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
	<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
	<!-- bootstrap typeahead -->
	<script type="text/javascript" src="jquery/bootstrap-typeahead/bootstrap3-typeahead.js"></script>

	<script type="text/javascript" src="js/Source.js"></script>
	<script type="text/javascript" src="js/checkForm.js"></script>
<script type="text/javascript">
	var possibilityJson={
		<%
		   Map<String,String> possibilityMap = (Map<String,String>)application.getAttribute("possibilityMap");
		   Set<String> keys = possibilityMap.keySet();
		   int i = 0;
		   for(String key:keys){
		       String value = possibilityMap.get(key);
		       if (i < keys.size() - 1){
		%>
		"<%=key%>":<%=value%>,
		<%
		       } else {
		%>
    	"<%=key%>":<%=value%>
		<%
		       }
		       i++;
		   }
		 %>
	};
	$(function () {
        $(".time1").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            clearBtn: true,
            pickerPosition: "top-right"
        });
        $(".time").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            clearBtn: true,
            pickerPosition: "bottom-left"
        });
        $("#searchActivityBtn").click(function () {
            $("#searchForm")[0].reset();
            $("#h-inputName").val($("#inputName").val());
            getActivity("tBody");
            $("#findMarketActivity").modal("show");
        });
        $("#inputName").keydown(function (event) {
            if (event.keyCode == 13) {
                $("#h-inputName").val(this.value);
                getActivity("tBody");
                return false;
            }
        });
        $("#tBody").on("click",":radio[name='activity']:checked",function () {
            $("#h-activityId").val(this.value);
            $("#q-activityId").val(this.id);
            $("#findMarketActivity").modal("hide");
        });
		getOwner("owner");
        $("#owner").find("option[value='${user.id}']").prop("selected",true);

        $("#searchContactBtn").click(function () {
            $("#searchContactForm")[0].reset();
            $("#h-inputContactName").val($("#inputContactName").val());
            getContact("tBody1");
            $("#findContacts").modal("show");
        });
        $("#inputContactName").keydown(function (event) {
            if (event.keyCode == 13) {
                $("#h-inputContactName").val(this.value);
                getContact("tBody1");
                return false;
            }
        });
        $("#tBody1").on("click",":radio[name='contact']:checked",function () {
            $("#h-contactId").val(this.value);
            $("#q-contactId").val(this.id);
            $("#findContacts").modal("hide");
        });
        $("#stage").change(function () {
			$("#possibility").val(possibilityJson[this.value]);
        });
        $('#customerName').typeahead({
            source: function(query, process) {
                $.post(
                    "workbench/tran/autoCompleteCustomer.do",
                    {"name":query},
                    function (json) {
                        process(json);
                    }
                );
            },
            delay : 200
        });
		checkForm("owner","name","expectedDate","customerName","stage");
		clearErrorMsg("owner","name","expectedDate","customerName","stage");
        $("#tranSaveBtn").click(function () {
            $("#owner").change();
            $("#name").blur();
            $("#expectedDate").change();
            $("#customerName").blur();
            $("#stage").change();
            $.ajaxSetup({
                async:false
            });
            if ($("ownerErrorMsg").text()=="" && $("nameErrorMsg").text()=="" && $("expectedDateErrorMsg").text()=="" && $("customerNameErrorMsg").text()=="" && $("stageErrorMsg").text()=="") {
                $.get(
                    "workbench/customer/checkCustomerName.do",
                    {"name":$.trim($("#customerName").val())},
                    function (json) {
                        if (json.success) {
                            $("#h-customerId").val(json.id);
                        } else {
							alert("保存失败");
						}
                        $.ajaxSetup({
                            async:true
                        });

                    }
                );

                $.post(
                    "workbench/tran/save.do",
					{
                        "owner" : $("#owner").val(),
                        "money" : $("#money").val(),
                        "name" : $("#name").val(),
                        "expectedDate" : $("#expectedDate").val(),
                        "customerId" : $("#h-customerId").val(),
                        "stage" : $("#stage").val(),
                        "type" : $("#type").val(),
                        "source" : $("#source").val(),
                        "activityId" : $("#h-activityId").val(),
                        "contactsId" : $("#h-contactId").val(),
                        "description" : $("#description").val(),
                        "contactSummary" : $("#contactSummary").val(),
                        "nextContactTime" : $("#nextContactTime").val(),
                        "createBy" : "${user.name}"
                    },
					function (json) {
						if (json.success){
                            javascript:history.back(-1);
						}
                    }
				)


			}

        });
    });

</script>
</head>
<body>
<input type="hidden" id="h-activityId">
<input type="hidden" id="h-inputName">
<input type="hidden" id="h-inputContactName">
<input type="hidden" id="h-contactId">
<input type="hidden" id="h-customerId">
	<!-- 查找市场活动 -->
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form" id="searchForm">
						  <div class="form-group has-feedback">
						    	<input type="text" class="form-control" style="width: 300px;" id="inputName" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable3" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="tBody">
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form" id="searchContactForm">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" id="inputContactName" placeholder="请输入联系人名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="tBody1">
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>创建交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="tranSaveBtn">保存</button>
			<button type="button" class="btn btn-default">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="create-transactionOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="owner" name="owner">
				</select>
				<span id="ownerErrorMsg" style="color: red;font-size: 12px"></span>
			</div>
			<label for="create-amountOfMoney" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="money" name="money">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="name" name="name">
				<span id="nameErrorMsg" style="color: red;font-size: 12px"></span>
			</div>
			<label for="create-expectedClosingDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="expectedDate" name="expectedDate">
				<span id="expectedDateErrorMsg" style="color: red;font-size: 12px"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-accountName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="customerName" name="customerName"  autocomplete="off" placeholder="支持自动补全，输入客户不存在则新建">
				<span id="customerNameErrorMsg" style="color: red;font-size: 12px"></span>
			</div>
			<label for="create-transactionStage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="stage" name="stage">
			  	<option value=""></option>
				  <C:forEach items="${stageList}" var="s">
					  <option value="${s.value}">${s.text}</option>
				  </C:forEach>
			  </select>
				<span id="stageErrorMsg" style="color: red;font-size: 12px"></span>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-transactionType" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="type" name="type">
				  <option value=""></option>
					<C:forEach items="${transactionTypeList}" var="t">
						<option value="${t.value}">${t.text}</option>
					</C:forEach>
				</select>
			</div>
			<label for="create-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="possibility" name="possibility" readonly="readonly">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="source" name="source">
				  <option value=""></option>
				  <C:forEach items="${sourceList}" var="s">
					  <option value="${s.value}">${s.text}</option>
				  </C:forEach>
				</select>
			</div>
			<label for="create-activitySrc" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" id="searchActivityBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="q-activityId" name="activityId" readonly="readonly">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" id="searchContactBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="q-contactId" name="contactId" readonly="readonly">
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-describe" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="description" name="description"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="contactSummary" name="contactSummary"></textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time1" id="nextContactTime" name="nextContactTime">
			</div>
		</div>
		
	</form>
</body>
</html>