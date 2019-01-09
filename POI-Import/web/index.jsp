<%@page contentType="text/html; charset=utf-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<base href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/">

    <title>Test</title>
</head>
<body>
    <form action="imoprtExcel.do" enctype="multipart/form-data" method="post">
            <input type="file" name="f1">
            <input type="submit" value="上传">
    </form>
</body>
</html>
