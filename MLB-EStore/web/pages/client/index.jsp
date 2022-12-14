<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>MLB-EStore首页</title>

	<%-- 静态包含 base标签、css样式、jQuery文件 --%>
	<%@ include file="/pages/common/head.jsp" %>

	<script type="text/javascript">
		$(function () {
			$("button.addToCart").click(function () {
				var mlbId = $(this).attr("mlbId");
				<%--location.href = "${basePath}cartServlet?action=addItem&id=" + mlbId;--%>

				// 发ajax请求，添加商品到购物车
				$.getJSON("${basePath}cartServlet", "action=ajaxAddItem&id=" + mlbId, function (data) {
					$("#cartTotalCount").text("您的购物车中有 " + data.totalCount + " 件商品");
					$("#cartLastName").text("您刚刚将" + data.lastName + "加入到了购物车中");
				})
			})

		})
	</script>

</head>
<body>

<div id="header">
	<img class="logo_img" alt="" src="static/img/logo1.gif">
	<span class="wel_word">MLB-EStore</span>
	<div>
		<c:if test="${empty sessionScope.user}">
            <a href="pages/user/login.jsp">登录</a> |
            <a href="pages/user/regist.jsp">注册</a> &nbsp;&nbsp;
        </c:if>

		<c:if test="${not empty sessionScope.user}">
			<span>欢迎<span class="um_span">${sessionScope.user.username}</span>光临MLB-EStore</span>
			<a href="pages/order/order.jsp">我的订单</a>
			<a href="userServlet?action=logout">注销</a>
		</c:if>
	    <a href="pages/cart/cart.jsp">购物车</a>
	    <a href="pages/manager/manager.jsp">后台管理</a>
    </div>
</div>

<div id="main">
	<div id="mlb">
		<div class="mlb_cond">
			<form action="client/mlbServlet" method="get">
				<input type="hidden" name="action" value="pageByPrice">
				价格：<input id="min" type="text" name="min" value="${param.min}"> 元 -
                <input id="max" type="text" name="max" value="${param.max}"> 元
                <input type="submit" value="查询"/>
            </form>
        </div>
        <div style="text-align: center">
            <c:if test="${empty sessionScope.cart.items}">
                <%--购物车为空的输出--%>
                <span id="cartTotalCount"> </span>
                <div>
                    <span style="color: red" id="cartLastName">当前购物车为空</span>
                </div>
            </c:if>
            <c:if test="${not empty sessionScope.cart.items}">
                <%--购物车非空的输出--%>
                <span id="cartTotalCount">您的购物车中有 ${sessionScope.cart.totalCount} 件商品</span>
                <div>
                    <span style="color: red" id="cartLastName">${sessionScope.lastName}</span>
                </div>
            </c:if>
        </div>

		<c:forEach items="${requestScope.page.items}" var="mlb">
			<div class="b_list">
				<div class="img_div">
					<img class="mlb_img" alt="" src="${mlb.imgPath}"/>
				</div>
				<div class="mlb_info">
					<div class="mlb_name">
						<span class="sp1">商品名称:</span>
						<span class="sp2">${mlb.name}</span>
					</div>
					<div class="mlb_author">
						<span class="sp1">商品简介:</span>
						<span class="sp2">${mlb.description}</span>
					</div>
					<div class="mlb_price">
						<span class="sp1">价格:</span>
						<span class="sp2">￥${mlb.price}</span>
					</div>
					<div class="mlb_sales">
						<span class="sp1">销量:</span>
						<span class="sp2">${mlb.sales}</span>
					</div>
					<div class="mlb_amount">
						<span class="sp1">库存:</span>
						<span class="sp2">${mlb.stock}</span>
					</div>
					<div class="mlb_add">
						<button mlbId="${mlb.id} " class="addToCart">加入购物车</button>
					</div>
				</div>
			</div>
		</c:forEach>
    </div>

    <%--静态包含分页条--%>
    <%@include file="/pages/common/page_nav.jsp" %>


</div>

<%--静态包含页脚内容--%>
<%@include file="/pages/common/footer.jsp" %>

</body>
</html>