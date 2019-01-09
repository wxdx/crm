function getActivity(id) {
    $("#" +id).html("");
    $.get(
        "workbench/clue/getActivity1.do",
        {"name":$("#h-inputName").val()},
        function (json) {
            var html = "";
            $.each(json,function (i,n) {
                html += "<tr>";
                html += "<td><input type='radio' name='activity' id='"+n.name+"' value='"+n.id+"'></td>";
                html += "<td>"+n.name+"</td>";
                html += "<td>"+n.startTime+"</td>";
                html += "<td>"+n.endTime+"</td>";
                html += "<td>"+n.owner+"</td>";
                html += "</tr>";
            });
            $("#" + id).html(html);
        }
    )
}
function getContact(id) {
    $("#" +id).html("");
    $.get(
        "workbench/contact/getContact.do",
        {"name":$("#h-inputContactName").val()},
        function (json) {
            var html = "";
            $.each(json,function (i,n) {
                html += "<tr>";
                html += "<td><input type='radio' name='contact' id='"+n.name+"' value='"+n.id+"'></td>";
                html += "<td>"+n.name+"</td>";
                html += "<td>"+n.email+"</td>";
                html += "<td>"+n.mphone+"</td>";
                html += "</tr>";
            });
            $("#" + id).html(html);
        }
    )
}

function getOwner(id) {
    $.ajaxSetup({
        async:false
    });
    $.get(
        "workbench/clue/getAllUser.do",
        function (json) {
            $("#" + id).html("<option value=\"\"></option>");
            $(json).each(function () {
                $("#" + id).append("<option value='"+this.id+"' >"+this.name+"</option>");
            });
            $.ajaxSetup({
                async:true
            });
        }
    );
}