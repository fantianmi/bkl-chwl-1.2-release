package com.bkl.chwl.servlet;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.lang.reflect.InvocationTargetException;
import java.sql.Connection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import com.baiyi.domain.UserInfoEntity;
import com.bkl.chwl.MainConfig;
import com.bkl.chwl.entity.Area;
import com.bkl.chwl.entity.Cash;
import com.bkl.chwl.entity.Proxy;
import com.bkl.chwl.entity.RecommendDetail;
import com.bkl.chwl.entity.Shop;
import com.bkl.chwl.entity.ShopCollect;
import com.bkl.chwl.entity.ShopLike;
import com.bkl.chwl.entity.Tradeorder;
import com.bkl.chwl.entity.User;
import com.bkl.chwl.entity.UserBindCard;
import com.bkl.chwl.entity.Weixin;
import com.bkl.chwl.service.AreaService;
import com.bkl.chwl.service.ProxyService;
import com.bkl.chwl.service.RecommendDetailService;
import com.bkl.chwl.service.UserService;
import com.bkl.chwl.service.WeixinService;
import com.bkl.chwl.service.impl.AreaServiceImpl;
import com.bkl.chwl.service.impl.ProxyServiceImpl;
import com.bkl.chwl.service.impl.RecommendDetailServiceImpl;
import com.bkl.chwl.service.impl.UserServiceImpl;
import com.bkl.chwl.service.impl.WeixinServiceImpl;
import com.bkl.chwl.utils.ApiCommon;
import com.bkl.chwl.utils.FrontUtil;
import com.bkl.chwl.utils.HttpUtils;
import com.bkl.chwl.utils.UserUtil;
import com.bkl.chwl.vo.UserProfile;
import com.km.common.dao.DaoFactory;
import com.km.common.dao.GeneralDao;
import com.km.common.servlet.CommonServlet;
import com.km.common.utils.DbUtil;
import com.km.common.utils.ServletUtil;
import com.km.common.utils.TimeUtil;
import com.km.common.utils.ValidUtils;
import com.km.common.vo.Condition;
import com.km.common.vo.Page;
import com.km.common.vo.PageReply;
import com.km.common.vo.RetCode;

public class UserServlet extends CommonServlet {
	
	/**
	 * 获得当前登录用户信息
	 */
	public void get(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		User user = UserUtil.getCurrentUser(request);
		ServletUtil.writeOkCommonReply(user, response);
	}
	
	public void getProfile(HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		User user = UserUtil.getCurrentUser(request);
		if(user!=null){
			UserProfile p=ApiCommon.getUserProfile(user.getId());
			ServletUtil.writeOkCommonReply(p, response);
		}
	}
	
	public void deleteUser(HttpServletRequest request,HttpServletResponse response) throws Exception{
		int uid=Integer.parseInt(request.getParameter("uid"));
		Connection conn = DaoFactory.createConnection();
		GeneralDao<User> userDao=DaoFactory.createGeneralDao(User.class,conn);
		GeneralDao<Cash> cashDao=DaoFactory.createGeneralDao(Cash.class,conn);
		GeneralDao<RecommendDetail> recommendDao=DaoFactory.createGeneralDao(RecommendDetail.class,conn);
		GeneralDao<Shop> shopDao=DaoFactory.createGeneralDao(Shop.class,conn);
		GeneralDao<ShopCollect> shopCollectDao=DaoFactory.createGeneralDao(ShopCollect.class,conn);
		GeneralDao<ShopLike> shopLikeDao=DaoFactory.createGeneralDao(ShopLike.class,conn);
		GeneralDao<Tradeorder> tradeorderDao=DaoFactory.createGeneralDao(Tradeorder.class,conn);
		GeneralDao<UserBindCard> userBindCardDao=DaoFactory.createGeneralDao(UserBindCard.class,conn);
		
		Condition user_idCon=DbUtil.generalEqualWhere("user_id", uid);
		Condition recommended_idCon=DbUtil.generalEqualWhere("recommended_id", uid);
		Condition uidCon=DbUtil.generalEqualWhere("uid", uid);
		Condition sellerCon=DbUtil.generalEqualWhere("seller", uid);
		
		
		//执行删除功能
		try{
			userDao.beginTransaction();
			userDao.lockTable(userDao.getTableName(User.class), userDao.getTableName(Cash.class), userDao.getTableName(RecommendDetail.class), userDao.getTableName(Shop.class), userDao.getTableName(ShopCollect.class), userDao.getTableName(ShopLike.class), userDao.getTableName(Tradeorder.class),userDao.getTableName(UserBindCard.class));
			userDao.delete(uid);
			cashDao.delete(new Condition[]{user_idCon});
			recommendDao.delete(new Condition[]{user_idCon});
			recommendDao.delete(new Condition[]{recommended_idCon});
			shopDao.delete(new Condition[]{uidCon});
			shopCollectDao.delete(new Condition[]{uidCon});
			shopLikeDao.delete(new Condition[]{uidCon});
			tradeorderDao.delete(new Condition[]{uidCon});
			tradeorderDao.delete(new Condition[]{sellerCon});
			userBindCardDao.delete(new Condition[]{uidCon});
			userDao.unLockTable();
			userDao.commit();
			ServletUtil.writeCommonReply(null, RetCode.OK, response);
			return;
		}catch(RuntimeException e){
			userDao.rollback();
			throw e;
		}finally{
			DaoFactory.closeConnection(conn);
		}
	}
	
	/**
	 * 修改呢称
	 */
	public void modifyNickname(HttpServletRequest request, HttpServletResponse response) throws Exception {
		int uid=Integer.parseInt(request.getParameter("uid"));
		UserService userServ = new UserServiceImpl();
		
		User user = userServ.get(uid);
		String nick_name = request.getParameter("nick_name");
		
		// 参数错误
		if(StringUtils.isBlank(nick_name)) {
			// TODO returns retcode
			return;
		}
		
		user.setNick_name(nick_name);
		
		UserService userSrv = new UserServiceImpl();
		userSrv.save(user);
		ServletUtil.writeOkCommonReply(user, response);
	}
	
	public void modifyMobile2(HttpServletRequest request, HttpServletResponse response) throws Exception {
		User u=UserUtil.getCurrentUser(request);
		String bindMobile = request.getParameter("bindMobile");
		
		// 参数错误
		u.setMobile2(bindMobile);
		UserService userSrv = new UserServiceImpl();
		userSrv.save(u);
		ServletUtil.writeOkCommonReply(u, response);
	}
	
	/**
	 * 修改密码
	 */
	public void modifyPwd(HttpServletRequest request, HttpServletResponse response) throws Exception {
		UserService userServ = new UserServiceImpl();
		int uid=Integer.parseInt(request.getParameter("uid"));
		User user = userServ.get(uid);
		if(user.getPassword()==null){
			ServletUtil.writeCommonReply(null, RetCode.USER_PASSWORD_NOT_SET, response);
		}
		String originPwd = StringUtils.trim(request.getParameter("originPwd"));
		String newPwd = StringUtils.trim(request.getParameter("newPwd"));
		
		if (!StringUtils.isEmpty(user.getPassword())) {
			if (StringUtils.isEmpty(originPwd)) {
				ServletUtil.writeCommonReply(null, RetCode.ORGINAL_PASSWORD_EMPTY, response);
				return;
			}
			if (!user.checkPassword(originPwd)) {
				ServletUtil.writeCommonReply(null, RetCode.ORGINAL_PASSWORD_ERROR, response);
				return;
			}
		}
		if (newPwd.length() < 6) {
			ServletUtil.writeCommonReply(null, RetCode.PASSWORD_ILLEGAL, response);
			return;
		}
		user.saveMD5Password(newPwd);
		GeneralDao<User> userDao = DaoFactory.createGeneralDao(User.class);
		userDao.update(user);
		ServletUtil.writeCommonReply(null, RetCode.OK, response);
	}
	/**
	 * 修改交易密码
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	public void modifySecret(HttpServletRequest request, HttpServletResponse response) throws Exception {
		UserService userServ = new UserServiceImpl();
		int uid=Integer.parseInt(request.getParameter("uid"));
		User user = userServ.get(uid);
		if(user.getSecret()==null){
			ServletUtil.writeCommonReply(null, RetCode.USER_PASSWORD_NOT_SET, response);
		}
		String originPwd = StringUtils.trim(request.getParameter("originPwd"));
		String newPwd = StringUtils.trim(request.getParameter("newPwd"));
		if (!StringUtils.isEmpty(user.getSecret())) {
			if (StringUtils.isEmpty(originPwd)) {
				ServletUtil.writeCommonReply(null, RetCode.ORGINAL_PASSWORD_EMPTY, response);
				return;
			}
			if (!user.checkSecretPassword(originPwd)) {
				ServletUtil.writeCommonReply(null, RetCode.ORGINAL_PASSWORD_ERROR, response);
				return;
			}
		}
		if(user.checkPassword(newPwd)){
			ServletUtil.writeCommonReply(null, RetCode.LOGIN_PASSWORD_EQUAL_TRADE_PASSWORD, response);
			return;
		}
		if (newPwd.length() < 6) {
			ServletUtil.writeCommonReply(null, RetCode.PASSWORD_ILLEGAL, response);
			return;
		}
		user.saveMD5SecretPassword(newPwd);
		GeneralDao<User> userDao = DaoFactory.createGeneralDao(User.class);
		userDao.update(user);
		ServletUtil.writeCommonReply(null, RetCode.OK, response);
	}
	
	public void setSecret(HttpServletRequest request, HttpServletResponse response) throws Exception {
		UserService userServ = new UserServiceImpl();
		int uid=Integer.parseInt(request.getParameter("uid"));
		User user = userServ.get(uid);
		String newPwd = StringUtils.trim(request.getParameter("newPwd"));
		if (StringUtils.isEmpty(newPwd)) {
			ServletUtil.writeCommonReply(null, RetCode.USER_PASSWORD_NOT_SET, response);
			return;
		}
		if(user.checkPassword(newPwd)){
			ServletUtil.writeCommonReply(null, RetCode.LOGIN_PASSWORD_EQUAL_TRADE_PASSWORD, response);
			return;
		}
		if (newPwd.length() < 6) {
			ServletUtil.writeCommonReply(null, RetCode.PASSWORD_ILLEGAL, response);
			return;
		}
		user.saveMD5SecretPassword(newPwd);
		GeneralDao<User> userDao = DaoFactory.createGeneralDao(User.class);
		userDao.update(user);
		ServletUtil.writeCommonReply(null, RetCode.OK, response);
	}
	
	public void checkSecret(HttpServletRequest request,HttpServletResponse response) throws Exception{
		User u = UserUtil.getCurrentUser(request);
		String secretInput=request.getParameter("secret");
		if(secretInput==null){
			ServletUtil.writeCommonReply(null, RetCode.USER_TRADE_PASSWORD_NOT_SET, response);
			return;
		}
		if(!u.checkSecretPassword(secretInput)){
			ServletUtil.writeCommonReply(null, RetCode.USER_SECRET_ERROR, response);
			return;
		}
		ServletUtil.writeOkCommonReply(null, response);
	}
	
	public void bindingEmail(HttpServletRequest request,HttpServletResponse response) throws IOException{
		UserService userServ = new UserServiceImpl();
		long id=Integer.parseInt(request.getParameter("id"));
		String email=request.getParameter("email");
		String password=request.getParameter("password");
		RetCode ret=RetCode.OK;
		if (userServ.exist(email)) {
			ret = RetCode.USER_EXIST;
			ServletUtil.writeCommonReply(null, ret, response);
			return;
		} else if (!ValidUtils.emailFormat(email)) {
			ret = RetCode.EMAIL_ERROR;
			ServletUtil.writeCommonReply(null, ret, response);
			return;
		}
		User user = userServ.get(id);
		user.setEmail(email);
		user.saveMD5Password(password);
		GeneralDao<User> userDao = DaoFactory.createGeneralDao(User.class);
		userDao.update(user);
		ServletUtil.writeOkCommonReply(user, response);
	}
	
	/**
	 * 设置头像
	 * @throws IOException 
	 * @throws FileUploadException 
	 * @throws InvocationTargetException 
	 * @throws IllegalAccessException 
	 */
	public void modifyHeadIcon(HttpServletRequest request,HttpServletResponse response) throws Exception{
		int uid=Integer.parseInt(request.getParameter("uid"));
		UserService userServ = new UserServiceImpl();
		User user = userServ.get(uid);
		//如果有文件字段有内容即可修改
		String uploadFileURL=request.getParameter("uploadFileURL");
		user.setHeadIcon(uploadFileURL);
		userServ.modifyUser(user, uid);
		ServletUtil.writeOkCommonReply(user, response);
	}
	
	/**
	 * 设置真实姓名和卡号
	 */
	public void validateIdentity(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String picHome = request.getServletContext().getRealPath("/pic/user-identity");
		String absoluteUploadDir = picHome;
		if (!new File(picHome).isAbsolute()) {
			absoluteUploadDir = request.getServletContext().getRealPath(picHome);
		}
		if (!new File(absoluteUploadDir).isDirectory()) {
			com.km.common.utils.IOUtils.createDirRecursive(new File(absoluteUploadDir));
		}
		User user = UserUtil.getCurrentUser(request);
		
		// SESSION超时或未登录
		if (null == user) {
			response.sendRedirect("/userinfo.jsp");
			return;
		}
		
		DiskFileItemFactory factory = new DiskFileItemFactory();  
		ServletFileUpload upload = new ServletFileUpload(factory); 
		List<FileItem> list = upload.parseRequest(request);  
		Map params = new HashMap();
		for (FileItem item : list) {
			if (!item.isFormField()) {
				//String fileType = item.getName().substring(item.getName().lastIndexOf("."));
				InputStream in = item.getInputStream();
				OutputStream os = new FileOutputStream(new File(picHome, user.getId() + ".jpg"));
				IOUtils.copy(in, os);
				os.flush();
				IOUtils.closeQuietly(os);
				IOUtils.closeQuietly(in);
			} else {
				 String name = item.getFieldName();
                 String value = item.getString("UTF-8");
                 params.put(name, value);
			}
		}
		
		User user2 = new User();
		BeanUtils.populate(user2, params);
		
		user.setName(user2.getName());
		user.setIdentity_type(user2.getIdentity_type());
		user.setIdentity_no(user2.getIdentity_no());
		user.setRealname_validated(0);//提交审批的固定是0的状态
		// 更新用户信息
		UserService userSrv = new UserServiceImpl();
		userSrv.save(user);
		response.sendRedirect("/userinfo.jsp");
		// ServletUtil.writeCommonReply(null, ret, response);
	}
	
	/**
	 * 设置人民币提现地址
	 */
	public void modifyRmbWithdrawAddr(HttpServletRequest request, HttpServletResponse response) throws Exception {
		User user = UserUtil.getCurrentUser(request);
		// SESSION超时或未登录
		if (null == user) {
			// TODO returns retcode
		}
		String bank = request.getParameter("bank");
		String bank_account = request.getParameter("bank_account");
		String bank_number = request.getParameter("bank_number");
		String name=request.getParameter("name");
//		String mobile = request.getParameter("mobile");
		// 参数错误
		if(StringUtils.isBlank(bank) || StringUtils.isBlank(bank_account)) {
			// TODO returns retcode
		}
		
		// TODO 使用验证码?
		user.setName(name);
		user.setBank(bank);
		user.setBank_account(bank_account);
		user.setBank_number(bank_number);
		UserService userSrv = new UserServiceImpl();
		userSrv.save(user);
		
		Map data = new HashMap();
		data.put("bank", bank);
		data.put("bank_account", bank_account);
		ServletUtil.writeCommonReply(data, RetCode.OK, response);
	}
	
	/**
	 * 设置X币提现地址
	 */
	public void modifyCoinWithdrawAddr(HttpServletRequest request, HttpServletResponse response) throws Exception {
		User user = UserUtil.getCurrentUser(request);
		// SESSION超时或未登录
		if (null == user) {
			// TODO returns retcode
		}

		String addr = request.getParameter("addr");
		String type = request.getParameter("type");
		
		// 参数错误
		if(StringUtils.isBlank(addr) || StringUtils.isBlank(type)) {
			// TODO returns retcode
		}
		
		
		UserService userSrv = new UserServiceImpl();
		userSrv.save(user);
		
		Map data = new HashMap();
		data.put("addr", addr);
		ServletUtil.writeCommonReply(data, RetCode.OK, response);
	}
	
	public void getUserListHTML(HttpServletRequest request, HttpServletResponse response) throws Exception {
		Page page=ServletUtil.getPage(request);
		Map searchMap=ServletUtil.getSearchMap(request);
		int role=0;
		UserService userServ = new UserServiceImpl();
		AreaService areaServ=new AreaServiceImpl();
		
		long local=0;
		long local2=0;
			
		Map<Long,Area> areaMap=areaServ.areaMap();
		PageReply<User> users=userServ.findUser(role, searchMap, page);
		String res="";
		if(users.getPagedatas().length!=0&&users.getPagedatas()!=null){
			for(int i=0;i<users.getPagedatas().length;i++){
				User u=users.getPagedatas()[i];
				if(request.getParameter("local")==null){
					local=u.getLocal();
				}else{
					local=Integer.parseInt(request.getParameter("local"));
				}
				if(request.getParameter("local2")==null){
					local2=u.getLocal2();
				}else{
					local2=Integer.parseInt(request.getParameter("local2"));
				}
				res+="<tr><td>"+u.getId()+"</td><td>"+u.getMobile()+"</td><td>"+StringUtils.defaultIfEmpty(u.getName(),"-")+"</td>"
								+ "<td><a href=\"javascript:setProxy("+u.getId()+")\">[设置代理]</a></td></tr>";
			}
		}else{
			res="<tr><td colspan='100'><div class='alert alert-block alert-info'><strong class='green'>提示：没有数据。</strong></div></td></tr>";
		}
		Map out=new HashMap();
		out.put("html", res);
		out.put("pagenum", users.getPagenum());
		out.put("pagesize", users.getPagesize());
		out.put("totalcount", users.getTotalcount());
		out.put("totalpage", users.getTotalpage());
		ServletUtil.writeOkCommonReply(out, response);
	}
	
	public void setProxy(HttpServletRequest request, HttpServletResponse response) throws Exception {
		long uid=0;
		int city=0;
		int area=0;
		int parent=0;
		int type=0;
		RecommendDetailService rdServ=new RecommendDetailServiceImpl();
		if(request.getParameter("uid")!=null) uid=Integer.parseInt(request.getParameter("uid"));
		if(request.getParameter("city")!=null) city=Integer.parseInt(request.getParameter("city"));
		if(request.getParameter("area")!=null) area=Integer.parseInt(request.getParameter("area"));
		if(request.getParameter("parent")!=null) parent=Integer.parseInt(request.getParameter("parent"));
		if(request.getParameter("type")!=null) type=Integer.parseInt(request.getParameter("type"));
		ProxyService proxyServ=new ProxyServiceImpl();
		
		boolean flag=proxyServ.setProxy(uid, city, area,type,parent);
		if(flag){
			Proxy proxy=new Proxy();
			Proxy tempProxy=new Proxy();
			if(type==proxy.PROXYTYPE_AREA){
				tempProxy=proxyServ.getProxy(area);
			}else if(type==proxy.PROXYTYPE_CITY){
				tempProxy=proxyServ.getProxy(city);
			}
			if(tempProxy!=null){
				proxy=tempProxy;
			}
			proxy.setParent(parent);
			proxy.setCtime(TimeUtil.getUnixTime());
			if(type==proxy.PROXYTYPE_AREA){
				proxy.setAid(area);
				proxy.setProxytype(proxy.PROXYTYPE_AREA);
			}else{
				proxy.setAid(city);
				proxy.setProxytype(proxy.PROXYTYPE_CITY);
			}
			proxy.setUid(uid);
			proxyServ.saveProxy(proxy);
		}
		ServletUtil.writeOkCommonReply(flag, response);
	}
	/**
	 * 获取用户信息_大小王 用户收入情况
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	public void getUserProfile(HttpServletRequest request, HttpServletResponse response) throws Exception {
		User u=UserUtil.getCurrentUser(request);
		UserInfoEntity userInfo=ApiCommon.getUserInfo(u.getId());
		Map map=new HashMap();
		map.put("discount_get",FrontUtil.formatRmbDouble(userInfo.getTotalConsumeSurplus().doubleValue()));
		map.put("rshoper_get",FrontUtil.formatRmbDouble(userInfo.getTotalSellerSurplus().doubleValue()));
		map.put("ruser_get",FrontUtil.formatRmbDouble(userInfo.getTotalUserSurplus().doubleValue()));
		map.put("proxy2_get",FrontUtil.formatRmbDouble(userInfo.getTotalProxySurplus().doubleValue()));
		map.put("proxy3_get",FrontUtil.formatRmbDouble(userInfo.getTotalProxy2Surplus().doubleValue()));
		map.put("proxy_get",FrontUtil.formatRmbDouble(userInfo.getTotalProxyRecommedSurplus().doubleValue()));
		map.put("lottery_get", FrontUtil.formatRmbDouble(userInfo.getTotalLotterySurplus().doubleValue()));
		map.put("bonus_get", FrontUtil.formatRmbDouble(userInfo.getTotalBonusSurplus().doubleValue()));
		map.put("other_get", FrontUtil.formatRmbDouble(userInfo.getTotalOtherSurplus().doubleValue()));
		ServletUtil.writeOkCommonReply(map, response);
	}
	/**
	 * 更新商家审核资料 -大小王科技api
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	public void updateShopData(HttpServletRequest request, HttpServletResponse response) throws Exception {
		User user = ServletUtil.readObjectServletQuery(request, User.class);
		User u=UserUtil.getCurrentUser(request);
		u.setLicenceFileName(user.getLicenceFileName());
		u.setLicenceFileURL(user.getLicenceFileURL());
		u.setLicenceNumber(user.getLicenceNumber());
		u.setLocal(user.getLocal());
		u.setLocal2(user.getLocal2());
		u.setLocal3(user.getLocal3());
		UserService userServ=new UserServiceImpl();
		userServ.save(u);
		ServletUtil.writeOkCommonReply(u, response);
	}
	
	public void bindWeixinOpenId(HttpServletRequest request, HttpServletResponse response) throws Exception {
		String code="";
		String baseUrl=MainConfig.getContextPath();
		if(request.getParameter("code")==null){
			response.sendRedirect(baseUrl+"pleaseOpenInWeixin.jsp");
		}
		code=request.getParameter("code");
		String uri="https://api.weixin.qq.com/sns/oauth2/access_token?appid="+MainConfig.getWechatappid()+"&secret="+MainConfig.getWechatappsecret()+"&code="+code+"&grant_type=authorization_code";
		JSONObject jsonObject =HttpUtils.httpGet(uri);
		String access_token=jsonObject.get("access_token").toString();
		String refresh_token=jsonObject.get("refresh_token").toString();
		String openid=jsonObject.get("openid").toString();
		User user=UserUtil.getCurrentUser(request);
		user.setOpenid(openid);
		UserService userServ=new UserServiceImpl();
		userServ.save(user);
		response.sendRedirect(baseUrl+"user_index.jsp");
	}
}
