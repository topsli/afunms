<%@page language="java" contentType="text/html;charset=gb2312" %>
<%@page import="com.afunms.polling.node.SubSystemInfo"%>
<%@page import="com.afunms.common.util.SysUtil"%>
<%@ include file="/include/globe.inc"%>
<%@ include file="/include/globeChinese.inc"%>
<%@page import="com.afunms.common.base.JspPage"%>   
<%@page import="java.util.*"%>      
<%@page import="java.text.*"%>
<%@page import="com.afunms.polling.impl.*"%>
<%@page import="com.afunms.polling.api.*"%>
  
<%
	 String runmodel = PollingEngine.getCollectwebflag();//�ɼ������ģʽ
	 String rootPath = request.getContextPath();
	 String menuTable = (String)request.getAttribute("menuTable");
	 
	 SubSystemInfo subSystemInfo = (SubSystemInfo)request.getAttribute("subSystemInfo");
	 if(subSystemInfo == null)
	 {
	     subSystemInfo = new SubSystemInfo();
	 }
	
	 Host host = (Host)request.getAttribute("hpstorage");   
	 if(host == null)
	 {
	   host = new Host();
	 }    	
%>
<html>
	<head>

		<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
		<script type="text/javascript"
			src="<%=rootPath%>/include/swfobject.js"></script>
		<script language="JavaScript" type="text/javascript"
			src="<%=rootPath%>/include/navbar.js"></script>

		<link href="<%=rootPath%>/resource/<%=com.afunms.common.util.CommonAppUtil.getSkinPath() %>css/global/global.css"
			rel="stylesheet" type="text/css" />
		<script type="text/javascript" src="<%=rootPath%>/resource/js/page.js"></script>

		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">

		<link rel="stylesheet" type="text/css"
			href="<%=rootPath%>/js/ext/lib/resources/css/ext-all.css"
			charset="utf-8" />
		<link rel="stylesheet" type="text/css"
			href="<%=rootPath%>/js/ext/css/common.css" charset="utf-8" />
		<script type="text/javascript"
			src="<%=rootPath%>/js/ext/lib/adapter/ext/ext-base.js"
			charset="utf-8"></script>
		<script type="text/javascript"
			src="<%=rootPath%>/js/ext/lib/ext-all.js" charset="utf-8"></script>
		<script type="text/javascript"
			src="<%=rootPath%>/js/ext/lib/locale/ext-lang-zh_CN.js"
			charset="utf-8"></script>
		<script type="text/javascript"
			src="<%=rootPath%>/resource/js/jquery-1.4.2.min.js"></script>
		<script type="text/javascript"
			src="<%=rootPath%>/resource/xml/flush/amcolumn/swfobject.js"></script>
		<script language="javascript">	
var show = true;
var hide = false;
//�޸Ĳ˵������¼�ͷ����
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
//���Ӳ˵�	
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
	document.getElementById('hpStorageDetailTitle-8').className='detail-data-title';
	document.getElementById('hpStorageDetailTitle-8').onmouseover="this.className='detail-data-title'";
	document.getElementById('hpStorageDetailTitle-8').onmouseout="this.className='detail-data-title'";
}
function refer(action){
		document.getElementById("id").value="<%=host.getId()%>";
		var mainForm = document.getElementById("mainForm");
		mainForm.action = '<%=rootPath%>' + action;
		mainForm.submit();
}
</script>
	</head>
	<body id="body" class="body" onload="initmenu();">
		<form id="mainForm" method="post" name="mainForm">
		<input type=hidden name="orderflag">
		<input type=hidden name="id">
		
		<table id="body-container" class="body-container">
			<tr>
				 <!--<td class="td-container-menu-bar">
					<table id="container-menu-bar" class="container-menu-bar">
						<tr>
							<td>
								<=menuTable%>
							</td>	
						</tr>
					</table>
				</td>-->
			
				<td class="td-container-main">
					<table id="container-main" class="container-main" >
						<tr>
							<td class="td-container-main-detail"  width=98%> 
								<table id="container-main-detail" class="container-main-detail" >
										<tr>
										<td> 
											<table id="detail-content" class="detail-content" width="100%" background="<%=rootPath%>/common/images/right_t_02.jpg" cellspacing="0" cellpadding="0">
				<tr>
					<td align="left"><img src="<%=rootPath%>/common/images/right_t_01.jpg" width="5" height="29" /></td>
					<td class="layout_title"><b>�豸��ϸ��Ϣ</b></td>
					<td align="right"><img src="<%=rootPath%>/common/images/right_t_03.jpg" width="5" height="29" /></td>
				</tr>
				<tr>
				 <td width="20%" height="26" align="left" nowrap  class=txtGlobal>&nbsp;�豸��ǩ:										
										        <span id="lable"><%=host.getAlias()%></span> </td>
                         <td width="20%" height="26" align="left" nowrap class=txtGlobal>&nbsp;ϵͳ����:
											<span id="sysname">HP�洢</span></td>
                         <td width="20%" height="26" align=left valign=middle nowrap class=txtGlobal>&nbsp;IP��ַ:
											<%=host.getIpAddress()%>
						 </td>
				       </tr>
			         </table>
										</td>
									</tr>
									<tr>
										<td>
											<table id="detail-data" class="detail-data">
												<tr>
											    	<td class="detail-data-header">
											    		<%=hpStorageDetailTitleTable%>
											    	</td>
											  </tr>
											  <tr>
											      
											    	<td>
											    		<table class="detail-data-body">
												      		<tr>
												      			<td>
													      			<table width="100%" border="0" cellpadding="0" cellspacing="0">
   	                                         <tr>
										      <td> 
											           <table>
											                 <%  
											                        if(subSystemInfo != null)
											                        {
											                           
											                  %>
                    										<tr>
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;RAIDģʽ:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getRaidLevel())%> </td>	
																<td width="15%" height="26" align="left" nowrap class=txtGlobal >&nbsp;�Զ���ʽ������:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getAutoFormatDrive())%> </td>
                    										</tr>
                    										<tr bgcolor="#ECECEC">
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal >&nbsp;��ֱ���:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getHangDetection())%> </td>                      											
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;��������ٽ�ֵ:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getCapacityDepletionThreshold())%> </td>
                    										</tr>  
                    										<tr>
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal >&nbsp;��ֱ���:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getHangDetection())%> </td>                      											
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;��������ٽ�ֵ:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getCapacityDepletionThreshold())%> </td>
                    										</tr>
                    										<tr bgcolor="#ECECEC">
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal >&nbsp;�������ٽ�ֵ:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getQueueFullThresholdMaximum())%> </td>                      											
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;�Ż�����:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getEnableOptimizePolicy())%> </td>
                    										</tr>
                    										<tr>
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal >&nbsp;�ֶ�����:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getEnableManualOverride())%> </td>                      											
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;�ֶ�����Ŀ��:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getManualOverrideDestination())%> </td>
                    										</tr>
                    										<tr bgcolor="#ECECEC">
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal >&nbsp;���治�ܶ�:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getReadCacheDisable())%> </td>                      											
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;�ؽ����ȼ�:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getRebuildPriority())%> </td>
                    										</tr>
                    										<tr>
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal >&nbsp;�Ƿ񼤻ȫ����:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getSecurityEnabled())%> </td>                      											
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;�ػ������:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getShutdownCompletion())%> </td>
                    										</tr>
                    										<tr bgcolor="#ECECEC">
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal >&nbsp;��ϵͳ���ͱ��:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getSubsystemTypeID())%> </td>                      											
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;�Ƿ���������ע:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getUnitAttention())%> </td>
                    										</tr>
                    										<tr>
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal >&nbsp;�Ƿ����л���:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getVolumeSetPartition())%> </td>                      											
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;���治��д:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getWriteCacheEnable())%> </td>
                    										</tr>
                    										<tr bgcolor="#ECECEC">
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal >&nbsp;д���:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getWriteWorkingSetInterval())%> </td>                      											
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;�Ƿ���Ԥȡ:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getEnablePrefetch())%> </td>
                    										</tr>
                    										<tr>
                      											<td width="15%" height="26" align="left" nowrap class=txtGlobal >&nbsp;�رյڶ�·������:</td>
                      											<td width="35%"><%=SysUtil.ifNull(subSystemInfo.getDisableSecondaryPathPresentation())%> </td>                      											
                      											<!-- <td width="15%" height="26" align="left" nowrap class=txtGlobal>&nbsp;�Ƿ���Ԥȡ:</td>
                      											<td width="35%"><=subSystemInfo.getEnablePrefetch()%> </td> -->
                    										</tr>                 										                  										
                    										<%
                    										         
                    										      }
                    										 %>                 										
                									</table>
										</td>																		
									</tr> 
									<tr>
									   <td>
										   <table cellpadding="0" cellspacing="0" width=48% align=center>
								              <tr> 
								                <td width="100%" align=center> 								                	
													<script type="text/javascript">
														//var so = new SWFObject("<%=rootPath%>/flex/Area_Input_V.swf?ipadress=<=vo.getIpAddress()%>&table=input&obj1=SRXDYAB&obj2=SRXDYBC&obj3=SRXDYCA&tag=IV", "Area_Input_V", "430", "280", "8", "#ffffff");
														//so.write("flashcontent1");
														//var so = new SWFObject("<%=rootPath%>/flex/common_line.swf?ipadress=<=vo.getIpAddress()%>&title=��ͨ��&tablename=ping<=ip%>&obj1=SRXDYAB&obj2=SRXDYBC&obj3=SRXDYCA&tag=IV", "Area_Input_V", "430", "280", "8", "#ffffff");
														//so.write("flashcontent1");
													    //var so = new SWFObject("<%=rootPath%>/flex/Ping.swf?ipadress=<=vo.getIpAddress()%>", "Ping", "430", "280", "8", "#ffffff");
													    //so.write("flashcontent1");
													</script>				
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
									</table>
									
							</td>						
							<td class="td-container-main-tool" width="15%">
								<jsp:include page="/application/hpstorage/hpstoragetoolbar.jsp">										
								    <jsp:param value="<%=host.getIpAddress()%>" name="ipaddress" />
									<jsp:param value="<%=host.getSysOid()%>" name="sys_oid" />
									<jsp:param value="<%=host.getId()%>" name="tmp" />
									<jsp:param value="storage" name="category" />
									<jsp:param value="hp" name="subtype" />
								</jsp:include>
						   </td>
						</tr>					
					</table>
				</td>
			</tr>
		</table>
	</form>
	</body>
</html>