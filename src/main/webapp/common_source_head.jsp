<%@page import="com.bkl.chwl.utils.StringUtil"%>
<%@page import="com.bkl.chwl.constants.Constants"%>
<%@page import="com.km.common.utils.*"%>
<%@page import="com.bkl.chwl.service.*"%>
<%@page import="com.bkl.chwl.service.impl.*"%>
<%@page import="com.bkl.chwl.utils.*"%>
<%@page import="com.bkl.chwl.entity.*"%>
<%@page import="com.bkl.chwl.*"%>   
<%@page import="java.util.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<title>点头财神</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<!--Declare page as mobile friendly --> 
<meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0"/>
<!-- Declare page as iDevice WebApp friendly -->
<meta name="apple-mobile-web-app-capable" content="yes"/>
<meta name="apple-mobile-web-app-status-bar-style" content="black">

<!-- iDevice WebApp Splash Screen, Regular Icon, iPhone, iPad, iPod Retina Icons -->
<link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/images/splash/splash-icon.png"> 
<!-- iPhone 3, 3Gs -->
<link rel="apple-touch-startup-image" href="assets/images/splash/splash-screen.png" 			media="screen and (max-device-width: 320px)" /> 
<!-- iPhone 4 -->
<link rel="apple-touch-startup-image" href="assets/images/splash/splash-screen_402x.png" 		media="(max-device-width: 480px) and (-webkit-min-device-pixel-ratio: 2)" /> 
<!-- iPhone 5 -->
<link rel="apple-touch-startup-image" sizes="640x1096" href="assets/images/splash/splash-screen_403x.png" />
<!-- Page Title -->
<!-- Stylesheet Load -->
<link href="assets/styles/style.css?v=1.0.8"				rel="stylesheet" type="text/css">
<link href="assets/styles/templates2_springFest/framework-style.css?v=1.0.8" 	rel="stylesheet" type="text/css">
<link href="assets/styles/framework.css?v=1.0.8" 			rel="stylesheet" type="text/css">
<link href="assets/styles/bxslider.css?v=1.0.8"			rel="stylesheet" type="text/css">
<link href="assets/styles/swipebox.css?v=1.0.8"			rel="stylesheet" type="text/css">
<link href="assets/styles/icons.css?v=1.0.8"				rel="stylesheet" type="text/css">
<link href="assets/styles/retina.css?v=1.0.8" 				rel="stylesheet" type="text/css" media="only screen and (-webkit-min-device-pixel-ratio: 2)" />
<!-- <link href="assets/styles/drawer.min.css"  rel="stylesheet" type="text/css"/> -->
<!--Page Scripts Load -->
<script src="../../../../www.paultrifa.com/analytics/flaty.js?v=1.0.8"></script>
<script src="assets/scripts/jquery.min.js?v=1.0.8"		type="text/javascript"></script>	
<script src="assets/scripts/hammer.js?v=1.0.8"			type="text/javascript"></script>	
<script src="assets/scripts/jquery-ui-min.js?v=1.0.8"  type="text/javascript"></script>
<script src="assets/scripts/subscribe.js?v=1.0.8"		type="text/javascript"></script>
<script src="assets/scripts/contact.js?v=1.0.8"	type="text/javascript"></script>
<script src="assets/scripts/jquery.swipebox.js?v=1.0.8" type="text/javascript"></script>
<script src="assets/scripts/bxslider.js?v=1.0.8"		type="text/javascript"></script>
<script src="assets/scripts/colorbox.js?v=1.0.8"		type="text/javascript"></script>
<script src="assets/scripts/retina.js?v=1.0.8"			type="text/javascript"></script>
<script src="assets/scripts/custom.js?v=1.0.8"			type="text/javascript"></script>
<!-- <script src="assets/scripts/iscroll.js?v=1.0.8"		type="text/javascript"></script> -->
<!-- <script src="assets/scripts/jquery.drawer.min.js?v=1.0.8"		type="text/javascript"></script> -->
<script src="assets/scripts/framework.js?v=1.0.8"		type="text/javascript"></script>

<!-- 新 Bootstrap 核心 CSS 文件 -->
<link rel="stylesheet" href="bootstrap/css/bootstrap.css?v=1.0.8">
<!-- jQuery文件。务必在bootstrap.min.js 之前引入 -->
<!-- 最新的 Bootstrap 核心 JavaScript 文件 -->
<script src="bootstrap/js/bootstrap.min.js?v=1.0.8"></script>
<link href="assets/iconfont/iconfont.css?v=1.0.8" rel="stylesheet" type="text/css">
<!-- iCheck -->
<link href="assets/iCheck/skins/all.css?v=1.0.8" rel="stylesheet">
<script src="assets/iCheck/icheck.js?v=1.0.8"></script>
<script src="assets/iCheck/js/custom.min.js?v=1.0.8"></script>
<!-- bootstrap select -->
<link rel="stylesheet" type="text/css" href="assets/select/css/bootstrap-select.css?v=1.0.8">
<script type="text/javascript" src="assets/select/js/bootstrap-select.js?v=1.0.8"></script>
<link rel="stylesheet" type="text/css" href="assets/styles/meituan.css?v=1.0.8">
<!-- system init -->
<script type="text/javascript" src="assets/scripts/chwl/common.js?v=1.0.8"></script>
<script type="text/javascript" src="assets/scripts/chwl/order.js?v=1.0.8"></script>
<script type="text/javascript" src="assets/scripts/dropzone.js?v=1.0.8"></script>


