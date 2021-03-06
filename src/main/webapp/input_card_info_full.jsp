<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@page import="com.bkl.chwl.constants.Constants"%>
 <%@page import="java.net.URLEncoder"%>
<%@page import="com.km.common.config.Config"%>
<%@page import="com.bkl.chwl.service.*"%>
<%@page import="com.bkl.chwl.service.impl.*"%>
<%@page import="com.bkl.chwl.utils.*"%>
<%@page import="com.bkl.chwl.entity.*"%>
<%@page import="com.bkl.chwl.*"%>   
<%@page import="java.util.*"%>
<%
if(request.getParameter("bankCardNum")==null){
	response.sendRedirect("input_card_num.jsp");
	return;
}
if(request.getParameter("cardType")==null){
	response.sendRedirect("input_card_num.jsp");
	return;
}
User u=UserUtil.getCurrentUser(request);
String bankCardNum=request.getParameter("bankCardNum");
int cardType=Integer.parseInt(request.getParameter("cardType"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<jsp:include page="common_source_head.jsp"/>
</head>
<body class="drawer drawer-right">
<jsp:include page="top_nobutton.jsp"/>
<input type="hidden" id="bindType" value="<%=cardType%>">
<div class="content" style="margin-top:5.8rem;padding:0rem 1rem 1rem 1rem !important">
<input type="hidden" value="<%=bankCardNum %>" id="bank_account_o"/>
	<% 
		List banks = Config.getList("config.cny.withdraw.bank");
	%>
  <div class="form-group">
    <label for="bank_o" >卡类型</label><br>
    <select id="bank_o">
    <option value="0">请选择银行类型</option>
    <%
		for(Object bank:banks) {
			String bankName = new String(bank.toString().getBytes("ISO-8859-1"),"UTF-8");
	%>
	<option value="<%=bankName%>"><%=bankName%></option>
	<%	} %>
    </select>
  </div>
</div>
<div class="space"></div>
<div class="content" style="padding:0rem 1rem 1rem 1rem !important">
 <!-- <div class="form-group">
    <label for="bank_deposit_o">开户行</label>
    <input type="text" class="form-control" id="bank_deposit_o" placeholder="请输入您的开户行">
  </div>
 <div class="form-group">
    <label for="withdrawAccountAddr_bankNumber">开户行行号</label>
    <div class="input-group">
      <input type="text" class="form-control" id="withdrawAccountAddr_bankNumber" placeholder="请输入您的开户行行号" onkeyup="value=value.replace(/[^\0-9\.]/g,'')" onpaste="value=value.replace(/[^\0-9\.]/g,'')" oncontextmenu = "value=value.replace(/[^\0-9\.]/g,'')">
      <span class="input-group-btn">
        <a class="btn btn-danger" href="https://www.hebbank.com/corporbank/otherBankQueryWeb.do" target="_blank">行号查询</a>
      </span>
    </div>/input-group
  </div> -->
  <%if(cardType==1){ %>
	  <div class="form-group">
	    <label for="name">姓名</label>
	    <input type="text" class="form-control" id="name" value="<%=u.getName()!=null&&!u.getName().equals("")?u.getName():"" %>" placeholder="请输入持卡人姓名"  <%=u.getName()!=null&&!u.getName().equals("")?"readonly=\"readonly\"":"" %> onkeyup="this.value=this.value.replace(/[^\u4e00-\u9fa5]/g,'')" onafterpaste="this.value=this.value.replace(/[^\u4e00-\u9fa5]/g,'')" >
	  </div>
	  <div class="form-group">
	    <label for="identity_type">证件类型</label><br>
	    <select <%=u.getIdentity_type()!=0?"disabled=\"disabled\"":"" %> id="identity_type">
	    <%=u.getIdentity_type()!=0?"<option value="+u.getIdentity_type()+">"+u.getIdentity_typeString()+"</option>":"" %>
	    <option value="1">身份证</option>
	    <option value="2">护照</option>
	    <option value="3">回乡证</option>
	    <option value="4">台胞证</option>
	    </select>
	  </div>
	  <!--  -->
	  <div class="form-group">
	    <label for="identity_no">证件号</label>
	    <input type="text" class="form-control" id="identity_no" placeholder="请输入证件号" value="<%=u.getIdentity_no()!=null&&!u.getIdentity_no().equals("")?u.getIdentity_no():"" %>" <%=u.getIdentity_no()!=null&&!u.getIdentity_no().equals("")?"readonly=\"readonly\"":"" %>>
	  </div>
	  <p class="bg-info">提醒：后续只能绑定该持卡人的银行卡</p>
  <%}else{ %>
	  <div class="form-group">
	    <label for="licenceRegName">名称</label>
	    <input type="text" class="form-control" id="licenceRegName" value="<%=u.getLicenceRegName()!=null&&!u.getLicenceRegName().equals("")?u.getLicenceRegName():"" %>" placeholder="请输入名称"  <%=u.getLicenceRegName()!=null&&!u.getLicenceRegName().equals("")?"readonly=\"readonly\"":"" %>>
	  </div>
	  <!--  -->
	  <div class="form-group">
	    <label for="licenceNumber">营业执照注册名</label>
	    <input type="text" class="form-control" id="licenceNumber" placeholder="请输入营业执照注册名" value="<%=u.getLicenceNumber()!=null&&!u.getLicenceNumber().equals("")?u.getLicenceNumber():"" %>" <%=u.getLicenceNumber()!=null&&!u.getLicenceNumber().equals("")?"readonly=\"readonly\"":"" %>>
	  </div>
  <%} %>
  <div class="form-group">
    <label for="phone_o">手机号</label>
    <input type="text" class="form-control" id="phone_o" placeholder="请输入银行预留手机号">
  </div>
  <div style="height:30px;">
      <span style="float:left"><input type="checkbox" id="agreeCheck"  checked="checked" ></span><span style="float:left;height:25px;"><a  style="color:#000;line-height: 25px" href="javascript:void(0);" onclick="showAgreement();">《用户协议》</a>&nbsp;&nbsp;&nbsp;&nbsp;<a  style="color:#000;line-height: 25px" href="download.jsp?downloadUrl=<%=URLEncoder.encode("doc/点头付商家协议.docx") %>"  target="_blank">点头付商家协议下载</a></span>
  </div>
  <script>
  function showAgreement(){
	  $("#agreement").show();
	  return;
  }
  </script>
  <textarea class="form-control" rows="20" readonly="readonly" id="agreement" style="display: none">点头付用户协议
本协议是您与点头财神系统（以下简称“本系统”）所有者——重庆市大小王科技股份有限公司（以下简称“本公司”）之间就点头财神服务（以下简称“本服务”）相关事宜所订立的契约，请您仔细阅读本注册协议，在您点击点头财神系统注册页面的同意注册按钮并完成注册程序、获得点头财神系统账号和密码时，本协议即构成对双方有约束力的法律文件。
第一条	承诺与声明
1.1.	本协议已对与您的权益有或可能具有重大关系的条款，及对本公司具有或可能具有免责或限制责任的条款用粗体字予以标注，请您注意。您确认，在您注册成为点头消费者以接受本服务之前，你已充分阅读、理解并接受本协议的全部内容，一旦您使用本服务，即表示您同意遵循本协议之所有约定。
1.2.	您同意，根据国家法律法规变化及网站运营需要，本公司有权对本协议条款不时地进行修改，修改后的协议一旦被张贴在本站上即生效，并代替原来的协议；您可随时登陆查阅最新协议；若您在本协议变更后继续使用本服务，表示您已充分阅读、理解并接受修改后的协议内容，也将遵循修改后的协议内容使用本服务；若您不同意修改后的协议内容，您应停止使用本服务。 
1.3.	您声明，在您同意接受本协议并注册成为点头商家时，您是具有法律规定的完全民事权利能力和民事行为能力，具有合法经营资格的法人或非法人组织；本协议内容不受您所属国家或地区的排斥。不具备前述条件的，您应立即终止注册或停止使用本服务。
第二条	定义与解释
2.1.	点头财神系统：是指大小王公司开发并运营的具有交易结算、商家信息查询、信息技术推广费用分配等功能的综合交易结算系统，点头财神系统也可称为“本系统”。
2.2.	点头消费者：是指已在点头财神系统注册，并使用点头财神系统支付交易费用的自然人。
2.3.	点头消费者账户：是指大小王公司在点头财神系统上为点头消费者提供的唯一编号，点头消费者应自行设置密码，点头消费者应使用手机号码作为账户的名称；点头消费者可以使用该账户在点头财务系统上实现支付交易费用、查询点头商家信息、查询个人信息、提现等功能。
2.4.	点头商家：是指已点头财神系统注册，并使用点头财神系统收取交易费用的、有营业执照或其他运营证照的商家，该商家应具有工商营业执照或其他证明其具有营业资格法律文件。
2.5.	点头商家账户：是指大小王公司在点头财神系统上为点头商家提供的唯一编号，点头商家应自行设置密码；点头商家可以使用该账户在点头财神系统上实现收取代付款、广告、查询个人信息、提现等功能
2.6.	点头用户：点头消费者和点头商家合称为点头用户。
2.7.	点头用户账户：点头消费者账户和点头商家账户合称为点头用户账户。
2.8.	消费者粉丝：如果A点头消费者是基于B点头商家通过提供链接、二维码等推荐方式注册为点头消费者的，则A点头消费者为B点头商家的消费者粉丝，A消费者粉丝的信息将记载到B点头商家账户中，并可供B点头商家查询。
2.9.	点头金币：是指点头财神系统基于本协议所确定的规则分配给点头用户的、可以提现的积分，点头金币与与同等金额的人民币的价值相同，即点头用户可以通过提现将1个点头金币兑换为1元人民币；点头用户可在其账户中查询点头金币的数量。
2.10.	提现：是指点头用户依据点头财神系统的规则，并通过点头财神系统将其在点头财神系统账户中的部分或全部点头金币转账到其指定的银行账户的操作。
2.11.	信息技术推广费：是指从点头消费者向点头商家支付的消费金额中提取的一定比例费用，该费用用于回馈点头用户和用于维护点头财神系统。
2.12.	折扣比例：是指点头商家自愿将点头消费者所支付的消费金额中的部分款项作为信息技术推广费，而该部分信息技术推广费与点头消费者在该次消费结算中使用本系统所支付的消费金额的比例的数值为折扣比例。
2.13.	代付款：是在指点头消费者使用本系统向某点头商家所支付的交易款项中，扣除信息技术推广费和银联收取的交易手续后所剩余的款项。
第三条	您的注册义务
为了能使用本服务，你需要：
3.1.	您必须选择注册成为点头商家，您可以通过某点头用户提供的链接、二维码或其他推荐方式注册点头商家账户，您应当按照本系统的要求提供工商营业执照和其他必要的文件来完成注册，一个商家只能注册一个点头商家。
3.2.	您同意遵守所有与本服务相关之国内国际法律及规定，并同意不冒用或盗用他人的身份或者干扰他人使用本服务。 
3.3.	您必须依本服务注册表之提示提供您本人正确、最新及完整的资料（以下称“登记资料”），您保证不使用他人的资料在本系统注册。
3.4.	您有义务维护并立即更新您的登记资料，确保其为正确、最新及完整。若您提供任何错误、不实、过时或不完整的资料，或者本公司有合理的理由怀疑您的登记资料为错误、不实、过时或不完整，本公司有权暂停或终止您的用户账户，并拒绝您现在和未来使用本服务之部份或全部，您并同意负担因此所产生的直接或间接的任何损失、支出、费用、罚金。 
3.5.	您的用户基本资料（包含并不仅限于商家名称、电子邮件地址、手机号码、金融账户等一切必要信息）为使用本服务的必需资料，如有变更请立即修正。若因用户未及时更新基本资料，导致有关流程和操作（包括但不限于后续资金流、资讯流等作业）无法完成或发生错误，由此产生的一切后果和责任由用户承担；用户并不得以此作为取消交易、拒绝付款或采取其他不当行为之理由。 
3.6.	对于您使用任何不正确不合法之通信方式招致的任何损失、支出、费用、罚金，本公司将不会负担任何责任。 
3.7.	您应确保您的用户账户和密码仅由您本人亲自使用。本公司严厉禁止使用非您本人的用户账户和密码进行交易或者将您本人的用户账户和密码提供给他人使用。使用他人用户账户和密码者与该用户账户和密码的实际注册人应承担与交易相关的所有法律责任。 
3.8.	您同意本公司基于自身之独立判断，有权于发现异常交易或有疑异或违法之交易时，不经通知先行暂停或终止您的用户账户，并拒绝您使用本服务之部份或全部。但是，判断和发现异常交易或有疑异或违法之交易，并不构成本公司的一项义务和责任。
第四条	用户账户和密码及其安全
采取必要和有效的措施，确保您本人用户密码及账户的机密安全，是您的责任。您将对使用该密码及账户所进行的一切行为，负完全的责任，并同意遵守和执行以下事项：
4.1.	您的密码或账户遭到冒用、盗用或有其他任何影响安全的问题发生时，请立即通知本公司。
4.2.	您不可向其他任何人泄露、透露、告知的您用户账户和密码，亦不可使用其他任何人的用户账户和密码。由于您的原因导致您的用户账户和/或密码被其他任何人知悉，造成您的用户账户和/或密码被他人使用导致您损失的，本公司不承担任何责任。
4.3.	您同意于发现有第三人冒用或盗用您的账户及密码，或其他任何未经合法授权之情形，应立即通知本公司，要求停止其使用本服务并采取防范之措施。本公司于接受通知前（该等通知应不存在任何迟延情形），对第三人使用本服务已发生之效力和后果，除非可证明本公司对未经合法授权之使用的形成存在故意或重大过失，否则本公司将不承担任何责任。若您迟延通知，则迟延期间产生的损失，本公司将不需承担任何责任。
4.4.	检查、监控和发现是否有第三人冒用或盗用您的用户账户及密码、或其他任何未经合法授权之情形，是您的义务和责任。
第五条	交易结账
5.1.	如果交易中您和消费者均为点头用户，则双方的交易可以通过本系统进行交易款项的结算，点头消费者在交易结算前需在其点头消费者账户中绑定其指定的有效银行卡。
5.2.	在使用本系统进行交易款项结算时，点头消费者可以通过您提供的二维码或其他本系统认可的方式进入本系统的结算界面进行结算。
5.3.	在您和点头消费者完成在本系统的交易结算后，代付款将实时支付到您的点头商家账户中，信息技术推广费将按照《点头消费者信息技术推广费的提取与应用规则》、《点头商家信息技术推广费的提取与应用规则》以及本公司的其他规定处理。
5.4.	您所收到的代收款将以相同点头金币数量的形式体现您的点头商家账户中，您可以通过本系统所约定的提现操作将代收款转账至您指定的银行账户中。
第六条	本公司与您之间的法律关系
6.1.	本公司只提供交易结算服务，一旦您注册成为点头商家，本公司将遵照点头消费者的指示并根据本系统的流程规定和要求将该点头消费者所指定银行账户中的款项结算到您的点头商家账户中；如果您与点头消费者与交易合同有关争议的，由您与点头消费者应按照交易合同的约定履行各自的权利和义务，并独立承担相应的法律责任，本公司不承担任何法律责任，但是本公司可以在力所能及的范围内就争议的解决提供必要的协助。
6.2.	无论基于何种原因，本公司不负责您和点头消费者之间的退款事宜，并且本公司基于点头消费者向您支付交易款项所收到的信息技术推广费也不予以退还；如果您需要向点头消费者退回部分或全部交易款项的，由您直接向点头消费者退回该笔款项。
第七条	对本服务使用的要求与限制
7.1.	您在使用本服务时应遵守中华人民共和国相关法律法规、您所在国家或地区之法令及相关国际惯例，不将本服务用于任何非法目的（包括用于禁止或限制交易物品的交易），也不以任何非法方式使用本服务。
7.2.	 您不得利用本服务从事侵害他人合法权益之行为，否则本公司有权拒绝提供本服务，且您应承担所有相关法律责任，因此导致本公司或本公司雇员受损的，您应承担赔偿责任。上述行 为包括但不限于：
7.2.1.	侵害他人名誉权、隐私权、商业秘密、商标权、著作权、专利权等合法权益。
7.2.2.	违反依法定或约定之保密义务。
7.2.3.	冒用他人名义使用本服务。
7.2.4.	从事不法交易行为，如洗钱、恐怖融资、贩卖枪支、毒品、禁药、盗版软件、黄色淫秽物品、其他本公司认为不得使用本服务进行交易的物品等。
7.2.5.	提供赌博资讯或以任何方式引诱他人参与赌博。
7.2.6.	非法使用他人银行账户（包括信用卡账户）或无效银行账号（包括信用卡账户）交易。
7.2.7.	违反《银行卡业务管理办法》使用银行卡，或利用信用卡套取现金（以下简称套现）。
7.2.8.	进行与您或交易对方宣称的交易内容不符的交易，或不真实的交易。
7.2.9.	从事任何可能含有电脑病毒或是可能侵害本服务系统、资料之行为。
7.2.10.	其他本公司有正当理由认为不适当之行为。
7.3.	如果点头消费者要求使用本系统结算交易款项的，您必须予以积极配合，并按照本协议和本协议的各项要求完成交易款项的结算。
7.4.	您同意：您作为一个点头商家，如果在连续3个自然月中，您在每一个自然月中使用本协议所产生的交易金额均不高于15,000元的，您将是不合格的点头商家，本公司有权单方面中断或终止与您的合作，并冻结或注销您的点头商家账户。
7.5.	您同意：尽管本系统只提供交易结算服务，但是本公司仍然要求您按照我国法律的规定和您与点头消费者之间交易合同的约定履行合同义务，享受合同权利，如果由于您的行为侵害了点头消费者的合法权益或有其他违法、违约行为而被行政职能部门查处的，本公司有权单方面中断或终止与您的合作，并冻结或注销您的点头商家账户。
第八条	隐私保护
8.1.	本公司承诺尽一切可能保护您的个人信息，我们将严格按照此隐私协议的规定使用您的个人信息。我们保证在不必要的情况下不会把您的个人信息透露给任何第三方。
8.2.	为了使您在一个高效和个性化的过程中进行交易，本公司会根据需要，按照所提供的不同服务类别向您收集不同的个人信息。所需要收集的内容都会在相关页面上明示，包括但不限于您的姓名（或名称）、性别、居住城市、通讯地址、邮政编码、电子邮件、手机号码、电话号码、身份证资料、银行信用卡和银行来往账户的信息。
8.3.	为了在本公司能力所及程度和范围内保护我们的全部用户以防止可能存在的潜在欺诈行为，我们将与第三方（包括但不仅限于银行发卡机构，公安局户籍管理机关等）证实您提供的信息。
8.4.	我们所收集的您的信息主要用于以下方面： 
8.4.1.	提供交易服务并处理您的交易。 
8.4.2.	提供客户服务。 
8.4.3.	改进我们的产品和服务。
8.5.	本公司可以基于下述事由公开或向第三方披露您的信息：
8.5.1.	您同意让第三方共享资料；
8.5.2.	您同意公开其个人资料，享受为其提供的产品和服务；
8.5.3.	本公司需要听从法庭传票、法律命令或遵循法律程序；
8.5.4.	本公司发现您违反了本协议条款或本公司的其它使用规定。
第九条	知识产权
9.1.	本系统的知识产权
9.1.1.	本系统所有的产品、技术与所有程序均属于本系统的知识产权，为本公司所有和使用。本公司独立拥有或与相关内容提供者共同拥有本系统内相关内容（包括但不限于文字、图片、音频、视频资料及页面设计、编排、软件等）的版权和/或其他相关知识产权。
9.1.2.	除非中国法律另有规定，未经本公司书面许可，对于本公司拥有版权和/或其他知识产权的任何内容，任何人不得擅自（包括但不限于：以非法的方式复制、传播、展示、镜像、上载、下载）使用。否则，本公司将依法追究法律责任。
9.2.	点头用户的知识产权
9.2.1.	任何点头用户接受本协议，即表明该用户主动将其在本系统发表的任何形式的信息的著作财产权，包括并不限于：复制权、发行权、出租权、展览权、表演权、放映权、广播权、信息网络传播权、摄制权、改编权、翻译权、汇编权以及应当由著作权人享有的其他可转让权利无偿独家转让给本公司所有，同时表明该用户许可本公司有权利就任何主体侵权而单独提起诉讼，并获得全部赔偿。 本协议已经构成《著作权法》第二十五条所规定的书面协议，其效力及于用户在本系统发布的任何受著作权法保护的作品内容，无论该内容形成于本协议签订前还是本协议签订后。
9.2.2.	点头用户同意并明确了解上述条款，不将已发表于本系统的信息，以任何形式发布或授权其它网站（及媒体）使用。同时，用户保证己方在本系统上发布的一切图文信息资料均具有完全知识产权和合法权利，不侵犯任何人人身或财产等一切合法权利。
9.2.3.	为了保证评价的真实性与合法性，如果发现点头用户上传的图片中含有侵权内容，包括且不限于侵犯他人人身或财产权利，或带有其他网站的logo、图标等标识信息，本公司保留删除站内各类不符合规定评价而不通知该点头用户的权利
第十条	责任限制
10.1.	不论在任何情况下，本公司均不对由于互联网正常的设备维护，互联网络连接故障，电脑、通讯或其他系统的故障，电力故障，罢工，暴乱，骚乱，灾难性天气（如火灾、洪水、风暴等），爆炸，战争，政府行为，司法行政机关的命令或第三方的不作为而造成的不能履行或延迟履行承担责任。
10.2.	如因上述不可抗力或其他本公司无法控制的原因使本系统崩溃或无法正常使用导致网上交易无法完成或丢失有关的信息、记录等，本系统不承担责任。但是本系统会尽可能合理地协助处理善后事宜，并努力使客户免受经济损失。
10.3.	在法律允许的情况下，本公司对于与本协议有关或由本协议引起的任何间接的、惩罚性的、特殊的、派生的损失（包括业务损失、收益损失、利润损失、商誉损失、使用数据 或其他经济利益的损失），不论是如何产生的，也不论是由对本协议的违约（包括违反保证）还是由侵权造成的，均不负有任何责任，即使事先已被告知此等损失的可能性。另外即使本协议 规定的排他性救济没有达到其基本目的，也应排除本公司对上述损失的责任。
第十一条	服务的中断和终止
11.1.	本公司会尽全力维护本系统的正常运行，以向用户提供持续、稳定、安全、顺畅的服务。但您理解并同意：本公司对服务页面进行改版、升级系统、增加服务功能等须中断服务的操作时，有权暂时中断服务。本系统将尽可能在实施以上行为时予以提前公告，并尽可能将影响降低到最小。
11.2.	您可自行停止使用本公司提供的服务，并可向本公司提交申请，要求封停或注销其帐户。如果用户在本系统从事违法行为或违反本协议及相关规定的行为，即使用户账户已被封停或注销，但是本公司仍有权行使本协议规定的权利并追究用户的法律责任。
11.3.	本公司可在下列情况下，自行停止向用户提供服务，并封停或注销其帐户，若因用户行为给本公司造成损失的，用户还应负责赔偿，这些情形包括：
11.3.1.	用户违反本协议相关规定的，不论用户是否直接、间接或者通过他人再次注册成为点头用户，本公司均有权停止向其提供服务；
11.3.2.	用户使用虚假信息注册的，包括但不限于使用虚假姓名、虚假地址、虚假手机号、虚假电子邮箱等，本公司均有权立即停止向其提供服务；
11.3.3.	本协议终止或更新时，用户明示不同意接受新协议的；
11.3.4.	其他违反本公司相关规定或致使本公司或他人遭受利益损害的行为。
11.4.	您同意：在您的点头用户账户被依法注销时，对于您的点头用户账户中仍然存在的点头金币，您将无偿放弃这些点头金币的全部权利，并无条件授权本公司处置。
第十二条	准据法与管辖法院
本协议条款之解释与适用，以及与本协议条款有关的争议，均应依照中华人民共和国法律予以处理，并由本公司所在地的中华人民共和国法院管辖
第十三条	附则
本协议除以上正文部分外，还包括本系统发布的各项服务规则，各项服务规则与本协议具有同等法律效力；服务规则包括但不限《点头消费者信息技术推广费的提取与应用规则》、《点头商家信息技术推广费的提取与应用规则》等。

《点头商家信息技术推广费的提取与应用规则》
第一条	信息技术推广费
1.1.	在点头消费者使用本系统向点头商家支付交易款项后，本系统将实时提取信息技术推广费。
1.2.	信息技术推广费的金额=点头消费者使用本系统向点头商家支付交易款项的金额×折扣比例，其中折扣比例的数值是由点头商家事先设定在其账户中的，点头商家可以按照本系统所规定要求调整折扣比例的数值。
1.3.	点头商家可以在10%至50%的范围设置折扣比例，点头商家在设置和使用折扣比例时应遵循如下规定：
1.3.1.	点头商家设置的折扣比例不得过高，导致点头商家使用本系统进行交易结算时，点头商家所实际收到的代付款低于点头商家提供商品或服务的成本；
1.3.2.	点头商家应遵循诚实信用原则，不得欺诈或误导点头消费者；
1.3.3.	点头商家应按在其点头商家账户中预先设定的折扣比例结算交易款项，不得私自变更折扣比例；
1.3.4.	点头商家应按照本系统所制定的交易规则设置和使用折扣比例。
第二条	消费者粉丝提成费
假设A点头消费者是B点头商家的消费者粉丝，如果A点头消费者使用本系统向点头商家支付交易款项的，本系统将实时向B点头商家的点头商家账户转账消费者粉丝提成费，消费者粉丝提成费的金额为A点头消费者使用本系统向点头商家支付交易款项所产生的信息技术推广费的金额5%，但是B点头商家基于A点头消费者使用本系统向点头商家支付交易款项所获得的消费者粉丝提成费累计不得高于5,000元;消费者粉丝提成费在消费者账户中以点头金币数量的形式体现。
第三条	提现
3.1.	点头用户可以将在其点头用户账户的“我的金币”项目中部分或全部点头金币转账至该点头用户指定的有效银行账户，点头用户在进行提现操作时，应根据本系统的指示填写身份信息、银行账户信息等资料，点头用户应保证信息的真实性和准确性；如果由于点头用户的原因导致提现操作不能完成、出现错误或出现其他问题的，由该点头用户自行承担全部责任。
3.2.	如果点头用户要对在其点头用户账户中的其他项目下的点头金币提现的，该点头用户应先按照本系统的规则将在其他项目下的点头金币转移至“我的金币”项目中。
3.3.	如果点头用户在提现时产生了税费、银行手续费或其他费用的，按照我国相关法律的规定、银行的规定或其他合法的规定或文件办理。
</textarea>
<div class="space_noborder"></div>
  <button  class="btn btn-success  btn-block" onclick="bindCardFullSubmit()">同意协议并下一步</button><br>
</div>
 <jsp:include page="foot.jsp"/>
<jsp:include page="common_source_foot.jsp"/>
<jsp:include page="list_nav.jsp"></jsp:include>
<!-- page special -->
<script type="text/javascript">
document.getElementById("head_title").innerHTML="银行卡信息";
</script>
<!-- drop box -->
<style>
select {
font-size: 1.4rem !important;
width: 60% !important;
padding: .45rem !important;
height: 2.5rem !important;
}
</style>
<!-- drop box -->
</body>
</html>