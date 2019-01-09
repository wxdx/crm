<%@ page import="java.util.Map" %>
<%@ page import="java.util.Set" %>
<%@ page import="com.wkcto.crm.settings.domain.DicValue" %>
<%@ page import="java.util.List" %>
<%@page contentType="text/html; charset=utf-8" %>
<%
	//获取字典值
	List<DicValue> dvList = (List<DicValue>)request.getServletContext().getAttribute("stageList");
	//获取当前阶段的可能性
	Map<String,Object> pMap = (Map<String,Object>)request.getServletContext().getAttribute("possibilityMap");
	//获取当前阶段
	Map<String,Object> sMap = (Map<String,Object>)request.getAttribute("map");

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">


	<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
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
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

        $("body").on("mouseover",".remarkDiv",function () {
            $(this).children("div").children("div").show();
        });
        $("body").on("mouseout",".remarkDiv",function () {
            $(this).children("div").children("div").hide();
        });
		
		
		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });
		$("#possibility").text(possibilityJson['${map.stage}']);

		displayTranHistory();
		displayRemark();
        $("#saveRemarkBtn").click(function () {
            if ($("#remark").val() == ""){
                alert("备注内容不能为空");
            } else {
                $.post(
                    "workbench/tran/remarkSave.do",
                    {
                        "tranId":"${map.id}",
                        "noteContent":$("#remark").val(),
                        "createBy":"${user.name}",
                        "editFlag":"0"
                    },
                    function (json) {
                        if (json.success){
                            $("#remark").val("");
                            var html = "";
                            html += '<div class="remarkDiv" style="height: 60px;" id='+json.tranRemark.id+'>';
                            html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                            html += '<div style="position: relative; top: -40px; left: 40px;" >';
                            html += '<h5 id=e-'+json.tranRemark.id+'>'+json.tranRemark.noteContent+'</h5>';
                            html += '<font color="gray">交易</font> <font color="gray">-</font> <b>${map.name}</b> <small style="color: gray;" id=s-'+json.tranRemark.id+'> '+(json.tranRemark.createTime)+'由'+(json.tranRemark.createBy)+'</small>';
                            html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+json.tranRemark.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: red;"></span></a>';
                            html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                            html += '<a class="myHref" href="javascript:void(0);" onclick="delById(\''+json.tranRemark.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: red;"></span></a>';
                            html += '</div>';
                            html += '</div>';
                            html += '</div>';
                            $("#remarkDiv").before(html);
                        }
                    }
                )
            }
        });
	});
	function displayTranHistory() {
		$.get(
		    "workbench/tran/getHistoryList.do",
			{"tranId":"${map.id}"},
			function (json) {
		        $("#tBody").html("");
				var html = "";
				$.each(json,function (i,n) {
						html += "<tr>";
						html += "<td>"+n.stage+"</td>";
						html += "<td>"+n.money+"</td>";
						html += "<td>"+possibilityJson[n.stage]+"</td>";
						html += "<td>"+n.expectedDate+"</td>";
						html += "<td>"+n.createTime+"</td>";
						html += "<td>"+n.createBy+"</td>";
						html += "</tr>";
                });
				$("#tBody").html(html);
            }
		)
    }
    function displayRemark() {
        $.ajaxSetup({
            async:false
        });
        $.get(
            "workbench/tran/getRemarkList.do",
            {
                "tranId" : "${map.id}",
                "_":new Date().getTime()
            },
            function (json) {
                var html = "";
                $.each(json,function (i,n) {
                    html += '<div class="remarkDiv" style="height: 60px;" id='+n.id+'>';
                    html += '<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">';
                    html += '<div style="position: relative; top: -40px; left: 40px;" >';
                    html += '<h5 id=e-'+n.id+'>'+n.noteContent+'</h5>';
                    html += '<font color="gray">交易</font> <font color="gray">-</font> <b>${map.name}</b> <small style="color: gray;" id=s-'+n.id+'> '+(n.editFlag==1?n.editTime:n.createTime)+'由'+(n.editFlag==1?n.editBy:n.createBy)+'</small>';
                    html += '<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">';
                    html += '<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+n.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: red;"></span></a>';
                    html += '&nbsp;&nbsp;&nbsp;&nbsp;';
                    html += '<a class="myHref" href="javascript:void(0);" onclick="delById(\''+n.id+'\')" ><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: red;"></span></a>';
                    html += '</div>';
                    html += '</div>';
                    html += '</div>';
                });
                $("#remarkDiv").before(html);
                $.ajaxSetup({
                    async:true
                });
            }
        )
    }
    function delById(id) {
        if (confirm("你确定删除吗")){
            $.post(
                "workbench/tran/deleteRemark.do",
                {"id":id},
                function (json) {
                    if (json.success){
                        $("#"+id).remove();
                    } else {
                        alert("删除失败");
                    }
                }
            )
        }
    }
    function editRemark(id) {
        $("#editContactRemarkModal").modal("show");
        $("#e-noteContent").val($("#e-"+id).text());
        $("#remarkUpdateBtn").click(function () {
            if ($("#e-noteContent").val() == ""){
                alert("备注内容不能为空");
            } else {
                $.post(
                    "workbench/tran/updateRemark.do",
                    {
                        "id":id,
                        "noteContent":$.trim($("#e-noteContent").val()),
                        "editBy" : "${user.name}",
                        "editFlag":"1"
                    },
                    function (json) {
                        if (json.success){
                            $("#editContactRemarkModal").modal("hide");

                            $("#e-"+id).text(json.noteContent);
                            $("#s-"+id).text(json.editTime + "由" + json.editBy);
                        } else {
                            alert("更新失败");
                        }
                    }
                )
            }
        });
    }
    function changeStage(stage,idOrIndex,flag) {
		if (confirm("确定更新阶段吗?")){
		    $.post(
		        "workbench/tran/changeStage.do",
				{
                    "id" : "${map.id}",
                    "stage" : stage,
                    "money" : "${map.money}",
                    "expectedDate" : "${map.expectedDate}"
				},
				function (json) {
					if (json.success){
					    $("#stage").text(json.stage);
					    $("#editName").text(json.editBy);
					    $("#editTime").text(json.editTime);
					    $("#possibility").text(possibilityJson[json.stage]);
					    displayTranHistory();
					    changeIco(idOrIndex,flag);
					}
                }
			)
		}
    }
    function changeIco(idOrIndex,flag) {
	    if (flag == "1") {
            for (var i = 0; i < <%=dvList.size()%>; i++) {
                if (i == idOrIndex) {
                    $("#" + i).removeClass();
                    $("#" + i).addClass("glyphicon glyphicon-map-marker mystage");
                    $("#" + i).css("color", "#90F790");
                } else if (i > idOrIndex && i < <%=dvList.size()%> - 2) {
                    $("#" + i).removeClass();
                    $("#" + i).addClass("glyphicon glyphicon-record mystage");
                    $("#" + i).css("color", "black");
                } else if(i < idOrIndex){
                    $("#" + i).removeClass();
                    $("#" + i).addClass("glyphicon glyphicon-ok-circle mystage");
                    $("#" + i).css("color", "#90F790");
                } else {
                    $("#" + i).removeClass();
                    $("#" + i).addClass("glyphicon glyphicon-ban-circle mystage");
                    $("#" + i).css("color", "black");
				}
            }
        } else {
            for (var i = 0; i < <%=dvList.size()%>; i++) {
                if (i == idOrIndex){
                    $("#" + i).removeClass();
                    $("#" + i).addClass("glyphicon glyphicon-ban-circle mystage");
                    $("#" + i).css("color", "red");
				} else if (i > <%=dvList.size()%> - 2 && i != idOrIndex){
                    $("#" + i).removeClass();
                    $("#" + i).addClass("glyphicon glyphicon-ban-circle mystage");
                    $("#" + i).css("color", "black");
				} else {
                    $("#" + i).removeClass();
                    $("#" + i).addClass("glyphicon glyphicon-record mystage");
                    $("#" + i).css("color", "black");
				}
			}
		}
    }
	
	
</script>

</head>
<body>
	
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${map.name} <small>￥${map.money}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/edit.jsp';"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<%
			String currentStage = (String)sMap.get("stage");

			String possibility = (String)pMap.get(currentStage);

			//失败状态
			if ("0".equals(possibility)){
			    int z = 0;
			    for(DicValue dv : dvList){
					if (dv.getValue().equals(currentStage)){
		%>
		<span id="<%=z%>" class="glyphicon glyphicon-ban-circle mystage" onclick="changeStage('<%=dv.getValue()%>','<%=z%>','0')" data-toggle="popover" data-placement="bottom" data-content="<%=dv.getText()%>" style="color: red"></span>
		-----------
		<%
					} else if ("0".equals(pMap.get(dv.getValue()))){
		%>
		<span id="<%=z%>" class="glyphicon glyphicon-ban-circle mystage" onclick="changeStage('<%=dv.getValue()%>','<%=z%>','0')" data-toggle="popover" data-placement="bottom" data-content="<%=dv.getText()%>"></span>
		-----------
		<%
					} else {
		%>
		<span id="<%=z%>" class="glyphicon glyphicon-record mystage" onclick="changeStage('<%=dv.getValue()%>','<%=z%>','1')" data-toggle="popover" data-placement="bottom" data-content="<%=dv.getText()%>"></span>
		-----------
		<%
					}
					z++;
				}
			} else {
			//正常状态
				int currentIndex = 0;
				for (int z = 0;z < dvList.size();z++){
				    DicValue dv = dvList.get(z);
				    if (dv.getValue().equals(currentStage)){
						currentIndex = z;
				        break;
					}
				}
				for (int z = 0;z < dvList.size();z++){
				    DicValue dv = dvList.get(z);
				    if (z < currentIndex){
		%>
		<span id="<%=z%>" class="glyphicon glyphicon-ok-circle mystage" onclick="changeStage('<%=dv.getValue()%>','<%=z%>','1')" data-toggle="popover" data-placement="bottom" data-content="<%=dv.getText()%>" style="color: #90F790;"></span>
		-----------
		<%
					} else if (z == currentIndex){
		%>
		<span id="<%=z%>" class="glyphicon glyphicon-map-marker mystage" onclick="changeStage('<%=dv.getValue()%>','<%=z%>','1')" data-toggle="popover" data-placement="bottom" data-content="<%=dv.getText()%>" style="color: #90F790;"></span>
		-----------
		<%
					} else if (z > currentIndex && z < dvList.size() - 2 ){
		%>
		<span id="<%=z%>" class="glyphicon glyphicon-record mystage" onclick="changeStage('<%=dv.getValue()%>','<%=z%>','1')" data-toggle="popover" data-placement="bottom" data-content="<%=dv.getText()%>"></span>
		-----------
		<%
					} else {
		%>
		<span id="<%=z%>" class="glyphicon glyphicon-ban-circle mystage" onclick="changeStage('<%=dv.getValue()%>','<%=z%>','0')" data-toggle="popover" data-placement="bottom" data-content="<%=dv.getText()%>"></span>
		-----------
		<%
					}
				}
			}
		%>

		<%--<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-ban-circle mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-ban-circle mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-------------%>
		<span class="closingDate">${map.expectedDate}</span>
	</div>
	<!-- 修改交易备注的模态窗口 -->
	<div class="modal fade" id="editContactRemarkModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改交易备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="e-noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="remarkUpdateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.ownerName}&nbsp;&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${map.money}&nbsp;&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.name}&nbsp;&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${map.expectedDate}&nbsp;&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.customerName}&nbsp;&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stage">${map.stage}&nbsp;&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.type}&nbsp;&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibility"></b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${map.source}&nbsp;&nbsp;</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${map.activityName}&nbsp;&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${map.contactsName}&nbsp;&nbsp;</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${map.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${map.createTime}&nbsp;&nbsp;</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editName">${map.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="editTime">${map.editTime}&nbsp;&nbsp;</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${map.description} &nbsp;&nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${map.contactSummary} &nbsp;
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${map.nextContactTime}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>修改时间</td>
							<td>修改者</td>
						</tr>
					</thead>
					<tbody id="tBody">
					</tbody>
				</table>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>