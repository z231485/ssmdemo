<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="shiro" uri="http://shiro.apache.org/tags"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="renderer" content="webkit">
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <link rel="stylesheet" href="${ctx}/static/layui/css/layui.css" media="all">
  <link rel="stylesheet" href="${ctx}/static/css/admin-reset.css" media="all">
</head>
<body class="contPadding">
	<!-- 搜索 -->
	<div class="search">
		<form class="layui-form"> 
		         名称：
			<div class="layui-inline">
				<input class="layui-input" name="conditionName" id="conditionName" autocomplete="off" placeholder="请输入名称">
			</div>
		  	<button class="layui-btn" type="button" onclick="conditionSearch();">搜索</button>
		  	<button class="layui-btn" type="button" onclick="conditionReset();">重置</button>
	  	</form>
	</div>
	<!-- 顶部按钮 -->
	<div class="layui-btn-container tbtn">
	  <button class="layui-btn " onclick="refresh();">刷新列表</button>
	  <button class="layui-btn" onclick="add();">新增</button>
	  <button class="layui-btn layui-btn-danger" onclick="batch_delete();">批量删除</button>
	</div>
	<table class="layui-hide" id="tableId" lay-filter="tableFilter"></table>
	<!-- 右边按钮 -->
	<script type="text/html" id="rbtn">
      <a class="layui-btn layui-btn-xs" lay-event="edit">编辑</a>
      <a class="layui-btn layui-btn-danger layui-btn-xs" lay-event="del">删除</a>
	</script>
	<!-- JS -->
	<script src="${ctx }/static/lib/jquery-1.11.3.min.js"></script>
	<script src="${ctx}/static/layui/layui.js" charset="utf-8"></script>
	<script>
	//加载table模块
	var table,form;
	layui.use(['table','form'], function(){
	  table = layui.table;
	  form = layui.form;
	  //加载表格数据
	  table.render({
	    elem: '#tableId'
	    ,url:'${ctx}/sys_role/toListData'
	    ,cellMinWidth: 80
	    ,page: true
	    ,cols: [[
	      {type:'checkbox'}
	      ,{field:'name', title: '名称'}
	      ,{field:'permissions', title: '标识'}
	      ,{title:'操作',align:'center', toolbar: '#rbtn'}
	    ]]
	  });
	  
	  //监听右边按钮
	  table.on('tool(tableFilter)', function(obj){
	     var data = obj.data //获得当前行数据
	    ,layEvent = obj.event; //获得 lay-event 对应的值
	    if(layEvent === 'del'){
	      doDelete('您确定要删除数据吗？删除后将无法恢复。',data.id);	
	    }
	    if(layEvent === 'edit'){
	      doForm('修改角色',data.id);
	    }
	  });
	  
	});
	
	//刷新页面
	function refresh(){
		var conditionName = $("#conditionName").val();
	    //执行重载
	    table.reload('tableId', {
	  	  where: {
	  		conditionName: conditionName
	      }
	    });
	}
	
	//新增
	function add(){
		doForm('新增角色',0);
	}
	
	//批量删除
	function batch_delete(){
		  var array = new Array();
		  var checkStatus = table.checkStatus('tableId')
	      ,data = checkStatus.data;
		  if(data.length == 0){
			  layer.msg('请选择');
			  return;
		  }
		  for (var i = 0; i < data.length; i++) {
				var obj = data[i];
				array.push(obj.id);
		  }
		  doBatchDelete('您确定要删除选择的数据吗？删除后将无法恢复。',array);
	}
	
	
	
	
	//条件查询
	function conditionSearch(){
		var conditionName = $("#conditionName").val();
	    table.reload('tableId', {
	      page: {
	        curr: 1 //重新从第 1 页开始
	      }
	      ,where: {
	    	  conditionName: conditionName
	      }
	    });
	}
	
	//重置
	function conditionReset(){
		window.location.reload();
	}
	
	//删除
	function doDelete(title,id){
		layer.confirm(title, function(index) {
			$.ajax({
			     url: '${ctx}/sys_role/delete',
			     type:"post",
			     //async:false,
			     dataType:"json",
			     data:{id:id},
			     success: function (result) {
			    	layer.close(index);
			    	layer.msg('删除成功', {
	    			  icon: 6,
	    			  time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
	    			});
    				setTimeout(function(){
    					//重置页面
    					conditionReset();
					}, 1500);
			     },error : function(){
			    	layer.close(index);
	    		    layer.msg('删除失败', {
	    			  icon: 6,
	    			  time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
	    			});
			     }
			});
		});
	}
	
	//批量删除
	function doBatchDelete(title,array){
		layer.confirm(title, function(index) {
			$.ajax({
			     url: '${ctx}/sys_role/batchDelete',
			     type:"post",
			     //async:false,
			     dataType:"json",
			     data:{ids:array},
			     success: function (result) {
			    	layer.close(index);
			    	layer.msg('删除成功', {
	    			  icon: 6,
	    			  time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
	    			});
    				setTimeout(function(){
    					//重置页面
    					conditionReset();
					}, 1500);
			     },error : function(){
			    	layer.close(index);
	    		    layer.msg('删除失败', {
	    			  icon: 6,
	    			  time: 1500 //1.5秒关闭（如果不配置，默认是3秒）
	    			});
			     }
			});
		});
	}
	
	
	
	//form弹出框
	function doForm(title,id){
		layer.open({
			  type: 2,
			  title: title,
			  shade: 0.8,
			  maxmin: true,
			  area: ['80%','80%'],
			  content: '${ctx}/sys_role/toForm?id='+id,
			  btn: ['立即提交'],
			  yes: function(index, layero){ 
				  var nodeName = window["layui-layer-iframe" + index];
				  nodeName.submitForm(index);
			  }
		 });
	}
	
	//details弹出框
	function doDetails(title,id){
		layer.open({
			  type: 2,
			  title: title,
			  shade: 0.8,
			  maxmin: true,
			  area: ['80%','60%'],
			  content: '${ctx}/sys_role/toDetails/'+id
		 });
	}
	
	
	/********************************************************** 转换处理方法 **********************************************/
	function timestampToTime(timestamp){
		if(null == timestamp || timestamp.length == 0){
			return '';
		}
		var date = new Date(timestamp);
		var y = date.getFullYear();    
        var m = date.getMonth()+1;    
        m = m<10?'0'+m:m;    
        var d = date.getDate();    
        d = d<10?("0"+d):d;    
        var h = date.getHours();    
        h = h<10?("0"+h):h;    
        var M = date.getMinutes();    
        M = M<10?("0"+M):M;    
        return y+"-"+m+"-"+d+" "+h+":"+M;
	}
	</script>
</body>
</html>