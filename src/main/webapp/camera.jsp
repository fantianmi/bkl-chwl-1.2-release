<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>camera</title>
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0"> 
<!-- camera js -->
<script type="text/javascript" > 
var video,canvas; 
window.addEventListener('DOMContentLoaded',function(){ 
'use strict'; 
//调取摄像头 
navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia; 
window.URL = window.URL || window.webkitURL || window.mozURL || window.msURL; 
if (navigator.getUserMedia) { 
navigator.getUserMedia({video: true}, gotStream, noStream); 
video = $("#video").get(0); 
canvas = $("#canvas").get(0); 
//启动摄像头成功之后开始获取二维码 
scanCode(); 
} else { 
console.log('Native web camera streaming (getUserMedia) not supported in this browser.'); 
} 
//调取摄像头成功的回调函数 
function gotStream(stream) { 
  if (video.mozSrcObject !== undefined) { 
video.mozSrcObject = stream; 
} else { 
video.src = (window.URL && window.URL.createObjectURL(stream)) || stream; 
} 
video.play(); 
  } 
  
  //调取摄像头失败的回调函数 
  function noStream() { 
  console.error('An error occurred: [CODE ' + error.code + ']'); 
  } 
$("#myVideo").bind("play", function () { 
//$("#photo").attr("disabled",false); 
    }); 
},false); 
//抓取video画面放入canvas 
function photograph(){ 
var context = canvas.getContext("2d"); 
//获取抓取图片的区域 
//获取取景框其实坐标位置和宽高 
var cameraAperture_X = $("#td1").width(); 
//var cameraAperture_Y = $("#mid_div").height(); 
var cameraAperture_Y = $("#table_h").offset().top - $(".smtwo").height(); 
var cameraAperture_W = $("#cameraAperture").width(); 
var cameraAperture_H = $("#cameraAperture").height(); 
context.drawImage(video, Math.round(cameraAperture_X/2), Math.round(cameraAperture_Y/2),cameraAperture_W, cameraAperture_H,0,0,cameraAperture_W,cameraAperture_H); 
    
    imageConvertToGray(context); 
    
var imgData =canvas.toDataURL("image/png"); 
$("#code").val(imgData); 
} 
//将图片处理成黑白的（二维码扫描需要处理黑白色图片，如果仅用于拍照这一步就省略了） 
function imageConvertToGray(ctx){ 
var length = canvas.width * canvas.height; 
imageData = ctx.getImageData(0, 0, canvas.width, canvas.height); 
for (var i = 0; i < length * 4; i += 4) { 
var myRed = imageData.data[i]; 
var myGreen = imageData.data[i + 1]; 
var myBlue = imageData.data[i + 2]; 
myGray = parseInt((myRed + myGreen + myBlue) / 3); 
imageData.data[i] = myGray; 
imageData.data[i + 1] = myGray; 
imageData.data[i + 2] = myGray; 
} 
ctx.putImageData(imageData, 0, 0); 
  } 
function scanCode(){ 
//生成图片的base64码 
photograph(); 
$("#picForm").ajaxSubmit({ 
url:'${ctx}/xxxx/xxxx.htm', 
type:'post', 
dataType:'text', 
success:function(data){ 
if(data != ""){//扫描出结果 
window.location.href="${ctx}/xxxx/xxxxxxxxxx.htm?data="+data+"&status="+$("#status").val(); 
//alert("扫描信息为："+data); 
}else{//继续扫描 
setTimeout(function(){ 
scanCode(); 
},2000); 
} 
} 
  }); 
} 
</script> 
<!-- camera js -->
</head>
<body>
<!-- form -->
<form id="picForm" action="${ctx}/xxxx/xxxx.htm" method="post" > 
<input type="hidden" value="" id="code" name="code"/> 
<input type="hidden" value="${status }" id="status" name="status"/> 
<section class="smtwo"> 
<h1><a class="back" href="${ctx }/index/index.htm"><img src="${ctx }/images/smtwo_1.png" style="border:none" alt=""></a>${titleMsg }</h1> 
</section> 
<section style="position: relative;"> 
<video  width="100%" id="video" autoplay="autoplay" onclick="photograph();"></video> 
<canvas width="200" height="200" id="canvas" style="display: none;"></canvas> 
<div style="position: absolute;top: 0;left: 0;"> 
<div class="smtw_bg butsmtw" id="mid_div"> 
${content } 
</div> 
<table width="100%" border="0" cellpadding="0" cellspacing="0" id="table_h"> 
<tr> 
<td class="smtw_bg td1" id="td1"></td> 
<td class="td2"> 
<div class="smtw_td" style="width:200px;height:200px;" id="cameraAperture" onclick="photograph()"> 
<span class="br1"></span> 
<span class="br2"></span> 
<span class="br3"></span> 
<span class="br4"></span> 
</div> 
</td> 
<td class="smtw_bg td1"></td> 
</tr> 
</table> 
<div class="smtw_bg butsmtw" id="bottom_div"> 
</div> 
</div> 
</section>   
</form> 
<!-- form -->
</body>
</html>