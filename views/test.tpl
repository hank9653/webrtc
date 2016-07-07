<!DOCTYPE html>
<!--
 *  Copyright (c) 2014 The WebRTC project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a BSD-style license
 *  that can be found in the LICENSE file in the root of the source
 *  tree.
-->
<html>
<head>

  <meta charset="utf-8">
  <meta name="description" content="WebRTC reference app">
  <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1, maximum-scale=1">
  <meta itemprop="description" content="Video chat using the reference WebRTC application">
  <meta itemprop="image" content="/images/webrtc-icon-192x192.png">
  <meta itemprop="name" content="AppRTC">
  <meta name="mobile-web-app-capable" content="yes">
  <meta id="theme-color" name="theme-color" content="#ffffff">

  <base target="_blank">

  <title>webRTC</title>

  <link rel="manifest" href="manifest.json">
  <link rel="icon" sizes="192x192" href="images/webrtc-icon-192x192.png">
  <link rel="stylesheet" href="static/css/main.css">
  <script src="//ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js"></script>

  <script src="//cdn.webrtc-experiment.com/firebase.js"></script>
  <script src="static/js/RTCMultiConnection.js"></script>

</head>

<body>
  <!--
   * Keep the HTML id attributes in sync with |UI_CONSTANTS| defined in
   * appcontroller.js.
  -->
  <div id="videos">
    <video id="remote-video" autoplay></video>
    <div class="css_table">
      <div class="css_tr">
      </div>
    </div>
    <video id="local-video" autoplay muted></video>
  </div>

  <div id="room-selection" class="">
    <h1>webRTC</h1>
    <p id="instructions">Please enter a room name.</p>
    <div>
      <div id="room-id-input-div">
        <input type="text" id="room-id-input" autofocus/>
        <label class="error-label hidden" for="room-id-input" id="room-id-input-label">Room name must be 5 or more characters and include only letters and numbers.</label>
      </div>
      <div id="room-id-input-buttons">
        <button id="join-button">JOIN</button>
        <button id="random-button">RANDOM</button>
      </div>
    </div>
  </div>

  <div id="confirm-open-div" class="hidden">
    <div>Open the room<span id="confirm-open-room-span"></span>?</div>
    <button id="confirm-open-button">OPEN</button>
  </div>

  <div id="confirm-join-div" class="hidden">
    <div>Ready to join<span id="confirm-join-room-span"></span>?</div>
    <button id="confirm-join-button">JOIN</button>
  </div>

  <footer>
    <div id="sharing-div">
      <div id="room-link">Waiting for someone to join this room: <a id="room-link-href" href="{{.room_link }}" target="_blank"></a></div>
    </div>
    <div id="info-div">Code for AppRTC is available from <a href="http://github.com/webrtc/apprtc" title="GitHub repo for AppRTC">github.com/webrtc/apprtc</a></div>
    <div id="status-div"></div>
    <div id="rejoin-div" class=""><span>You have left the call.</span> <button id="rejoin-button">REJOIN</button><button id="new-room-button">NEW ROOM</button></div>
  </footer>

  <div id="icons" class="">

    <svg id="mute-audio" xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewbox="-10 -10 68 68">
    <title>title</title>
      <circle cx="24" cy="24" r="34">
        <title>Mute audio</title>
      </circle>
      <path class="on" transform="scale(0.6), translate(17,18)" d="M38 22h-3.4c0 1.49-.31 2.87-.87 4.1l2.46 2.46C37.33 26.61 38 24.38 38 22zm-8.03.33c0-.11.03-.22.03-.33V10c0-3.32-2.69-6-6-6s-6 2.68-6 6v.37l11.97 11.96zM8.55 6L6 8.55l12.02 12.02v1.44c0 3.31 2.67 6 5.98 6 .45 0 .88-.06 1.3-.15l3.32 3.32c-1.43.66-3 1.03-4.62 1.03-5.52 0-10.6-4.2-10.6-10.2H10c0 6.83 5.44 12.47 12 13.44V42h4v-6.56c1.81-.27 3.53-.9 5.08-1.81L39.45 42 42 39.46 8.55 6z" fill="white"/>
      <path class="off" transform="scale(0.6), translate(17,18)"  d="M24 28c3.31 0 5.98-2.69 5.98-6L30 10c0-3.32-2.68-6-6-6-3.31 0-6 2.68-6 6v12c0 3.31 2.69 6 6 6zm10.6-6c0 6-5.07 10.2-10.6 10.2-5.52 0-10.6-4.2-10.6-10.2H10c0 6.83 5.44 12.47 12 13.44V42h4v-6.56c6.56-.97 12-6.61 12-13.44h-3.4z"  fill="white"/>
    </svg>

    <svg id="mute-video" xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewbox="-10 -10 68 68">
      <circle cx="24" cy="24" r="34">
        <title>Mute video</title>
      </circle>
      <path class="on" transform="scale(0.6), translate(17,16)" d="M40 8H15.64l8 8H28v4.36l1.13 1.13L36 16v12.36l7.97 7.97L44 36V12c0-2.21-1.79-4-4-4zM4.55 2L2 4.55l4.01 4.01C4.81 9.24 4 10.52 4 12v24c0 2.21 1.79 4 4 4h29.45l4 4L44 41.46 4.55 2zM12 16h1.45L28 30.55V32H12V16z" fill="white"/>
      <path class="off" transform="scale(0.6), translate(17,16)" d="M40 8H8c-2.21 0-4 1.79-4 4v24c0 2.21 1.79 4 4 4h32c2.21 0 4-1.79 4-4V12c0-2.21-1.79-4-4-4zm-4 24l-8-6.4V32H12V16h16v6.4l8-6.4v16z" fill="white"/>
    </svg>

    <svg id="share-screen" class="hidden" xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="-10 -10 68 68">
      <circle cx="24" cy="24" r="34">
        <title>Share screen</title>
      </circle>
      <path transform="scale(0.2), translate(-35,-1)" d="M181.014,144.296c-7.351,0-13.898,3.492-18.081,8.899l-21.591-11.066c2.213-3.518,3.498-7.675,3.498-12.129   s-1.285-8.611-3.498-12.129l21.591-11.066c4.183,5.408,10.73,8.899,18.081,8.899c12.602,0,22.854-10.251,22.854-22.852   c0-12.601-10.252-22.853-22.854-22.853c-12.602,0-22.854,10.252-22.854,22.853c0,1.678,0.187,3.313,0.532,4.889l-24.843,12.733   c-3.46-2.11-7.522-3.327-11.863-3.327c-12.601,0-22.854,10.251-22.854,22.853s10.252,22.852,22.854,22.852   c4.341,0,8.402-1.217,11.863-3.327l24.843,12.733c-0.345,1.576-0.532,3.21-0.532,4.889c0,12.601,10.252,22.852,22.854,22.852   c12.602,0,22.854-10.251,22.854-22.852C203.867,154.547,193.615,144.296,181.014,144.296z" fill="white"/>
    </svg>

    <svg id="fullscreen" xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewbox="-10 -10 68 68">
      <circle cx="24" cy="24" r="34">
        <title>Enter fullscreen</title>
      </circle>
      <path class="on" transform="scale(0.8), translate(7,6)" d="M10 32h6v6h4V28H10v4zm6-16h-6v4h10V10h-4v6zm12 22h4v-6h6v-4H28v10zm4-22v-6h-4v10h10v-4h-6z" fill="white"/>
      <path class="off" transform="scale(0.8), translate(7,6)"  d="M14 28h-4v10h10v-4h-6v-6zm-4-8h4v-6h6v-4H10v10zm24 14h-6v4h10V28h-4v6zm-6-24v4h6v6h4V10H28z" fill="white"/>
    </svg>

    <svg id="hangup" class="hidden" xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewbox="-10 -10 68 68">
      <circle cx="24" cy="24" r="34">
        <title>Hangup</title>
      </circle>
      <path transform="scale(0.7), translate(11,10)" d="M24 18c-3.21 0-6.3.5-9.2 1.44v6.21c0 .79-.46 1.47-1.12 1.8-1.95.98-3.74 2.23-5.33 3.7-.36.35-.85.57-1.4.57-.55 0-1.05-.22-1.41-.59L.59 26.18c-.37-.37-.59-.87-.59-1.42 0-.55.22-1.05.59-1.42C6.68 17.55 14.93 14 24 14s17.32 3.55 23.41 9.34c.37.36.59.87.59 1.42 0 .55-.22 1.05-.59 1.41l-4.95 4.95c-.36.36-.86.59-1.41.59-.54 0-1.04-.22-1.4-.57-1.59-1.47-3.38-2.72-5.33-3.7-.66-.33-1.12-1.01-1.12-1.8v-6.21C30.3 18.5 27.21 18 24 18z" fill="white"/>
    </svg>
    

  </div>
  <script>
    var meet_number=0;
    var streams=[];
    var stream_blob=[];
    var screen_streamid;
    var connection = new RTCMultiConnection();
    connection.session = {
      audio : true,
      video : true,
      data : true
    };

    connection.mediaConstraints.mandatory = {
        minWidth: 1080,
        maxWidth: 1080,
        minHeight: 720,
        maxHeight: 720,
        minFrameRate: 30
    };


    $('#mute-audio').click(function(){
      if($('#mute-audio').attr('class')=='on'){
        connection.streams.unmute({
            audio: true,
            type: 'local'
        });
        $('#mute-audio').attr('class',' ');
        console.log($('#mini-video').attr('streamid')+" streamid's audio is mute.");

      }else{
        connection.streams.mute({
            audio: true,
            type: 'local'
        });
        $('#mute-audio').attr('class','on');
        console.log($('#mini-video').attr('streamid')+" streamid's audio is unmute.");
      }
        
    });

    $('#mute-video').click(function(){
        if($('#mute-video').attr('class')=='on'){
        connection.streams.unmute({
            video: true
        });
        $('#mute-video').attr('class',' ');
        console.log($('#mini-video').attr('streamid')+" streamid's video is mute.");

      }else{
        connection.streams.mute({
            video: true
        });
        $('#mute-video').attr('class','on');
        console.log($('#mini-video').attr('streamid')+" streamid's video is unmute.");
      }
    });

    $('#share-screen').click(function(){
      if($('#share-screen').attr('class')=='on'){
        connection.removeStream(screen_streamid);
        console.log(connection);
        connection.send(screen_streamid);
        $('#share-screen').attr('class',' ');
        console.log(screen_streamid+" streamid's screen is false.");
        if(screen_streamid!=null){
          var index = streams.lastIndexOf(screen_streamid);
          streams.splice(index,1); 
          stream_blob.splice(index,1); 
        }

      }else{
        connection.addStream({
            screen: true,
            oneway: true
        });
        $('#share-screen').attr('class','on');
        console.log($('#share-screen').attr('streamid')+" streamid's screen is true.");
      }
    });

    $('#fullscreen').click(function(){
        if($('#fullscreen').attr('class')=='on'){
          if (document.exitFullscreen) {
            document.exitFullscreen();
          } else if (document.msExitFullscreen) {
            document.msExitFullscreen();
          } else if (document.mozCancelFullScreen) {
            document.mozCancelFullScreen();
          } else if (document.webkitExitFullscreen) {
            document.webkitExitFullscreen();
          }
          $('#fullscreen').attr('class',' ');
        }else{
          $('#fullscreen').attr('class','on');
          var elem = document.documentElement;
          if (elem.requestFullscreen) {
            elem.requestFullscreen();
          } else if (elem.msRequestFullscreen) {
            elem.msRequestFullscreen();
          } else if (elem.mozRequestFullScreen) {
            elem.mozRequestFullScreen();
          } else if (elem.webkitRequestFullscreen) {
            elem.webkitRequestFullscreen();
          }
        }
    });


    $('#hangup').click(function(){
        connection.close();
        window.open('', '_self', ''); //bug fix
        window.close();
    });
    connection.onSessionClosed = function(e) {
        // entire session is closed
        //alert("onSessionClosed");
        connection.close();
        window.open('', '_self', ''); //bug fix
        window.close();
    };


    

    connection.onstream = function(e) {

     // e.mediaElement.width = 600;
      //console.log(e.streamid);
      //rotateVideo(e.mediaElement);
      $('#videos').attr('class', 'active');
      //螢幕分享全設置為type=remote
      if (e.type == 'remote' || e.stream.isScreen == true) {
        //console.log(e.blobURL);
        streams.push(e.streamid);
        stream_blob.push(e.blobURL);
        if(e.stream.isScreen == true && e.type == 'local' ){
          screen_streamid=e.streamid;
        }
        init_remote_user(e);
      
      } else {
        init_local_user(e);
      }

      $( document ).ready(function() {
          $('#remote-video').mouseover(function(){
            $('#icons').attr('class','active');
          })
          .mouseout(function(){
            $('#icons').attr('class','hidden');
          });

          $('#icons').mouseover(function(){
            $('#icons').attr('class','active');
          })
          .mouseout(function(){
            $('#icons').attr('class','hidden');
          });
          
      });
      console.log("進來畫面的資訊"); 
      console.log(e);
    };

  
    connection.onstreamended = function(e) {
      e.mediaElement.style.opacity = 0;
      alert("onstreamended");
      setTimeout(function() {
        if (e.mediaElement.parentNode) {
          e.mediaElement.parentNode.removeChild(e.mediaElement);
        }
      }, 1000);
    };

    connection.onleave = function(e) {
       console.log(e);
       readjust(e);
      /*setTimeout(function() {
        if (e.mediaElement.parentNode) {
          e.mediaElement.parentNode.removeChild(e.mediaElement);
        }
      }, 1000);*/
    };

    connection.onmessage = function(e) {
            console.log(e.userid+"  "+e.data);
            console.log('latency:', e.latency, ' ms');
            readjust1(e);
    };

    connection.onremovestream = function(e) {
       alert("被移除囉");
       readjust(e);
      /*setTimeout(function() {
        if (e.mediaElement.parentNode) {
          e.mediaElement.parentNode.removeChild(e.mediaElement);
        }
      }, 1000);*/
    };

    connection.onclose = function(e) {
       //console.log(e);
       ////removeA(streamid, e.streamid);
       ////removeA(stream_blob, e.blobURL);
      // alert('streamid : '+e.streamid);
      // console.log(e);
      //readjust();
      /*setTimeout(function() {
        if (e.mediaElement.parentNode) {
          e.mediaElement.parentNode.removeChild(e.mediaElement);
        }
      }, 1000);*/
    };

    

    var sessions = { };
    connection.onNewSession = function(session) {
      if (sessions[session.sessionid]) {
        console.log("session1");
        console.log(session);
        alert("HI");
        return;
      }
      sessions[session.sessionid] = session;
      console.log("session2");
      console.log(session);

      /*$('#confirm-join-div').attr('class', ' ');

      var joinRoomButton = document.getElementById('confirm-join-button');
      $('#confirm-join-button').attr('data-sessionid', session.sessionid);
      joinRoomButton.onclick = function() {
        $('#confirm-open-div').attr('class', 'hidden');
        $('#confirm-join-div').attr('class', 'hidden');
        $('#room-selection').attr('class', 'hidden');
        var sessionid = this.getAttribute('data-sessionid');
        session = sessions[sessionid];

        if (!session)
          throw 'No such session exists.';

        connection.join(session);
      };*/
      $('#confirm-open-div').attr('class', 'hidden');
        $('#confirm-join-div').attr('class', 'hidden');
        $('#room-selection').attr('class', 'hidden');
        var sessionid = session.sessionid;
        session = sessions[sessionid];

        if (!session)
          throw 'No such session exists.';

        connection.join(session);
    };



    if (location.hash.length > 1) {
      console.log('有房間');
      $('#room-selection').attr('class', 'hidden');
      $('#room-id-input').val();
      navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia;
      var constraints = {audio: true, video: true};
      navigator.getUserMedia(constraints, successCallback, errorCallback);


      $('#confirm-open-div').attr('class',' ');
      var openRoomButton = document.getElementById('confirm-open-button');
      openRoomButton.onclick = function() {
        $('#confirm-open-div').attr('class', 'hidden');
        $('#confirm-join-div').attr('class', 'hidden');
        $('#room-selection').attr('class', 'hidden');
        $('#room-id-input').val();
        var href_hash = $('#room-id-input').val() || ' ';
        //alert('href_hash:'+href_hash);
        document.location.href = location.href + href_hash;
        //不加房號會出錯
        connection.extra = {
          'session-name' : location.hash || "location.hash"
        };
        connection.channel = location.href.replace(/\/|:|#|\?|\$|\^|%|\.|`|~|!|@|\[|\||]|\|*. /g, '').split('\n').join('').split('\r').join('');
              // setup signaling to search existing sessions
        connection.connect();
        //alert(connection.channel);
        connection.open();
      };


      // setup signaling to search existing sessions
      connection.connect();
    } else {
      console.log('無房間');
    }




    
      var room_link = document.getElementById('room-link');
      if (room_link)
        if (location.hash.length > 2)
          $('#room_link').attr('href', location.href);
        else
          //Math.round(900000*Math.random()+100000); 隨機六位數
          $('#room-id-input').val('#' + (Math.random() * new Date().getTime()).toString(36).toUpperCase().replace(/\./g, '-'));
      //



      /*function readjust(){
        $('#mini-video').remove();
        for(var i=0;i++;i<streams.length)
        {
          $(".css_tr").append('<div clsss="css_td"><video id="mini-video" onclick="click_mini_vedio(this)" oncanplay="mini_video(this)" autoplay="" muted="" streamid="'+streams[i]+'" src="'+stream_blob[i]+'" class="" style="bottom: '+i*25+'%;"></video></div>');
        }
        console.log(streamid);

        console.log(stream_blob);
      };*/

      function readjust1(e){
        $("video[userid="+e.userid+"][streamid="+e.data+"]").each(function(){
          console.log("delete "+e.userid+"  "+e.data);
          meet_number--;
          if($(this).attr("id") == "remote-video"){
            var stream_id = $("video[type='local']").attr('streamid');
            var e_blob = $("video[type='local']").attr('src');
            var type = $("video[type='local']").attr('type');
            var user_id = $("video[type='local']").attr('userid');
            
            $("video[type='local']").remove();
            
            $(this).attr('src',e_blob);
            $(this).attr('streamid',stream_id);
            $(this).attr('type',type);
            $(this).attr('userid',user_id);
            console.log(type);
          }else{
            $(this).remove();
          }
        });

        var i=0;
        $("video[id='mini-video']").each(function(){
          $(this).css( "bottom", i*25+"%" );
        });
      };

      function readjust(e){
        $("video[userid="+e.userid+"]").each(function(){
          console.log(e.userid);
          meet_number--;
          if($(this).attr("id") == "remote-video"){
            var stream_id = $("video[type='local']").attr('streamid');
            var e_blob = $("video[type='local']").attr('src');
            var type = $("video[type='local']").attr('type');
            var user_id = $("video[type='local']").attr('userid');
            
            $("video[type='local']").remove();
            
            $(this).attr('src',e_blob);
            $(this).attr('streamid',stream_id);
            $(this).attr('type',type);
            $(this).attr('userid',user_id);
            console.log(type);
          }else{
            $(this).remove();
          }
        });

        var i=0;
        $("video[id='mini-video']").each(function(){
          $(this).css( "bottom", i*25+"%" );
        });



        /*$("video[type="+e.userid+"]").each(function(){
          var stream_id = $(this).attr('streamid');
          var e_blob = $(number).attr('src');
          var type = $(number).attr('type');
          var user_id = $(number).attr('userid');
          $(this).attr('src',$('#remote-video').attr('src'));
          $(this).attr('streamid',$('#remote-video').attr('streamid'));
          $(this).attr('type',$('#remote-video').attr('type'));
          $(this).attr('userid',$('#remote-video').attr('userid'));
          $('#remote-video').attr('src',e_blob);
          $('#remote-video').attr('streamid',stream_id);
          $('#remote-video').attr('type',type);
          $('#remote-video').attr('userid',user_id);
        });
*/

        /*$('#mini-video').remove();
        for(var i=0;i++;i<streams.length)
        {
          $(".css_tr").append('<div clsss="css_td"><video id="mini-video" onclick="click_mini_vedio(this)" oncanplay="mini_video(this)" autoplay="" muted="" streamid="'+streams[i]+'" src="'+stream_blob[i]+'" class="" style="bottom: '+i*25+'%;"></video></div>');
        }
        console.log(streamid);

        console.log(stream_blob);*/
      };




    function init_local_user(e){
        try { 
            var urlhash = window.location.hash; 
            if (!urlhash.match("fromapp")) { 
              if ((navigator.userAgent.match(/(iPhone|iPod|Android|ios|iPad)/i))) { 
                  $('#share-screen').attr('class','hidden');
              }else{
                  $('#share-screen').attr('class',' ');
              }
            } 
        }catch(err) {}

        $('#remote-video').attr('src', e.blobURL);
        $('#remote-video').attr('class', 'active');
        $('#remote-video').attr('streamid', e.streamid);
        $('#remote-video').attr('type', "local");
        $('#remote-video').attr('userid', e.userid);
        
        $('#sharing-div').attr('class', "active");
        $('#room-link-href').attr('href', location.href);
        $('#room-link-href').text(location.href);
    };

    function init_remote_user(e){
        $(".css_tr").append('<video id="mini-video" onclick="click_mini_vedio(this)" oncanplay="mini_video(this)" autoplay="" muted="" streamid="'+e.streamid+'" type="remote" userid="'+e.userid+'" src="'+e.blobURL+'" class="" style="bottom: '+meet_number*25+'%;"></video>');
       

        $('#sharing-div').attr('class', " ");
        $('#local-video').removeAttr('src');

        $('#hangup').attr('class',' ');
        $('#leave').attr('class',' ');

        meet_number++;
    };

    function mini_video(number){
          //alert("add event");
            $(number).attr('class','active');
            $(number).mouseenter(function(){
              $(number).css({"border":"3px solid red"});
            })
            .mouseleave(function(){
              $(number).css({"border":"1px solid grey"});
            });

            $(number).bind('onended', function(){
                 $(number).attr('class','hidden');
            });
    };
    function click_mini_vedio(number){
        //alert("change video");
        var stream_id = $(number).attr('streamid');
        var e_blob = $(number).attr('src');
        var type = $(number).attr('type');
        var user_id = $(number).attr('userid');
        $(number).attr('src',$('#remote-video').attr('src'));
        $(number).attr('streamid',$('#remote-video').attr('streamid'));
        $(number).attr('type',$('#remote-video').attr('type'));
        $(number).attr('userid',$('#remote-video').attr('userid'));
        $('#remote-video').attr('src',e_blob);
        $('#remote-video').attr('streamid',stream_id);
        $('#remote-video').attr('type',type);
        $('#remote-video').attr('userid',user_id);
        $(number).unbind();//交換src時會將mini_video的監聽事件在註冊一次,所以要先移除原有的監聽事件
      };


    function successCallback(stream) {
        window.stream = stream; // stream available to console
        if (window.URL) {
          $('#local-video').attr('src', window.URL.createObjectURL(stream));
        } else {
          $('#local-video').attr('src', stream);
        }
      }

      function errorCallback(error){
        console.log("navigator.getUserMedia error: ", error);
      }

    function removeA(arr) {
      var what, a = arguments, L = a.length, ax;
      while (L > 1 && arr.length) {
          what = a[--L];
          while ((ax= arr.indexOf(what)) !== -1) {
              arr.splice(ax, 1);
          }
      }
      return arr;
    }


  </script>

</body>
</html>
