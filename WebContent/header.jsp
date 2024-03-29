<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<!-- 登录 注册 购物车... -->

<div class="container-fluid">
	<div class="col-md-4">
		<img src="img/logo2.png" />
	</div>
	<div class="col-md-5">
		<img src="img/header.png" />
	</div>
	<div class="col-md-3" style="padding-top:20px">
		<ol class="list-inline">
			<c:if test="${empty user}">
				<li><a href="login.jsp">登录</a></li>
				<li><a href="register.jsp">注册</a></li>
			</c:if>
			<c:if test="${!empty user}">
				<li style="color:red">${user.name }</li>
				<li><a href="${pageContext.request.contextPath }/userLogout">注销</a></li>
				
			</c:if>
			<li><a href="cart.jsp">购物车</a></li>
			<li><a href="${pageContext.request.contextPath }/getOrderList">我的订单</a></li>
		</ol>
	</div>
</div>

<!-- 导航条 -->
<div class="container-fluid">
	<nav class="navbar navbar-inverse">
		<div class="container-fluid">
			<!-- Brand and toggle get grouped for better mobile display -->
			<div class="navbar-header">
				<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expanded="false">
					<span class="sr-only">Toggle navigation</span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<a class="navbar-brand" href="default.jsp">首页</a>
			</div>

			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav" id="categoryUl">
				
					<%-- <c:forEach items="${categoryList }" var="category">
						<li><a href="#">${category.cname }</a></li>
					</c:forEach> --%>
					
				</ul>
				<form class="navbar-form navbar-right" role="search" action="${pageContext.request.contextPath }/searchProduct" method="post">
					<div class="form-group" style="position:relative">
						<input type="text" class="form-control" placeholder="Search" onkeyup="searchWord(this)" id="search" name="pname">
					</div>
					<div id="showDiv" style="display:none;position:absolute;width:170px;background-color:#fff;border:1px solid #ccc">
							
					</div>
					<button type="submit" class="btn btn-default">Submit</button>
				</form>
			</div>
		</div>
		<!-- 完成异步搜索 -->
		<script type="text/javascript">
		
			function overFn(obj){
				$(obj).css("background","#DBEAF9");
			}
			function outFn(obj){
				$(obj).css("background","#fff");
			}
			
			function clickFn(obj){
				$("#search").val($(obj).html());
				$("#showDiv").css("display","none");
			}
			
		
			function searchWord(obj){
				//1、获得输入框的输入的内容
				var word = $(obj).val();
				//2、根据输入框的内容去数据库中模糊查询---List<Product>
				var content = "";
				$.post(
					"${pageContext.request.contextPath}/searchWordServlet",
					{"word":word},
					function(data){
						//3、将返回的商品的名称 现在showDiv中
						//[{"pid":"1","pname":"小米 4c 官方版","market_price":8999.0,"shop_price":8999.0,"pimage":"products/1/c_0033.jpg","pdate":"2016-08-14","is_hot":1,"pdesc":"小米 4c 标准版 全网通 白色 移动联通电信4G手机 双卡双待 官方好好","pflag":0,"cid":"1"}]
						
						if(data.length>0){
							for(var i=0;i<data.length;i++){
								content+="<div style='padding:5px;cursor:pointer' onclick='clickFn(this)' onmouseover='overFn(this)' onmouseout='outFn(this)'>"+data[i]+"</div>";
							}
							$("#showDiv").html(content);
							$("#showDiv").css("display","block");
						}
						
					},
					"json"
				);
				
			}
		</script>
		<script type="text/javascript">
		//这种类别一般放入后不需要修改，所以我们可以放入redis中
			//header.jsp加载完毕后 去服务器端获得所有的category数据
			$(function(){
				var content = "";
				$.post(
					"${pageContext.request.contextPath}/getAllCategory",
					function(data){
						//[{"cid":"xxx","cname":"xxxx"},{},{}]
						//动态创建<li><a href="#">${category.cname }</a></li>
						for(var i=0;i<data.length;i++){
							content+="<li><a href='${pageContext.request.contextPath}/productListByCid?cid="+data[i].cid+"'>"+data[i].cname+"</a></li>";
						}
						
						//将拼接好的li放置到ul中
						$("#categoryUl").html(content);
					},
					"json"
				);
			});
		</script>
		
	</nav>
</div>