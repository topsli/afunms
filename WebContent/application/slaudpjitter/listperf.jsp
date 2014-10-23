<%@page language="java" contentType="text/html;charset=GB2312"%>
<%@page import="com.afunms.system.model.User"%>
<%@page import="com.afunms.common.base.JspPage"%>
<%@page import="java.util.*"%>
<%@page import="com.afunms.system.util.UserView"%>
<%@ include file="/include/globe.inc"%>
<%@page import="com.afunms.topology.util.NodeHelper"%>
<%@page import="com.afunms.application.model.*"%>
<%@page import="com.afunms.application.dao.*"%>
<%@page import="com.afunms.polling.base.*"%>
<%@page import="com.afunms.polling.*"%>
<%@page import="com.afunms.polling.om.*"%>
<%@page import="com.afunms.common.util.*"%>
<%
  String rootPath = request.getContextPath();
  List<SlaNodeConfig> list = (List<SlaNodeConfig>)request.getAttribute("list");
  Hashtable telnetHash = (Hashtable)request.getAttribute("telnetHash");
  Hashtable slaHash = ShareData.getSlaHash();
  if(slaHash == null)slaHash = new Hashtable();
  if(telnetHash == null)telnetHash = new Hashtable();
 JspPage jp = (JspPage)request.getAttribute("page");
String menuTable = (String)request.getAttribute("menuTable");
%>
<html>
<head>
<script language="JavaScript" type="text/javascript" src="<%=rootPath%>/include/navbar.js"></script>
<link href="<%=rootPath%>/resource/<%=com.afunms.common.util.CommonAppUtil.getSkinPath() %>css/global/global.css" rel="stylesheet" type="text/css" />

<LINK href="<%=rootPath%>/resource/css/style.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="<%=rootPath%>/resource/js/page.js"></script> 
<meta http-equiv="Page-Enter" content="revealTrans(duration=x, transition=y)">
<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<LINK href="<%=rootPath%>/resource/css/itsm_style.css" type="text/css" rel="stylesheet">
<link href="<%=rootPath%>/resource/css/detail.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=rootPath%>/resource/css/style.css" type="text/css">
<link href="<%=rootPath%>/include/mainstyle.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
  var delAction = "<%=rootPath%>/slaicmp.do?action=delete";
  var listAction = "<%=rootPath%>/slaicmp.do?action=list";
    var curpage= <%=jp.getCurrentPage()%>;
  var totalpages = <%=jp.getPageTotal()%>;

  function toAdd()
  {
     mainForm.action = "<%=rootPath%>/ciscosla.do?action=ready_add";
     mainForm.submit();
  }
  function toDelete()
  {
    if(confirm('是否确定删除这条记录?')) {
     mainForm.action = "<%=rootPath%>/ciscosla.do?action=delete";
     mainForm.submit();
     }
  }  
  function toRefresh()
  {
     mainForm.action = "<%=rootPath%>/ciscosla.do?action=listperf";
     mainForm.submit();
  }  
   function CreateWindow(url){
				msgWindow=window.open(url,"protypeWindow","toolbar=no,width=850,height=450,directories=no,status=no,scrollbars=yes,menubar=no")
	}
  function showRTT(configid){  
  				//alert("=====");
				CreateWindow("<%=rootPath%>/application/sla/net_cpu_month.jsp?id=" +configid);
  }
  function showStatus(configid){  
				CreateWindow("<%=rootPath%>/detail/net_cpu_month.jsp?id=" + 2 + "&ip=" +configid);
  }
</script>
<script language="JavaScript">

	//公共变量
	var node="";
	var ipaddress="";
	var operate="";
	/**
	*根据传入的id显示右键菜单
	*/
	function showMenu(id,nodeid,ip)
	{	
		ipaddress=ip;
		node=nodeid;
		//operate=oper;
	    if("" == id)
	    {
	        popMenu(itemMenu,100,"100");
	    }
	    else
	    {
	        popMenu(itemMenu,100,"1111");
	    }
	    event.returnValue=false;
	    event.cancelBubble=true;
	    return false;
	}
	/**
	*显示弹出菜单
	*menuDiv:右键菜单的内容
	*width:行显示的宽度
	*rowControlString:行控制字符串，0表示不显示，1表示显示，如“101”，则表示第1、3行显示，第2行不显示
	*/
	function popMenu(menuDiv,width,rowControlString)
	{
	    //创建弹出菜单
	    var pop=window.createPopup();
	    //设置弹出菜单的内容
	    pop.document.body.innerHTML=menuDiv.innerHTML;
	    var rowObjs=pop.document.body.all[0].rows;
	    //获得弹出菜单的行数
	    var rowCount=rowObjs.length;
	    //alert("rowCount==>"+rowCount+",rowControlString==>"+rowControlString);
	    //循环设置每行的属性
	    for(var i=0;i<rowObjs.length;i++)
	    {
	        //如果设置该行不显示，则行数减一
	        var hide=rowControlString.charAt(i)!='1';
	        if(hide){
	            rowCount--;
	        }
	        //设置是否显示该行
	        rowObjs[i].style.display=(hide)?"none":"";
	        //设置鼠标滑入该行时的效果
	        rowObjs[i].cells[0].onmouseover=function()
	        {
	            this.style.background="#397DBD";
	            this.style.color="white";
	        }
	        //设置鼠标滑出该行时的效果
	        rowObjs[i].cells[0].onmouseout=function(){
	            this.style.background="#F1F1F1";
	            this.style.color="black";
	        }
	    }
	    //屏蔽菜单的菜单
	    pop.document.oncontextmenu=function()
	    {
	            return false; 
	    }
	    //选择右键菜单的一项后，菜单隐藏
	    pop.document.onclick=function()
	    {
	        pop.hide();
	    }
	    //显示菜单
	    pop.show(event.clientX-1,event.clientY,width,rowCount*25,document.body);
	    return true;
	}
	function detail()
	{
	    location.href="<%=rootPath%>/FTP.do?action=detail&id="+node;
	}
	function edit()
	{
		location.href="<%=rootPath%>/ciscosla.do?action=ready_edit&id="+node;
	}
	function cancelmanage()
	{
		location.href="<%=rootPath%>/FTP.do?action=changeMonflag&value=0&id="+node;
	}
	function reboot()
	{
		location.href="<%=rootPath%>/ciscosla.do?action=detail&id="+node;
	}
	function shutdown()
	{
		location.href="<%=rootPath%>/serverUpAndDown.do?action=shutdown&value=1&id="+node;
	}
	function clickMenu()
	{
	}
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

}

</script>
</head>
<BODY leftmargin="0" topmargin="0" bgcolor="#cedefa" onload="initmenu();">

<!-- 这里用来定义需要显示的右键菜单 -->
	<div id="itemMenu" style="display: none";>
	<table border="1" width="100%" height="100%" bgcolor="#F1F1F1"
		style="border: thin;font-size: 12px" cellspacing="0">
		<tr>
			<td style="cursor: default; border: outset 1;" align="center"
				onclick="parent.edit()">修改信息</td>
		</tr>
		<tr>
			<td style="cursor: default; border: outset 1;" align="center"
				onclick="parent.reboot()">性能信息</td>
		</tr>
		<tr>
			<td style="cursor: default; border: outset 1;" align="center"
				onclick="parent.shutdown()">关闭服务器</td>
		</tr>		
	
	</table>
	</div>
	<!-- 右键菜单结束-->
<form method="post" name="mainForm">
<table id="body-container" class="body-container">
	<tr>
		<td width="200" valign=top align=center>
			<%=menuTable%>
		
		</td>
            <td align="center" valign=top>
			<table style="width:98%"  cellpadding="0" cellspacing="0" algin="center">
			<tr>
				<td background="<%=rootPath%>/common/images/right_t_02.jpg" width="100%"><table width="100%" cellspacing="0" cellpadding="0">
                  <tr>
                    <td align="left"><img src="<%=rootPath%>/common/images/right_t_01.jpg" width="5" height="29" /></td>
                    <td class="content-title">服务质量 >> UDPP端到端抖动 >> UDP抖动监视列表</td>
                    <td align="right"><img src="<%=rootPath%>/common/images/right_t_03.jpg" width="5" height="29" /></td>
                  </tr>
              </table>
			  </td>
        						<tr>           
								<td>
								<table width="100%" cellpadding="0" cellspacing="1" >
        			<tr>
					            <td bgcolor="#ECECEC" width="100%" align='right'>
									<a href="#" onclick="toAdd()">添加</a>
									<a href="#" onclick="toDelete()">删除</a>
									<a href="#" onclick="toRefresh()">刷新</a>
									&nbsp;&nbsp;&nbsp;
		  						</td>
									</tr>
        								</table>
										</td>
        						</tr>						
		        									<tr>
														<td>
															<table>
																<tr>
													    			<td  class="body-data-title">
							    										<jsp:include page="../../common/page.jsp">
																			<jsp:param name="curpage" value="<%=jp.getCurrentPage()%>" />
																			<jsp:param name="pagetotal" value="<%=jp.getPageTotal()%>" />
																		</jsp:include>
							        								</td>
							        							</tr>
															</table>
														</td>
													</tr>				
		<tr >
			<td colspan="2">
				<table cellspacing="1" cellpadding="0" width="100%" >
					<tr class="microsoftLook0" height=28>
					<th width='6%' align=left>&nbsp;<INPUT type="checkbox" class=noborder name="checkall" onclick="javascript:chkall()">序号</th>
    					<th width='10%'>名称</th>
      					<th width='8%'>源地址</th>
      					<th width='8%'>目标地址</th>	
      					<th width='6%'>当前RTT(ms)</th>
      					<th width='6%'>丢包率(%)</th>
      					<th width='6%'>SD最大正抖动(ms)</th>      					
      					<th width='6%'>DS最大正抖动(ms)</th>
      					<th width='6%'>SD平均正抖动(ms)</th>
      					<th width='6%'>DS平均正抖动(ms)</th>
      					<th width='6%'>SD最大负抖动(ms)</th>      					
      					<th width='6%'>DS最大负抖动(ms)</th>
      					<th width='6%'>SD平均负抖动(ms)</th>
      					<th width='6%'>DS平均负抖动(ms)</th>
    					<th width='5%'>操作</th>
</tr>
<%
	if(list != null && list.size()>0){
			String monstr = "否";
			Hashtable dataHash = new Hashtable();
    									String Min_positive_SD = "";
    									String Min_positive_DS = "";
    									String Max_positive_SD = "";
    									String Max_positive_DS = "";
    									String Positive_SD_number = "";
    									String Positive_DS_number = "";
    									String Positive_SD_sum = "";
    									String Positive_DS_sum = "";
    									String Positive_SD_average = "";
    									String Positive_DS_average = "";
    									String Max_negative_SD = "";
    									String Max_negative_DS = "";
    									String Negative_SD_number = "";
    									String Negative_DS_number = "";
    									String Negative_SD_sum = "";
    									String Negative_DS_sum = "";
    									String Negative_SD_average = "";
    									String Negative_DS_average = "";
    												
    		for(int i=0;i<list.size();i++){
    				String imgpath = "";
    				String rrtValue = "-";
    				String statusValue = "0";
    				
     									Min_positive_SD = "-";
    									Min_positive_DS = "-";
    									Max_positive_SD = "-";
    									Max_positive_DS = "-";
    									Positive_SD_number = "-";
    									Positive_DS_number = "-";
    									Positive_SD_sum = "-";
    									Positive_DS_sum = "-";
    									Positive_SD_average = "-";
    									Positive_DS_average = "-";
    									Max_negative_SD = "-";
    									Max_negative_DS = "-";
    									Negative_SD_number = "-";
    									Negative_DS_number = "-";
    									Negative_SD_sum = "-";
    									Negative_DS_sum = "-";
    									Negative_SD_average = "-";
    									Negative_DS_average = "-";   				
    				
    				dataHash = new Hashtable();
       				SlaNodeConfig vo = list.get(i);
       				String sourceIp = "";
       				if(telnetHash.containsKey(vo.getTelnetconfig_id()))sourceIp =(String) telnetHash.get(vo.getTelnetconfig_id());
       				if(slaHash.containsKey(vo.getId()+"")){
       					dataHash = (Hashtable)slaHash.get(vo.getId()+"");
       					Pingcollectdata rttdata =  (Pingcollectdata)dataHash.get("rtt");
       					Pingcollectdata packdata =  (Pingcollectdata)dataHash.get("pack");
       				   if(rttdata != null)rrtValue = rttdata.getThevalue();
       				   if(packdata != null)statusValue = packdata.getThevalue();
       				   Vector jitterV = (Vector)dataHash.get("jitter");
						if(jitterV != null && jitterV.size()>0){
							for(int k=0;k<jitterV.size();k++){
								Pingcollectdata jitterdata = (Pingcollectdata)jitterV.get(k);
								if("Min_positive_SD".equalsIgnoreCase(jitterdata.getCategory()))Min_positive_SD = jitterdata.getThevalue();
								if("Min_positive_DS".equalsIgnoreCase(jitterdata.getCategory()))Min_positive_DS = jitterdata.getThevalue();
								if("Max_positive_SD".equalsIgnoreCase(jitterdata.getCategory()))Max_positive_SD = jitterdata.getThevalue();
								if("Max_positive_DS".equalsIgnoreCase(jitterdata.getCategory()))Max_positive_DS = jitterdata.getThevalue();
								if("Positive_SD_average".equalsIgnoreCase(jitterdata.getCategory()))Positive_SD_average = jitterdata.getThevalue();
								if("Positive_DS_average".equalsIgnoreCase(jitterdata.getCategory()))Positive_DS_average = jitterdata.getThevalue();
								if("Max_negative_SD".equalsIgnoreCase(jitterdata.getCategory()))Max_negative_SD = jitterdata.getThevalue();
								if("Max_negative_DS".equalsIgnoreCase(jitterdata.getCategory()))Max_negative_DS = jitterdata.getThevalue();
								if("Negative_SD_average".equalsIgnoreCase(jitterdata.getCategory()))Negative_SD_average = jitterdata.getThevalue();
								if("Negative_DS_average".equalsIgnoreCase(jitterdata.getCategory()))Negative_DS_average = jitterdata.getThevalue();
							}
						}
       
%>
       <tr bgcolor="#FFFFFF" <%=onmouseoverstyle%> class="microsoftLook">
    	<td height=25>&nbsp;<INPUT type="checkbox" class=noborder name=checkbox value="<%=vo.getId()%>">&nbsp;<%=1 + i%></td>
		<td height=25>&nbsp;<%=vo.getName()%></td> 
		<td height=25>&nbsp;<%=sourceIp%></td>
		<td height=25>&nbsp;<%=vo.getDestip()%></td>
		<td height=25 align=center>&nbsp;<%=rrtValue%>&nbsp;<img src="<%=rootPath%>/resource/image/a_xn.gif" onclick='showRTT("<%=vo .getId()%>")' width=15></td> 
		<td height=25 align=center>&nbsp;<%=statusValue%>&nbsp;<img src="<%=rootPath%>/resource/image/a_xn.gif" onclick='showRTT("<%=vo .getId()%>")' width=15></td>
		<td height=25 align=center>&nbsp;<%=Max_positive_SD%>&nbsp;<img src="<%=rootPath%>/resource/image/a_xn.gif" onclick='showRTT("<%=vo .getId()%>")' width=15></td>
		<td height=25 align=center>&nbsp;<%=Max_positive_DS%>&nbsp;<img src="<%=rootPath%>/resource/image/a_xn.gif" onclick='showRTT("<%=vo .getId()%>")' width=15></td>
		<td height=25 align=center>
			<%=Positive_SD_average%>
		</td>
		<td height=25 align=center>
			<%=Positive_DS_average%>
		</td>
		<td height=25 align=center>
			<%=Max_negative_SD%>
		</td>
		<td height=25 align=center>
			<%=Max_negative_DS%>
		</td>
		<td height=25 align=center>
			<%=Negative_SD_average%>
		</td>
		<td height=25 align=center>
			<%=Negative_DS_average%>
		</td>		
		<td height=25 align=center>&nbsp;
		<img src="<%=rootPath%>/resource/image/status.gif" border="0" width=15 oncontextmenu=showMenu('2','<%=vo.getId()%>','<%=vo.getName()%>') alt="右键操作">
		</td>
  	</tr>

<%	
		}else{
%>
       <tr bgcolor="#FFFFFF" <%=onmouseoverstyle%> class="microsoftLook">
    	<td height=25>&nbsp;<INPUT type="checkbox" class=noborder name=checkbox value="<%=vo.getId()%>">&nbsp;<%=1 + i%></td>
		<td height=25>&nbsp;<%=vo.getName()%></td> 
		<td height=25>&nbsp;<%=sourceIp%></td>
		<td height=25>&nbsp;<%=vo.getDestip()%></td>
		<td height=25 align=center>&nbsp;--&nbsp;<img src="<%=rootPath%>/resource/image/a_xn.gif" onclick='showRTT("<%=vo .getId()%>")' width=15></td>
		 <td height=25 align=center>&nbsp;--&nbsp;<img src="<%=rootPath%>/resource/image/a_xn.gif" onclick='showRTT("<%=vo .getId()%>")' width=15></td>
		 <td height=25 align=center>&nbsp;--&nbsp;<img src="<%=rootPath%>/resource/image/a_xn.gif" onclick='showRTT("<%=vo .getId()%>")' width=15></td>
		 <td height=25 align=center>&nbsp;--&nbsp;<img src="<%=rootPath%>/resource/image/a_xn.gif" onclick='showRTT("<%=vo .getId()%>")' width=15></td>
		<td height=25 align=center>
		--
		</td>
				<td height=25 align=center>
		--
		</td>
				<td height=25 align=center>
		--
		</td>
		<td height=25 align=center>
			--
		</td>
		<td height=25 align=center>
			--
		</td>
		<td height=25 align=center>
			--
		</td>		
		<td height=25 align=center>&nbsp;
		<img src="<%=rootPath%>/resource/image/status.gif" border="0" width=15 oncontextmenu=showMenu('2','<%=vo.getId()%>','<%=vo.getName()%>') alt="右键操作">
		</td>
  	</tr>

<%
		}
}
}
%>				
			</table>
			</td>
		</tr>
		<tr>
              <td background="<%=rootPath%>/common/images/right_b_02.jpg" >
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                  <tr>
                    <td align="left" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_01.jpg" width="5" height="12" /></td>
                    <td align="right" valign="bottom"><img src="<%=rootPath%>/common/images/right_b_03.jpg" width="5" height="12" /></td>
                  </tr>
              </table></td>
            </tr>
	</table>
</td>
			</tr>
		</table>
</BODY>
</HTML>
