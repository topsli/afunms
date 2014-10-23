<%@page language="java" contentType="text/html;charset=gb2312" %>
<%@ include file="/include/globe.inc"%>
<%@ include file="/include/globeChinese.inc"%>

<%@page import="com.afunms.topology.model.HostNode"%>
<%@page import="com.afunms.common.base.JspPage"%>
<%@page import="com.afunms.common.util.SysUtil"%>
<%@page import="com.afunms.common.util.*" %>
<%@page import="com.afunms.monitor.item.*"%>
<%@page import="com.afunms.polling.node.*"%>
<%@page import="com.afunms.polling.*"%>
<%@page import="com.afunms.polling.impl.*"%>
<%@page import="com.afunms.polling.api.*"%>
<%@page import="com.afunms.topology.util.NodeHelper"%>
<%@page import="com.afunms.topology.dao.*"%>
<%@page import="com.afunms.monitor.item.base.MoidConstants"%>
<%@page import="org.jfree.data.general.DefaultPieDataset"%>
<%@ page import="com.afunms.polling.api.I_Portconfig"%>
<%@ page import="com.afunms.polling.om.Portconfig"%>
<%@ page import="com.afunms.polling.om.*"%>
<%@ page import="com.afunms.polling.impl.PortconfigManager"%>
<%@page import="com.afunms.report.jfree.ChartCreator"%>

<%@page import="com.afunms.config.dao.*"%>
<%@page import="com.afunms.config.model.*"%>
<%@page import="com.afunms.application.dao.*"%>
<%@page import="com.afunms.application.model.*"%>
<%@page import="com.afunms.application.manage.WasManager"%>
<%@page import="com.afunms.application.wasmonitor.*"%>
<%@page import="java.util.*"%>
<%@page import="java.text.*"%>
<%@page import="java.lang.*"%>
<%@page import="com.afunms.monitor.item.base.*"%>
<%@page import="com.afunms.monitor.executor.base.*"%>
<%@ page import="com.afunms.mq.DEServerConstants"%>
<%@ page import="com.ibm.mq.pcf.CMQXC"%>
<%@ page import="com.ibm.mq.pcf.CMQCFC"%>
<%@ page import="com.afunms.mq.*"%>

<%
 	String rootPath = request.getContextPath();
 	String menuTable = (String)request.getAttribute("menuTable");
 	Double mqAvgPing = (Double)request.getAttribute("mqAvgPing");
	int percent1 = Double.valueOf(mqAvgPing).intValue();
	int percent2 = 100-percent1;
	String dbPage = "detail";
	String flag_1 = (String)request.getAttribute("flag");
	MQConfig vo = (MQConfig)request.getAttribute("vo");
	if(vo == null){
		vo = new MQConfig();
	}
	StringBuffer dataStr = new StringBuffer();
 	dataStr.append("连通;").append(Math.round(mqAvgPing)).append(";false;7CFC00\\n");
 	dataStr.append("未连通;").append(100-Math.round(mqAvgPing)).append(";false;FF0000\\n");
 	String avgdata = dataStr.toString();
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<script type="text/javascript" src="<%=rootPath%>/include/swfobject.js"></script>
<script language="JavaScript" type="text/javascript" src="<%=rootPath%>/include/navbar.js"></script>

<link href="<%=rootPath%>/resource/<%=com.afunms.common.util.CommonAppUtil.getSkinPath() %>css/global/global.css" rel="stylesheet" type="text/css"/>


<link rel="stylesheet" type="text/css" 	href="<%=rootPath%>/js/ext/lib/resources/css/ext-all.css" charset="gb2312" />
<link rel="stylesheet" type="text/css" href="<%=rootPath%>/js/ext/css/common.css" charset="gb2312"/>
<script type="text/javascript" src="<%=rootPath%>/resource/js/page.js"></script> 

<script language="javascript">	

  function doQuery()
  {  
     if(mainForm.key.value=="")
     {
     	alert("请输入查询条件");
     	return false;
     }
     mainForm.action = "<%=rootPath%>/network.do?action=find";
     mainForm.submit();
  }
  
  function doChange()
  {
     if(mainForm.view_type.value==1)
        window.location = "<%=rootPath%>/topology/network/index.jsp";
     else
        window.location = "<%=rootPath%>/topology/network/port.jsp";
  }

  function toAdd()
  {
      mainForm.action = "<%=rootPath%>/network.do?action=ready_add";
      mainForm.submit();
  } 
  
// 全屏观看
function gotoFullScreen() {
	parent.mainFrame.resetProcDlg();
	var status = "toolbar=no,height="+ window.screen.height + ",";
	status += "width=" + (window.screen.width-8) + ",scrollbars=no";
	status += "screenX=0,screenY=0";
	window.open("topology/network/index.jsp", "fullScreenWindow", status);
	parent.mainFrame.zoomProcDlg("out");
}
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
	document.getElementById('wasDetailTitle-0').className='detail-data-title';
	document.getElementById('wasDetailTitle-0').onmouseover="this.className='detail-data-title'";
	document.getElementById('wasDetailTitle-0').onmouseout="this.className='detail-data-title'";
}


</script>
</head>
<body id="body" class="body" onload="initmenu();">
<form method="post" name="mainForm">
<input type=hidden name="orderflag">
<input type=hidden name="id">
<table border="0"  cellpadding="0" cellspacing="0" width=960 id="body-container" class="body-container">
	<tr>
		<td class="td-container-menu-bar">
			<table id="container-menu-bar" class="container-menu-bar">
				<tr>
					<td>
						<%=menuTable%>
					</td>	
				</tr>
			</table>
		</td>
		<td class="td-container-main">
			<table id="container-main" class="container-main">
				<tr>
					<td class="td-container-main-add">
						<table id="container-main-add" class="container-main-add">
							<tr>
								<td>
									<table id="add-content" class="add-content">
										<tr>
											<td>
												<table id="add-content-header" class="add-content-header">
								                	<tr>
									                	<td align="left" width="5"><img src="<%=rootPath%>/common/images/right_t_01.jpg" width="5" height="29" /></td>
									                	<td><b>应用 >>MQ监视 >> <%=vo.getName()%> 详细信息</b></td>
									                    <td align="right"><img src="<%=rootPath%>/common/images/right_t_03.jpg" width="5" height="29" /></td>
									       			</tr>
									        	</table>
		        							</td>
		        						</tr>
		        						<tr>
		        							<td>
		        								<table id="application-detail-content-body" class="application-detail-content-body">
		        									<tr>
		        										<td>
		        											<table>
								               					<tr>
								     								<td width="82%" align="left" valign="top">
						        										<table>
				                    										<tr>
				                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;名称:</td>
				                      											<td width="35%"><%=vo.getName()%> </td>	
																				<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;消息管理器名称:</td>
				                      											<td width="35%"><%=vo.getManagername()%> </td>
				                    										</tr>
				                    										<tr bgcolor="#ECECEC">
				                    											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;IP地址:</td>
				                      											<td width="35%"><%=vo.getIpaddress()%> </td>
				                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;端口:</td>
				                      											<td width="35%"><%=vo.getPortnum()%> </td>
				                    										</tr>   
				                    										<%
				                    										Hashtable basicInfoHashtable = (Hashtable)request.getAttribute("basicInfoHashtable");
				                    										if(null != basicInfoHashtable && basicInfoHashtable.size() > 0){
				                    											String name = (String)basicInfoHashtable.get("name");
				                    											if("null".equals(name)){name = "";}
				                    											String version = (String)basicInfoHashtable.get("version");
				                    											if("null".equals(version)){version = "";}
				                    											String platform = (String)basicInfoHashtable.get("platform");
				                    											if("null".equals(platform)){platform = "";}
				                    											String qmname = (String)basicInfoHashtable.get("qmname");
				                    											if("null".equals(qmname)){qmname = "";}
				                    											String status = (String)basicInfoHashtable.get("status");
				                    											if("null".equals(status)){status = "";}
				                    											String listener = (String)basicInfoHashtable.get("listener");
				                    											if("null".equals(listener)){listener = "";}
				                    											String backlog = (String)basicInfoHashtable.get("backlog");
				                    											if("null".equals(backlog)){backlog = "";}
				                    										 %>
				                    										 <tr>
				                    											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;服务名称:</td>
				                      											<td width="35%"><%=name%> </td>
				                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;版本:</td>
				                      											<td width="35%"><%=version%> </td>
				                    										 </tr>   
				                    										 <tr bgcolor="#ECECEC">
				                    											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;平台:</td>
				                      											<td width="35%"><%=platform%> </td>
				                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;QMNAME:</td>
				                      											<td width="35%"><%=qmname%> </td>
				                    										 </tr>   
				                    										 <%
				                    										 }
				                    										  %>
				                    										<tr>
				                    											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;管理状态:</td>
																				<%if(vo.getMon_flag()==1){%>
				                      											<td width="35%">已监视</td>
																				<%}else{%>
																				<td width="35%">未监视</td>
																				<%}%>
																				<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;采集时间:</td>
																				<%
																				String collecttime = (String)request.getAttribute("collecttime");
																				if("null".equals(collecttime)){collecttime="";}
																				 %>
				                      											<td width="35%"><%=collecttime%> </td>
				                    										</tr> 
			                											</table>
								        							</td>
								        							<%-- 
																	<td width="17%" align="center" valign="middle" class=dashLeft>
																		<table width="95%" style="BORDER-COLLAPSE: collapse" borderColor=#cedefa cellPadding=0 rules=none  align=center border=1 align="center">
                         													<tr>
					                											<td width="400" align="left" valign="middle" class=dashLeft>
					                												<table  style="BORDER-COLLAPSE: collapse" bordercolor=#cedefa  cellpadding=0 rules=none width=80% align=center border=1 align="center" >
				                    													<tr bgcolor=#F1F1F1 height="26">
														                                    <td align="center" >
															                                    今日连通率
														                                    </td>
													                                   </tr>
				                    													<tr class="topNameRight">
				                      														<td height="30" align="center">
				                      														<!-- 
				                      															<div id="flashcontent00">
																									<strong>You need to upgrade your Flash Player</strong>
																								</div>
																								<script type="text/javascript">
																									var so = new SWFObject("<%=rootPath%>/flex/Pie_Component.swf?percent1=<%=percent1%>&percentStr1=可用&percent2=<%=percent2%>&percentStr2=不可用", "Pie_Component", "160", "160", "8", "#ffffff");
																									so.write("flashcontent00");
																								</script>
																							-->
																							<div id="avgping">
				                                                                             <strong>You need to upgrade your Flash Player</strong>
				                                                                            </div>
				                                                                         <script type="text/javascript"
							                                                                     src="<%=rootPath%>/include/swfobject.js"></script>
					                                                                     <script type="text/javascript">
						                                                                  var so = new SWFObject("<%=rootPath%>/amchart/ampie.swf", "ampie","165", "165", "8", "#FFFFFF");
						                                                                      so.addVariable("path", "<%=rootPath%>/amchart/");
						                                                                      so.addVariable("settings_file", escape("<%=rootPath%>/amcharts_settings/pingStatepie.xml"));
						                                                                      so.addVariable("chart_data","<%=avgdata%>");
						                                                                      so.write("avgping");
					                                                                       </script>
				                      														</td>
				                    													</tr>
					                												</table>				
				                												</td>
															                 </tr>				
				                										</table>
				                									</td>
				                									--%>
										                       </tr>				
               												</table>
		        										</td>
		        									</tr>
		        								</table>
		        							</td>
		        						</tr>
              				            <tr>
		        							<td>
		        								<table id="application-detail-content-footer" class="application-detail-content-footer">
		        									<tr>
		        										<td>
		        											<table width="100%" border="0" cellspacing="0" cellpadding="0">
									                  			<tr>
									                    			<td align="left" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_01.jpg" width="5" height="12" /></td>
									                    			<td></td>
									                    			<td align="right" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_03.jpg" width="5" height="12" /></td>
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
									<table id="application-detail-data" class="application-detail-data">
                                       <tr>
									    	<td>
									    		<table class="application-detail-data-body">
									 				  <tr>
														<td>
												      		<table width="96%" align="center">
													      		<tr bgcolor="#F1F1F1">
																	<td>通道信息</td>
																</tr>
																<tr>
																	<td align=center>
																		<table width=80%>
		  																	<tr bgcolor="#FFFFFF">
		    																	<td width=10% class="detail-data-body-title" style="height:29;align:center"><strong>序号</strong></td>
																			    <td width=20% class="detail-data-body-title" style="height:29;align:center"><strong>通道名称</strong></td>
																			    <td width=15% class="detail-data-body-title" style="height:29;align:center"><strong>通道状态</strong></td>
																			    <td width=15% class="detail-data-body-title" style="height:29;align:center"><strong>接收的缓存数</strong></td>
																			    <td width=10% class="detail-data-body-title" style="height:29;align:center"><strong>发送的缓存数</strong></td>
																			    <td width=10% class="detail-data-body-title" style="height:29;align:center"><strong>接收的字节数</strong></td>
																			    <td width=10% class="detail-data-body-title" style="height:29;align:center"><strong>发送的字节数</strong></td>
		    																</tr>
										     								<%
																			 	List chstatusList = (List)request.getAttribute("chstatusList"); 	
																			 	if (chstatusList != null && chstatusList.size()>0){
																			 		for(int i=0;i<chstatusList.size();i++){
																			 			Hashtable tmpHashtable = (Hashtable)chstatusList.get(i);
																			 			if (tmpHashtable != null && tmpHashtable.size()>0){
																			 				String chstatusname = (String)tmpHashtable.get("chstatusname");
																							String bufsrcvd = (String)tmpHashtable.get("bufsrcvd");
																							String bufssent = (String)tmpHashtable.get("bufssent");
																							String bytsrcvd = (String)tmpHashtable.get("bytsrcvd");
																							String bytssent = (String)tmpHashtable.get("bytssent");
																							String status = (String)tmpHashtable.get("status");
																			 		
																			 %>    
																						  <tr  class="othertr" <%=onmouseoverstyle%> >
																						    <td height="28" class="detail-data-body-list"><%=i+1%></td>
																						    <td class="detail-data-body-list"><%=chstatusname%></td>
																						    <td class="detail-data-body-list"><%=status%></td>
																						    <td class="detail-data-body-list"><%=bufsrcvd%></td>
																						    <td class="detail-data-body-list"><%=bufssent%></td>
																						    <td class="detail-data-body-list"><%=bytsrcvd%></td>
																						    <td class="detail-data-body-list"><%=bytssent%></td>
																						   </tr>
																			<%
																						}
																					}
																				}
																			%>      														
																		</table>
																	</td>
																</tr>     
													      	</table>
									   					</td>
									 				 </tr>	
									 				  <tr>
														<td>
												      		<table width="96%" align="center">
													      		<tr bgcolor="#F1F1F1">
																	<td>监听信息</td>
																</tr>
																<tr>
																	<td align=center>
																		<table width=80%>
		  																	<tr bgcolor="#FFFFFF">
		  																		<td width=10% class="detail-data-body-title" style="height:29;align:center"><strong>序号</strong></td>
																			    <td width=20% class="detail-data-body-title" style="height:29;align:center"><strong>名称</strong></td>
																			    <td width=30% class="detail-data-body-title" style="height:29;align:center"><strong>监听器支持的并发连接请求的数量</strong></td>
																			    <td width=14% class="detail-data-body-title" style="height:29;align:center"><strong>端口</strong></td>
																			    <td width=15% class="detail-data-body-title" style="height:29;align:center"><strong>状态</strong></td>
		    																</tr>
										     								<%
				                    										if(null != basicInfoHashtable && basicInfoHashtable.size() > 0){
				                    											String statu = (String)basicInfoHashtable.get("statu");
				                    											if("null".equals(statu)){statu = "";}
				                    											String listener = (String)basicInfoHashtable.get("listener");
				                    											if("null".equals(listener)){listener = "";}
				                    											String backlog = (String)basicInfoHashtable.get("backlog");
				                    											if("null".equals(backlog)){backlog = "";}
				                    											String port = (String)basicInfoHashtable.get("port");
				                    											if("null".equals(port)){port = "";}
				                    										 %>  
																			  <tr  class="othertr" <%=onmouseoverstyle%> >
																			    <td height="28" class="detail-data-body-list">1</td>
																			    <td height="28" class="detail-data-body-list"><%=listener%></td>
																			    <td height="28" class="detail-data-body-list"><%=backlog%></td>
																			    <td height="28" class="detail-data-body-list"><%=port%></td>
																			    <td height="28" class="detail-data-body-list"><%=statu%></td>
																			   </tr>
																			<%
																			}
																			%>      														
																		</table>
																	</td>
																</tr>     
													      	</table>
									   					</td>
									 				 </tr>	
									 				 <tr>
														<td>
												      		<table width="96%" align="center">
		                                                       	<tr bgcolor="#F1F1F1">
																	<td>远程队列信息</td>
																</tr>
																<tr>
																	<td align=center>
																		<table width=80%>
		  																	<tr bgcolor="#FFFFFF">
		  																	    <td width=10% class="detail-data-body-title" style="height:29;align:center"><strong>序号</strong></td>
					                    										<td width=20% class="detail-data-body-title" style="height:29;align:center"><strong>队列名称</strong></td>
																				<td width=15% class="detail-data-body-title" style="height:29;align:center"><strong>队列类型</strong></td>
																				<td width=15% class="detail-data-body-title" style="height:29;align:center"><strong>远程队列名称</strong></td>
																				<td width=15% class="detail-data-body-title" style="height:29;align:center"><strong>管理器名称</strong></td>
																				<td width=15% class="detail-data-body-title" style="height:29;align:center"><strong>传输队列名称</strong></td>
																			</tr>
					                  										<%
																			 	List remoteValue = (ArrayList)request.getAttribute("remoteQueueList"); 	
																			 	if (remoteValue != null && remoteValue.size()>0){
																			 		for(int i=0;i<remoteValue.size();i++){
																			 			Hashtable tmpHashtable = (Hashtable)remoteValue.get(i);
																			 			if (tmpHashtable != null && tmpHashtable.size()>0){ 
																			 				String queue = (String)tmpHashtable.get("queue");
																							String type = (String)tmpHashtable.get("type");
																							String rqmname = (String)tmpHashtable.get("rqmname");
																							String rname = (String)tmpHashtable.get("rname");
																							String xmitq = (String)tmpHashtable.get("xmitq");		
																			 %> 
			   
																							<tr  class="othertr" <%=onmouseoverstyle%> >
					  																			<td height="28" class="detail-data-body-list"><%=i+1 %></td>
					  																			<td height="28" class="detail-data-body-list"><%=queue%></td>
					  																			<td height="28" class="detail-data-body-list">远程队列</td>
					  																			<td height="28" class="detail-data-body-list"><%=rqmname%></td>
					  																			<td height="28" class="detail-data-body-list"><%=rname%></td>
					  																			<td height="28" class="detail-data-body-list"><%=xmitq%></td>
																							 </tr>
																			<%
																					}
																				}
																			}
																			%>
																			</table>
									   									</td>
									 								 </tr>				
															</table>
									   					</td>
									 				 </tr>
									 				 
									 				 <tr>
														<td>
												      		<table width="96%" align="center">
													      		<tr bgcolor="#F1F1F1">
																	<td>本地队列信息</td>
																</tr>
																<tr>
																	<td align=center>
																		<table width=80%>
		  																	<tr bgcolor="#FFFFFF">
		    																	<td width=10% class="detail-data-body-title" style="height:29;align:center"><strong>序号</strong></td>
		    																	<td width=20% class="detail-data-body-title" style="height:29;align:center"><strong>队列名称</strong></td>
		    																	<td width=15% class="detail-data-body-title" style="height:29;align:center"><strong>队列类型</strong></td>
		    																	<td width=15% class="detail-data-body-title" style="height:29;align:center"><strong>当前深度</strong></td>
		    																	<td width=15% class="detail-data-body-title" style="height:29;align:center"><strong>最大深度</strong></td>
		    																	<td width=15% class="detail-data-body-title" style="height:29;align:center"><strong>当前深度百分比</strong></td>
		    																</tr>
										     								<%
																			 	List localValue = (List)request.getAttribute("localQueueList"); 	
																			 	if (localValue != null && localValue.size()>0){
																			 		for(int i=0;i<localValue.size();i++){
																			 			Hashtable tmpHashtable = (Hashtable)localValue.get(i);
																			 			if (tmpHashtable != null && tmpHashtable.size() > 0){
																			 				String queue = (String)tmpHashtable.get("queue");
																							String curdepth = (String)tmpHashtable.get("curdepth");
																							String maxdepth = (String)tmpHashtable.get("maxdepth");
																							String type = (String)tmpHashtable.get("type");		
																							String percent = (String)tmpHashtable.get("percent");		
																			 %> 
						 																	<tr  class="othertr" <%=onmouseoverstyle%> >
						   																			<td height="28" class="detail-data-body-list"><%=i+1 %></td>
						   																			<td height="28" class="detail-data-body-list"><%=queue%></td>
						   																			<td height="28" class="detail-data-body-list">本地队列</td>
						   																			<td height="28" class="detail-data-body-list"><%=curdepth%></td>
						   																			<td height="28" class="detail-data-body-list"><%=maxdepth%></td>
						   																			<td height="28" class="detail-data-body-list"><%=percent%></td>
						 																	</tr>
																				<%
																						}
																					}
																				}
																				%>																	
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
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</HTML>