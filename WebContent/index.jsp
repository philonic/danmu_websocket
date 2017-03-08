<%@ page contentType="text/html; charset=utf-8" language="java"  import="java.util.*"%>

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE html>
<html lang="en">
<head>
	<link rel="shortcut icon" href="favicon.ico"/>
	<link rel="bookmark" href="favicon.ico"/>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title> 弹幕 聊天室</title>
    <link rel="stylesheet" type="text/css" href="static/css/bootstrap.min.css" media="screen"/>
    <link rel="stylesheet" type="text/css" href="static/css/style.css"/>
    <link rel="stylesheet" type="text/css" href="static/css/barrager.css">
    <link rel="stylesheet" type="text/css" href="static/pick-a-color/css/pick-a-color-1.2.3.min.css">
    <link type="text/css" rel="stylesheet" href="static/syntaxhighlighter/styles/shCoreDefault.css"/>

</head>
<body class="bb-js">
<%
            String ip = request.getHeader("x-forwarded-for");
            if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)){
                ip = request.getHeader("Proxy-Client-IP");
            }
            if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)){
                ip = request.getHeader("WL-Proxy-Client-IP");
            }
            if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)){
                ip = request.getRemoteAddr();
            }
        %>
          <input id="IPAdr" name="IPAdr" value='<%=ip%>' type="hidden"> 
<!--左边大框-->
<div class="zp-leftbox">
    <div class="zp-item">
        <div id="id_video_container_9896587163582325370" style="width:100%;height:1px;"></div>
        <script src="http://qzonestyle.gtimg.cn/open/qcloud/video/live/h5/live_connect.js" charset="utf-8"></script>
        <script type="text/javascript">
            (function(){
                var option ={"channel_id":"9896587163582325370","app_id":"1251022106","width":"1024","height":"580"};
                new qcVideo.Player(
                        /*代码中的id_video_container将会作为播放器放置的容器使用,可自行替换*/
                        "id_video_container_9896587163582325370",
                        option
                );
            })()
        </script>
    </div>
</div>
<!--右边大框，评论-->
<div class="zp-rightbox">
    <div class="zp-item">
	
	<script type="text/javascript">
            (function(){
                var option ={"channel_id":"9896587163582325370","app_id":"1251022106","width":"1024","height":"580"};
                new qcVideo.Player(
                        /*代码中的id_video_container将会作为播放器放置的容器使用,可自行替换*/
                        "id_video_container_9896587163582325370",
                        option
                );
            })()
    </script>
            <span>
                <i>李勇:</i><u>的手机卡登记会计阿打算打的卡口肯定卡手机打开考虑的萨拉的大硕大的</u><em>12:01</em>
                <div class="sjx"></div>
            </span>
             <span>
                <i>李勇:</i><u>的手机卡登记会计阿打算</u><em>12:01</em>
                <div class="sjx"></div>
            </span>
    
    </div>
    <div class="container">
        <section class="bb-section">
            <div class="lead-top">

                <div class="text-center">

                    <p class="zp-cols">

                        <input type="text" id="text" class="enter">
                        <button  class="bb-trigger btn btn-primary btn-sm bb-light-blue" onclick="send();"> 发送</button>
                    </p>
                </div>
            </div>
        </section>
    </div>
</div>
<div class="clearfix"></div>


<!-- JS dependencies -->
<script type="text/javascript" src="static/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="static/js/bootstrap.min.js"></script>
<script type="text/javascript" src="static/js/tinycolor-0.9.15.min.js"></script>
<script type="text/javascript" src="static/js/jquery.barrager.js"></script>
<script type="text/javascript" src="static/syntaxhighlighter/scripts/shCore.js"></script>
<script type="text/javascript" src="static/syntaxhighlighter/scripts/shBrushJScript.js"></script>
<script type="text/javascript" src="static/syntaxhighlighter/scripts/shBrushPhp.js"></script>
<script type="text/javascript" src="static/pick-a-color/js/pick-a-color-1.2.3.min.js"></script>
<script>
    var wsServer = 'ws://localhost:8080/danmu_websocket/websocket';
    //调用websocket对象建立连接：
    //参数：ws/wss(加密)：//ip:port （字符串）
    var websocket = new WebSocket(wsServer);
    //onopen监听连接打开
    websocket.onopen = function (evt) {
        //websocket.readyState 属性：
        /*
         CONNECTING    0    The connection is not yet open.
         OPEN    1    The connection is open and ready to communicate.
         CLOSING    2    The connection is in the process of closing.
         CLOSED    3    The connection is closed or couldn't be opened.
         */
        // msg.innerHTML = websocket.readyState;
    };

    $('.enter').keyup(function(e){
        if(e.keyCode == 13){
            send();
        }
    });

    function send(){
        var text = $('.enter').val();

        if(text.length==0){
            layer.msg('内容不得为空!');
            return false;
        }else{
            //向服务器发送数据
            text = $('#IPAdr').val()+":"+text;
            websocket.send(text);
            $('.enter').val('');
            $('.enter').focus();
        }
    }
    //监听连接关闭
    websocket.onclose = function (evt) {
        layer.msg("弹幕服务已被临时关闭!! ");
    };

    //onmessage 监听服务器数据推送
    websocket.onmessage = function (evt) {
        console.log(evt.data);
        var jsondata = $.parseJSON(evt.data.toString());
		
        if(jsondata.status==0){
            alert("休息一下吧~~~");
        }else{
            $('.zp-leftbox').barrager(jsondata);
        }
        //console.log('Retrieved data from server: ' + evt.data);
    };
    //监听连接错误信息
    websocket.onerror = function (evt, e) {
        layer.msg('Error occured: ' + evt.data);
        // layer.msg("弹幕服务已被临时关闭!! ");
    };

</script>
</body>
</html>