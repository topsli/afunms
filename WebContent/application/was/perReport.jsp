<%@ page language="java" contentType="text/html;charset=gb2312"%>
<%@ include file="/include/globe.inc"%>
<%@ include file="/include/globeChinese.inc" %>

<%@page import="com.afunms.detail.service.IISInfo.IISInfoService"%>
<%@page import="com.afunms.report.jfree.ChartCreator"%>
<%@page import="com.afunms.topology.util.NodeHelper"%>
<%@page import="com.afunms.monitor.item.*"%>
<%@page import="com.afunms.polling.node.*" %>
<%@page import="com.afunms.polling.om.*" %>
<%@page import="com.afunms.monitor.item.base.MonitorResult"%>
<%@page import="com.afunms.polling.*"%>
<%@page import="com.afunms.monitor.item.base.MoidConstants"%>
<%@page import="org.jfree.data.general.DefaultPieDataset"%>
<%@page import="com.afunms.application.util.*"%>
<%@page import="org.jdom.Element"%>
<%@page import="com.afunms.common.util.*"%>
<%@page import="java.util.*"%>
<%@page import="com.afunms.application.manage.*"%>
<%@page import="com.afunms.application.dao.*"%>
<%@page import="com.afunms.application.model.*"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.lang.*"%>
<%@page import="com.afunms.polling.*"%>
<%@page import="com.afunms.application.manage.WasManager"%>
<%@page import="com.afunms.application.wasmonitor.*"%>
<html>
<head>
<%
   String runmodel = PollingEngine.getCollectwebflag(); 
   String rootPath = request.getContextPath(); 
   String menuTable = (String)request.getAttribute("menuTable");
   
   WasConfig vo = (WasConfig)request.getAttribute("was");
   if(vo == null){
		vo = new WasConfig();
   }
    Hashtable hs = null;
	HashMap system = null;
	HashMap hm = null;
	HashMap jvm = null;
	HashMap cache = null;
	Hashtable wasIpaddressData = null;
   String ip = vo.getIpaddress().replace(".","_");
   if("0".equals(runmodel)){
   		  //采集与访问是集成模式
		  Hashtable wasHashtables = (Hashtable)com.afunms.common.util.ShareData.getWasdata();
		  wasIpaddressData = (Hashtable)wasHashtables.get(vo.getIpaddress());
		  System.out.println("wasIpaddressData:"+wasIpaddressData);
		  if(wasIpaddressData != null){
		  if(vo.getVersion().equalsIgnoreCase("v5")){
			  Hashtable systemHashtable = (Hashtable)wasIpaddressData.get("systemDatahst");
		//	  System.out.println(systemHashtable);
			  Hashtable cacheHashtable = (Hashtable)wasIpaddressData.get("cachehst");
		//	  System.out.println(cacheHashtable);
			  Hashtable jvmHashtable = (Hashtable)wasIpaddressData.get("jvmhst");
		//	  System.out.println(jvmHashtable);
		      jvm = CommonUtil.converHashTableToHashMap(jvmHashtable); 
		      cache = CommonUtil.converHashTableToHashMap(cacheHashtable); 
			  system = CommonUtil.converHashTableToHashMap(systemHashtable); 
		   }else{
			  Hashtable systemHashtable = (Hashtable)wasIpaddressData.get("system7hst");
		//	  System.out.println(systemHashtable);
			  Hashtable cacheHashtable = (Hashtable)wasIpaddressData.get("extension7hst");
		//	  System.out.println(cacheHashtable);
			  Hashtable jvmHashtable = (Hashtable)wasIpaddressData.get("jvm7hst");
		//	  System.out.println(jvmHashtable);
		      jvm = CommonUtil.converHashTableToHashMap(jvmHashtable); 
		      cache = CommonUtil.converHashTableToHashMap(cacheHashtable); 
			  system = CommonUtil.converHashTableToHashMap(systemHashtable); 
			  }  
		  }
  	}else{
  		 //采集与访问分离模式
  		 GetWasInfo wasconf = new GetWasInfo();
  		 try{
		 	 system = wasconf.executeQueryHashMap(vo.getIpaddress(),"wassystem");
		 	 cache = wasconf.executeQueryHashMap(vo.getIpaddress(),"wascache");
		 	 jvm = wasconf.executeQueryHashMap(vo.getIpaddress(),"wasjvm");
	 	 }catch(Exception e){
		 	e.printStackTrace();
		 }finally{
		 	 wasconf.close();
		 }
  	}
  	if(hm == null) {
  		hm = new HashMap();
  	}
	String tmp = vo.getId()+"";
%>
<link href="<%=rootPath%>/resource/<%=com.afunms.common.util.CommonAppUtil.getSkinPath() %>css/global/global.css" rel="stylesheet" type="text/css"/>

<title>WAS性能报表</title>
<script type='text/javascript' src='/afunms/dwr/interface/DWRUtil.js'></script>
<script type='text/javascript' src='/afunms/dwr/engine.js'></script>
<script type='text/javascript' src='/afunms/dwr/util.js'></script>
<script language="javascript" src="/afunms/js/tool.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<script type="text/javascript" src="<%=rootPath%>/include/swfobject.js"></script>
<script language="JavaScript" type="text/javascript" src="<%=rootPath%>/include/navbar.js"></script>
<script type="text/javascript" src="<%=rootPath%>/resource/js/page.js"></script> 
<script language="JavaScript" src="<%=rootPath%>/include/date.js"></script> 
<script type="text/javascript" 	src="<%=rootPath%>/js/ext/lib/adapter/ext/ext-base.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=rootPath%>/js/ext/lib/ext-all.js" charset="utf-8"></script>
<script type="text/javascript" src="<%=rootPath%>/js/ext/lib/locale/ext-lang-zh_CN.js" charset="utf-8"></script>
<script language="JavaScript" type="text/JavaScript">
function ping_word_report()
{
	mainForm.action = "<%=rootPath%>/was.do?action=downloadAllReport&type=per&str=1&id=<%=tmp%>";
	mainForm.submit();
}
function ping_excel_report()
{
	mainForm.action = "<%=rootPath%>/was.do?action=downloadAllReport&type=per&str=0&id=<%=tmp%>";
	mainForm.submit();
}
function ping_pdf_report()
{
	mainForm.action = "<%=rootPath%>/was.do?action=downloadAllReport&type=per&str=2&id=<%=tmp%>";
	mainForm.submit();
}
function ping_ok()
{
	var starttime = document.getElementById("mystartdate").value;
	var endtime = document.getElementById("mytodate").value;
	mainForm.action = "<%=rootPath%>/mq.do?action=showPingReport&id=<%=tmp%>&startdate="+starttime+"&todate="+endtime;
	mainForm.submit();
}
function ping_cancel()
{
window.close();
}
function query(){
  	var startdate = mainForm.startdate.value;
  	var todate = mainForm.todate.value;      
  	var oids ="";
  	var checkbox = document.getElementsByName("checkbox");
 		for (var i=0;i<checkbox.length;i++){
 			if(checkbox[i].checked==true){
 				if (oids==""){
 					oids=checkbox[i].value;
 				}else{
 					oids=oids+","+checkbox[i].value;
 				}
 			}
 		}
 	if(oids==null||oids==""){
 		alert("请至少选择一个设备");
 		return;
 	}
 	window.open ("<%=rootPath%>/hostreport.do?action=downloadmultihostreport&startdate="+startdate+"&todate="+todate+"&ids="+oids, "newwindow", "height=500, width=600, toolbar= no, menubar=no, scrollbars=yes, resizable=yes, location=yes, status=yes")    	      
}

function openwin(str,operate,ip) 
{	
  var startdate = mainForm.startdate.value;
  var todate = mainForm.todate.value;
  window.open ("<%=rootPath%>/hostreport.do?action="+operate+"&startdate="+startdate+"&todate="+todate+"&ipaddress="+ip+"&str="+str+"&type=host", "newwindow", "height=500, width=600, toolbar= no, menubar=no, scrollbars=yes, resizable=yes, location=yes, status=yes") 
}
function changeOrder(para){
	mainForm.orderflag.value = para;
	mainForm.action="<%=rootPath%>/netreport.do?action=netping"
  	mainForm.submit();
}
  Ext.onReady(function()
{  

setTimeout(function(){
	        Ext.get('loading').remove();
	        Ext.get('loading-mask').fadeOut({remove:true});
	    }, 250);
	
 Ext.get("process").on("click",function(){
     
     //if(chk1&&chk2&&chk3)
     //{
     
        Ext.MessageBox.wait('数据加载中，请稍后.. '); 
        //msg.style.display="block";
	mainForm.action="<%=rootPath%>/hostreport.do?action=hostcpu";
	mainForm.submit();        
        //mainForm.action = "<%=rootPath%>/network.do?action=add";
        //mainForm.submit();
     //}  
       // mainForm.submit();
 });	
	
});
</script>



<script language="JavaScript" type="text/JavaScript">
var show = true;
var hide = false;
//修改菜单的上下箭头符号

function my_on(head,body)
{
	var tag_a;
	for(var i=0;i<head.childNodes.length;i++)
	{
		if (head.childNodes[i].nodeName=="A")
		{
			tag_a=head.childNodes[i];
			break;
		}
	}
	tag_a.className="on";
}
function my_off(head,body)
{
	var tag_a;
	for(var i=0;i<head.childNodes.length;i++)
	{
		if (head.childNodes[i].nodeName=="A")
		{
			tag_a=head.childNodes[i];
			break;
		}
	}
	tag_a.className="off";
}
//添加菜单	
function initmenu()
{
	var idpattern=new RegExp("^menu");
	var menupattern=new RegExp("child$");
	var tds = document.getElementsByTagName("div");
	for(var i=0,j=tds.length;i<j;i++){
		var td = tds[i];
		if(idpattern.test(td.id)&&!menupattern.test(td.id)){					
			menu =new Menu(td.id,td.id+"child",'dtu','100',show,my_on,my_off);
			menu.init();		
		}
	}
	setClass();
}

function setClass(){
	document.getElementById('hostReportTitle-5').className='detail-data-title';
	document.getElementById('hostReportTitle-5').onmouseover="this.className='detail-data-title'";
	document.getElementById('hostReportTitle-5').onmouseout="this.className='detail-data-title'";
}

function refer(action){
		var mainForm = document.getElementById("mainForm");
		mainForm.action = '<%=rootPath%>' + action;
		mainForm.submit();
}
</script>
<!-- snow add 2010-5-28 -->
<style>
<!--
body{
background-image: url(${pageContext.request.contextPath}/resource/image/bg.jpg);
TEXT-ALIGN: center;
}
-->
</style>
</head>
<body id="body" class="body" onload="init();">
<IFRAME frameBorder=0 id=CalFrame marginHeight=0 marginWidth=0 noResize scrolling=no src="<%=rootPath%>/include/calendar.htm" style="DISPLAY: none; HEIGHT: 189px; POSITION: absolute; WIDTH: 148px; Z-INDEX: 100"></IFRAME>
<form id="mainForm" method="post" name="mainForm">
<input type=hidden id="ipaddress" name="ipaddress" value=<%=request.getParameter("ipaddress") %>>
	<table id="container-main" class="container-main">
		<tr>
			<td>
				<table id="container-main-win" class="container-main-win">
					<tr>
						<td>
							<table id="win-content" class="win-content">
								<tr>
									<td>
										<table id="win-content-header" class="win-content-header">
				                			<tr>
							                	<td align="left" width="5"><img src="<%=rootPath%>/common/images/right_t_01.jpg" width="5" height="29" /></td>
							                	<td class="win-content-title" style="align:center">&nbsp;WAS (<%=vo.getIpaddress() %>)性能报表</td>
							                    <td align="right"><img src="<%=rootPath%>/common/images/right_t_03.jpg" width="5" height="29" /></td>											   
											</tr>
									    
					       				</table>
				       				</td>
				       			</tr>
						       	<tr>
						       		<td>
						       			<table id="win-content-body" class="win-content-body">
											<tr>
						       					<td>
													<table bgcolor="#ECECEC">
														<tr align="left" valign="center"> 
														<td height="28" align="left" width=60%>
														</td>
														<td height="28" align="left">
															<a href="javascript:ping_word_report()"><img name="selDay1" alt='导出word' style="CURSOR:hand" src="<%=rootPath%>/resource/image/export_word.gif" width=18  border="0">导出WORLD</a>
														</td>
														<td height="28" align="left">
															<a href="javascript:ping_excel_report()"><img name="selDay1" alt='导出EXCEL' style="CURSOR:hand" src="<%=rootPath%>/resource/image/export_excel.gif" width=18  border="0">导出EXCEL</a>
														</td>
														<td height="28" align="left">&nbsp;
															<a href="javascript:ping_pdf_report()"><img name="selDay1" alt='导出word' style="CURSOR: hand" src="<%=rootPath%>/resource/image/export_pdf.gif" width=18 border="0">导出PDF</a>
														</td>
														</tr>  
													</table>
						       					</td>
						       				</tr>
							       			<tr align="left" valign="center"> 
			             						<td height="20" align="left" border="0">
													<input type=hidden name="eventid">
													<div id="loading">
													<div class="loading-indicator">
														<img src="<%=rootPath%>/js/ext/lib/resources/extanim64.gif" width="32" height="32" style="margin-right: 8px;" align="middle" />Loading...</div>
													</div>
												</td>
											</tr>
											
											
											<tr align="right"><td width=820px align=center><table >

											  <tr align="right">
											   
											     <td width=10px></td>
											   
											  <td align="right"><table border=2 rules="cols">
											
											<tr>
									 				   <td>
									 				     <table border=1>
									 				       <tr>
									 				         <td></td>
									 				       </tr>
									 				     </table>
									 				   </td>
									 				 </tr>
											<tr>
											    	<td width=100%>
											    		<table border=0 class="application-detail-data-body">
											    		   <tr>
														<td>
												      		<table width="100%"  border=0 align="center">
													      		<tr  >
																	<td height=29>System信息</td>
																</tr>
																<tr>
													<td>
														<table class="application-detail-data-body">
															<tr>
																<td>
																	<table width="100%" align="center">
																		<tr >
																			<td width="15%" height="26" align="left" nowrap
																				class=txtGlobal>
																				&nbsp;空闲内存的快照（KB）:
																			</td>
																			<%
																			if(system != null){
																				if (system.get("freeMemory") != null) {
																			%>
																			<td width="35%"><%=system.get("freeMemory")%>
																			</td>
																			<%
																				} else {
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				}
																			%>
																			<td width="15%" height="26" align="left" nowrap
																				class=txtGlobal>
																				&nbsp;自服务器启动以来的CPU平均使用率:
																			</td>
																			<%
																			if(system != null){
																				if (system.get("cpuUsageSinceServerStarted") != null) {
																			%>
																			<td width="35%"><%=system.get("cpuUsageSinceServerStarted")%>%
																			</td>
																			<%
																				} else {
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				}
																			%>
																		</tr>
																		<tr >
																			<td width="15%" height="26" align="left" nowrap
																				class=txtGlobal>
																				&nbsp;自上次查询以来的平均CPU使用率:
																			</td>
																			<%
																			if(system != null){
																				if (system.get("cpuUsageSinceLastMeasurement") != null) {
																			%>
																			<td width="35%"><%=system.get("cpuUsageSinceLastMeasurement")%>%
																			</td>
																			<%
																				} else {
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				}
																			%>
																			<td></td>
																			<td></td>
																		</tr>
																	</table>
																</td>
															</tr>
														</table>
													</td>
												</tr>  
												
												
												
													      	</table>
									   					</td>
									 				 </tr>	
									 				 
									 				 
									 				 <tr>
									 				   <td>
									 				     <table border=1>
									 				       <tr>
									 				         <td></td>
									 				       </tr>
									 				     </table>
									 				   </td>
									 				 </tr>
									 				 
									 				 
									 				  <tr>
														<td>
												      		<table width="96%" align="center" border=0>
													      		<tr >
																	<td height=29>JVM信息</td>
																</tr>
																<tr>
													<td>
														<table class="application-detail-data-body">
															<tr>
																<td>
																	<table width="96%" align="center">
																		<tr >
																			<td width="15%" height="26" align="left" nowrap
																				class=txtGlobal>
																				&nbsp;Java虚拟机运行时空闲的内存（KB）:
																			</td>
																			<%
																			if(jvm != null){
																				if (jvm.get("freeMemory") != null) {
																			%>
																			<td width="35%"><%=jvm.get("freeMemory")%>
																			</td>
																			<%
																				} else {
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				}else{
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				%>
																			<td width="15%" height="26" align="left" nowrap
																				class=txtGlobal>
																				&nbsp;Java虚拟机运行时总内存（KB）:
																			</td>
																			<%
																			if(jvm != null){
																				if (jvm.get("heapSize") != null) {
																			%>
																			<td width="35%"><%=jvm.get("heapSize")%>
																			</td>
																			<%
																				} else {
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				}else{
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				%>
																		</tr>
																		<tr >
																			<td width="15%" height="26" align="left" nowrap
																				class=txtGlobal>
																				&nbsp;已经运行的时间数（秒）:
																			</td>
																			<%
																			if(jvm != null){
																				if (jvm.get("upTime") != null) {
																			%>
																			<td width="35%"><%=jvm.get("upTime")%>
																			</td>
																			<%
																				} else {
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				}else{
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				%>
																			<td width="15%" height="26" align="left" nowrap
																				class=txtGlobal>
																				&nbsp;Java虚拟机运行时使用的内存（KB）:
																			</td>
																			<%
																			if(jvm != null){
																				if (jvm.get("usedMemory") != null) {
																			%>
																			<td width="35%"><%=jvm.get("usedMemory")%>
																			</td>
																			<%
																				} else {
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				}else{
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				%>
																		</tr>
																		<tr >
																			<td width="15%" height="26" align="left" nowrap
																				class=txtGlobal>
																				&nbsp;Java虚拟机内存利用率:
																			</td>
																			<%
																			if(jvm != null){
																				if (jvm.get("memPer") != null) {
																			%>
																			<td width="35%"><%=jvm.get("memPer")%>%
																			</td>
																			<%
																				} else {
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				}else{
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				%>
																			<td width="15%" height="26" align="left" nowrap
																				class=txtGlobal></td>
																			<td width="35%"></td>
																		</tr>

																	</table>
																</td>
															</tr>
														</table>
													</td>
												</tr>    
												
												
													      	</table>
									   					</td>
									 				 </tr>	
									 				 
									 				 <tr>
									 				   <td>
									 				     <table border=1>
									 				       <tr>
									 				         <td></td>
									 				       </tr>
									 				     </table>
									 				   </td>
									 				 </tr>
									 				 
									 				 
									 				 <tr>
														<td>
												      		<table width="96%" align="center" border=0>
		                                                       	<tr >
																	<td height=29>缓存信息</td>
																</tr>
																<tr>
													<td>
														<table class="application-detail-data-body">
															<tr>
																<td>
																	<table width="96%" align="center">
																		<tr >
																			<td width="15%" height="26" align="left" nowrap
																				class=txtGlobal>
																				&nbsp;内存中的高速缓存条目当前数:
																			</td>
																			<%
																			if(cache != null){
																				if (cache.get("inMemoryCacheCount") != null) {
																			%>
																			<td width="35%"><%=cache.get("inMemoryCacheCount")%>
																			</td>
																			<%
																				} else {
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				}else{
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				%>
																			<td width="15%" height="26" align="left" nowrap
																				class=txtGlobal>
																				&nbsp;高速缓存条目最大数:
																			</td>
																			<%
																			if(cache != null){
																				if (cache.get("maxInMemoryCacheCount") != null) {
																			%>
																			<td width="35%"><%=cache.get("maxInMemoryCacheCount")%>
																			</td>
																			<%
																				} else {
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				}else{
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				%>
																		</tr>
																		<tr>
																			<td width="15%" height="26" align="left" nowrap
																				class=txtGlobal>
																				&nbsp;超时数:
																			</td>
																			<%
																			if(cache != null){
																				if (cache.get("timeoutInvalidationCount") != null) {
																			%>
																			<td width="35%"><%=cache.get("timeoutInvalidationCount")%>
																			</td>
																			<%
																				} else {
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				}else{
																			%>
																			<td width="35%"></td>
																			<%
																				}
																				%>
																			<td width="15%" height="26" align="left" nowrap
																				class=txtGlobal></td>

																			<td width="35%"></td>
																		</tr>

																	</table>
																</td>
															</tr>
														</table>
													</td>
												</tr>	
												
												
												
												
                    									</table>       
												    </td>
										    </tr>

										<tr>
									 				   <td>
									 				     <table border=1>
									 				       <tr>
									 				         <td></td>
									 				       </tr>
									 				     </table>
									 				   </td>
									 				 </tr>
												</table></td></tr>
												</table></td></tr>
												
												
				</table><br><br>
            		<div align=center>
            			<input type=button value="关闭窗口" onclick="window.close()">
            		</div>  <br>
  			
			             						</td>
											</tr>  
						       			</table>
						       		</td>
						       	</tr>
						                
              					</table>
              				</td>
              			</tr>
      				</table>
					</td>
				</tr>
       			</table>
			
					<br>
</form>  
</body>
</html>