<%@page import="com.bkl.chwl.constants.Constants"%>
<%@page import="com.bkl.chwl.service.*"%>
<%@page import="com.bkl.chwl.service.impl.*"%>
<%@page import="com.bkl.chwl.utils.*"%>
<%@page import="com.bkl.chwl.entity.*"%>
<%@page import="com.bkl.chwl.*"%>   
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
 <%
 User user = UserUtil.getCurrentUser(request);
 CashService cashSer = new CashServiceImpl();
 List<Cash> withdraws = cashSer.getLast20WithdrawList(user.getId());
 boolean haswithdraws = (withdraws.size() != 0);
 %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<jsp:include page="common_source_head.jsp"/>
</head>
<body class="drawer drawer-right">
<jsp:include page="top.jsp"/>
<div class="content nopadding" style="margin-top:4.5rem " id="content1">
<div class="container nomargin" style="background-color: #DC3C00;color:#fff;padding:2rem !important;margin-bottom: 0px !important;">
  <p><i class="iconfont">&#xe628;</i>金币(￥)<br><br><span class="bigFont" style="color: #fff" id="coin_left"></span></p>
  <div class="coin_right_pic"><img src="assets/images/Mascot.png"/></div>
</div>
<div class="space"></div>
<div class="tableList downborder">
<div class="detail" style="padding-left: 1rem"><i class="iconfont menuicon" style="color: #FDB300">&#xe628;</i>&nbsp;立赚所得</div><div class="status"  id="discount_get"></div>
</div>
<div class="tableList downborder">
<div class="detail" style="padding-left: 1rem"><i class="iconfont menuicon" style="color: #EA434B">&#xf0139;</i>&nbsp;推荐商家</div><div class="status" ><span style="color:#666" id="rshoper_get"></span></div>
</div>
<div class="tableList downborder">
<div class="detail" style="padding-left: 1rem"><i class="iconfont menuicon" style="color: #52BCEE">&#xf00d8;</i>&nbsp;推荐粉丝</div><div class="status"><span  style="color:#666" id="ruser_get"></span></div>
</div>
<div class="tableList downborder">
<div class="detail" style="padding-left: 1rem"><i class="iconfont menuicon" style="color: #D39145">&#xe61a;</i>&nbsp;抽奖收益</div><div class="status"  id="lottery_get"></div>
</div>
<div class="tableList downborder">
<div class="detail" style="padding-left: 1rem"><i class="iconfont menuicon" style="color: #D39145">&#xe61a;</i>&nbsp;钱袋收益</div><div class="status"  id="bonus_get"></div>
</div>
<div class="tableList downborder">
<div class="detail" style="padding-left: 1rem"><i class="iconfont menuicon" style="color: #565455">&#xe611;</i>&nbsp;城市代理</div><div class="status" id="proxy2_get"></div>
</div>
<div class="tableList downborder">
<div class="detail" style="padding-left: 1rem"><i class="iconfont menuicon" style="color: #565455">&#xe611;</i>&nbsp;区域代理</div><div class="status" id="proxy3_get"></div>
</div>
<div class="tableList downborder">
<div class="detail" style="padding-left: 1rem"><i class="iconfont menuicon" style="color: #00AE69">&#xe611;</i>&nbsp;猎头所得</div><div class="status" id="proxy_get"></div>
</div>
<div class="tableList downborder">
<!-- <a href="inputSecret.jsp?subType=2"><div class="detail" style="padding-left: 1rem"><i class="iconfont menuicon" style="color: #EE8100">&#xe6b3;</i>&nbsp;提现记录</div><div class="status"><i class="iconfont">&#xe6a3;</i></div></a> -->
<a href="user_withdraw.jsp"><div class="detail" style="padding-left: 1rem"><i class="iconfont menuicon" style="color: #EE8100">&#xe6b3;</i>&nbsp;提现记录</div><div class="status"><i class="iconfont">&#xe6a3;</i></div></a>
</div>
<div class="space"></div>
<!-- <a class="btn btn-success btn-block" href="inputSecret.jsp?subType=2">我要提现</a> -->
<a class="btn btn-success btn-block" href="user_withdraw.jsp">我要提现</a>
</div>
 <jsp:include page="foot.jsp"/>
<jsp:include page="common_source_foot.jsp"/>
<jsp:include page="list_nav.jsp"></jsp:include>
<!-- page special -->
<style>
.detail span{font-weight: 400;color:#DC3C00;font-size: 1.8rem}
</style>
<script type="text/javascript">
document.getElementById("head_title").innerHTML="我的金币";
$("#top_back_button").html("<a class=\"react\" href=\"user_index.jsp\" style=\"font-size: 1.6rem;color:#fff;padding-right: 1rem !important;\"><i class=\"iconfont\">&#xf0015;</i>&nbsp;&nbsp;</a>");
var url="/api/user/getUserProfile?random="+Math.round(Math.random()*100);
$.get(url,function(res){
	if(res){
		if(res.ret==0){
			 $("#discount_get").html(res.data["discount_get"]);
			 $("#rshoper_get").html(res.data["rshoper_get"]);
			 $("#ruser_get").html(res.data["ruser_get"]);
			 $("#bonus_get").html(res.data["bonus_get"]);
			 $("#lottery_get").html(res.data["lottery_get"]);
			 $("#proxy2_get").html(res.data["proxy2_get"]);
			 $("#proxy3_get").html(res.data["proxy3_get"]);
			 $("#proxy_get").html(res.data["proxy_get"]);
		}
	}
});
</script>
<style>
.menu_list_headicon{
	float:left;
	height:6rem;
	width:6rem;
}
.menu_list_user{height:6rem;padding:1rem;float:left;}
.menu_list_headicon img{width:100% !important;}
.downborder a{color:#000;}
.detail{width:50% !important;padding: .5rem 1rem !important;}
.status{width:50% !important;text-align: right;padding-right: 1rem !important;}
.status .iconfont{color:#ccc;}
.status{color:#666}
.menuicon{font-size:20px;color:#12A0D7}
</style>
<jsp:include page="updateProfileTimes.jsp"/>
</body>
</html>