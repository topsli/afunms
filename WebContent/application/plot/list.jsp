<%@page language="java" contentType="text/html;charset=GB2312"%>
<%@page import="com.afunms.system.model.User"%>
<%@page import="com.afunms.common.base.JspPage"%>
<%@page import="java.util.List"%>
<%@page import="com.afunms.system.util.UserView"%>
<%@ include file="/include/globe.inc"%>
<%@page import="java.util.List"%>
<%@page import="com.afunms.topology.util.NodeHelper"%>
<%@page import="com.afunms.application.model.*"%>
<%@page import="com.afunms.application.dao.*"%>
<%
  String rootPath = request.getContextPath();
  List list = (List)request.getAttribute("list");
    int rc = list.size();
%>
<%String menuTable = (String)request.getAttribute("menuTable");%>
<html>
<head>
<script language="JavaScript" type="text/javascript" src="<%=rootPath%>/include/navbar.js"></script>
<link href="<%=rootPath%>/resource/<%=com.afunms.common.util.CommonAppUtil.getSkinPath() %>css/global/global.css" rel="stylesheet" type="text/css" />

<LINK href="<%=rootPath%>/resource/css/style.css" type="text/css" rel="stylesheet">
<script type="text/javascript" src="<%=rootPath%>/resource/js/page.js"></script> 

<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
<LINK href="<%=rootPath%>/resource/css/itsm_style.css" type="text/css" rel="stylesheet">
<link href="<%=rootPath%>/resource/css/detail.css" rel="stylesheet" type="text/css">
<link rel="stylesheet" href="<%=rootPath%>/resource/css/style.css" type="text/css">
<link href="<%=rootPath%>/include/mainstyle.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/javascript">
  var delAction = "<%=rootPath%>/plot.do?action=delete";
  var listAction = "<%=rootPath%>/plot.do?action=list";

  function toAdd()
  {
     mainForm.action = "<%=rootPath%>/plot.do?action=ready_add";
     mainForm.submit();
  }
  function toDelete()
  {
    if(confirm('是否确定删除这条记录?')) {
     mainForm.action = "<%=rootPath%>/plot.do?action=delete";
     mainForm.submit();
     }
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
	    location.href="<%=rootPath%>/plot.do?action=detail&id="+node;
	}
	function edit()
	{
		location.href="<%=rootPath%>/plot.do?action=ready_edit&id="+node;
	}
	function cancelmanage()
	{
		location.href="<%=rootPath%>/plot.do?action=cancelalert&id="+node;
	}
	function addmanage()
	{
		location.href="<%=rootPath%>/plot.do?action=addalert&id="+node;
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
				onclick="parent.detail();">监视信息</td>
		</tr>
		<tr>
			<td style="cursor: default; border: outset 1;" align="center"
				onclick="parent.cancelmanage()">取消监视</td>
		</tr>
		<tr>
			<td style="cursor: default; border: outset 1;" align="center"
				onclick="parent.addmanage()">添加监视</td>
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
		<td bgcolor="#ffffff" align="center" valign=top>
			<table width="100%" style="BORDER-COLLAPSE: collapse" borderColor=#397DBD cellPadding=0 rules=none align=center border=1 algin="center">
				<tr>
					<td height="28" align="left" bordercolor="#397DBD" bgcolor="#397DBD" class="txtGlobalBold" colspan=3>&nbsp;&nbsp;<font color=#ffffff>应用 >> 服务管理 >> Plot监视列表</font></td>
				</tr>
        						<TR>
        							<TD width="50%">&nbsp;
          							</td>            
								<td width="50%" align='right'>
									<a href="#" onclick="toAdd()">添加</a>
									<a href="#" onclick="toDelete()">删除</a>&nbsp;&nbsp;&nbsp;
		  						</td>                       
        						</tr>				
				
		<tr >
			<td colspan="2">
				<table cellspacing="1" cellpadding="0" width="100%" >
					<tr class="microsoftLook0" height=28>
					<th width='5%' align=left>&nbsp;<INPUT type="checkbox" class=noborder name="checkall" onclick="javascript:chkall()"></th>
    					<th width='5%'>序号</th>
      					<th width='10%'>名称</th>
      					<th width='15%'>IP地址</th>
      					<th width='25%'>总路径</th>
      					<!--<th width='15%'>子路径</th>-->
      					<th width='10%'>文件产生时间间隔</th>
      					<th width='10%'>文件大小阀值（KB）</th>      
      					<th width='10%'>是否监控</th>
    					<th width='10%'>操作</th>
</tr>
<%
if(rc > 0){
    for(int i=0;i<rc;i++)
    {
       PlotConfig vo = (PlotConfig)list.get(i);
       
%>
       <tr bgcolor="DEEBF7" <%=onmouseoverstyle%> class="microsoftLook">
    		<td height=25>&nbsp;<INPUT type="checkbox" class=noborder name=checkbox value="<%=vo.getId()%>"></td>
    		<td height=25>&nbsp;<font color='blue'><%=1 + i%></font></td>
		<td height=25>&nbsp;<%=vo.getName()%></td> 
		<td height=25>&nbsp;<%=vo.getIpaddress()%></td> 
		<td height=25>&nbsp;<%=vo.getSupperdir()%></td> 
		<!--<td height=25>&nbsp;<%=vo.getSubdir()%></td> -->
		<td height=25>&nbsp;<%=vo.getInter()%></td> 
		<td height=25>&nbsp;<%=vo.getFilesize()%></td> 		
		<td height=25>
			<%
				if(vo.getMon_flag() == 0){
			%>
			&nbsp;未监视
			<%
				}else{
			%>	
			&nbsp;已监视
			<%
				}
			%>	
		</td>	
		<td height=25>&nbsp;
		<img src="<%=rootPath%>/resource/image/status.gif" border="0" width=15 oncontextmenu=showMenu('2','<%=vo.getId()%>','<%=vo.getIpaddress()%>')>
		</td>
  	</tr>
<%	}
}

%>				
			</table>
			</td>
		</tr>	
	</table>
</td>
			</tr>
		</table>
</BODY>
</HTML>
