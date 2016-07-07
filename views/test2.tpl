<!DOCTYPE html>
<html lang="en">

<head>
    <title>RTCMultiConnection All-in-One Test ® Muaz Khan</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <link rel="author" type="text/html" href="https://plus.google.com/+MuazKhan">
    <meta name="author" content="Muaz Khan">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link rel="stylesheet" href="https://cdn.webrtc-experiment.com/style.css">

    <style>
    audio,
    video {
        -moz-transition: all 1s ease;
        -ms-transition: all 1s ease;
        -o-transition: all 1s ease;
        -webkit-transition: all 1s ease;
        transition: all 1s ease;
        vertical-align: top;
    }
    
    input {
        border: 1px solid #d9d9d9;
        border-radius: 1px;
        font-size: 2em;
        margin: .2em;
        width: 20%;
    }
    
    select {
        border: 1px solid #d9d9d9;
        border-radius: 1px;
        height: 50px;
        margin-left: 1em;
        margin-right: -12px;
        padding: 1.1em;
        vertical-align: 6px;
    }
    
    .setup {
        border-bottom-left-radius: 0;
        border-top-left-radius: 0;
        font-size: 102%;
        height: 47px;
        margin-left: -9px;
        margin-top: 8px;
        position: absolute;
    }
    
    p {
        padding: 1em;
    }
    
    #chat-output div,
    #file-progress div {
        border: 1px solid black;
        border-bottom: 0;
        padding: .1em .4em;
    }
    
    #chat-output,
    #file-progress {
        margin: 0 0 0 .4em;
        max-height: 12em;
        overflow: auto;
    }
    
    .data-box input {
        border: 1px solid black;
        font-family: inherit;
        font-size: 1em;
        margin: .1em .3em;
        outline: none;
        padding: .1em .2em;
        width: 97%;
    }
    </style>
    <script>
    document.createElement('article');
    document.createElement('footer');
    </script>

    <!-- webrtc library used for streaming -->
    <script src="https://cdn.webrtc-experiment.com/firebase.js">
    </script>
    <script src="https://cdn.webrtc-experiment.com/getMediaElement.min.js">
    </script>
    <script src="https://cdn.webrtc-experiment.com/RTCMultiConnection.js">
    </script>
</head>

<body>
    <article>
        <header style="text-align: center;">
            <h1>
                <a href="http://www.RTCMultiConnection.org/" target="_blank">RTCMultiConnection</a> All-in-One test ®
                <a href="https://github.com/muaz-khan" target="_blank">Muaz Khan</a>
            </h1>
            <p>
                <a href="https://www.webrtc-experiment.com/">HOME</a>
                <span> &copy; </span>
                <a href="http://www.MuazKhan.com/" target="_blank">Muaz Khan</a> .
                <a href="http://twitter.com/WebRTCWeb" target="_blank" title="Twitter profile for WebRTC Experiments">@WebRTCWeb</a> .
                <a href="https://github.com/muaz-khan?tab=repositories" target="_blank" title="Github Profile">Github</a> .
                <a href="https://github.com/muaz-khan/RTCMultiConnection/issues?state=open" target="_blank">Latest issues</a> .
                <a href="https://github.com/muaz-khan/RTCMultiConnection/commits/master" target="_blank">What's New?</a>
            </p>
        </header>

        <div class="github-stargazers"></div>

        <!-- just copy this <section> and next script -->
        <section class="experiment">
            <div style="float: right;">
                <input type="checkbox" id="fakeDataChannels" style="width: auto;">
                <label for="fakeDataChannels" title="You can chat and share files using your preferred signaling gateway instead of using WebRTC data channels!">Setup Fake Data Connection?</label>
            </div>

            <h2 class="header" id="feedback">
                Select SessionType and Direction-of-Flow!
            </h2>

            <section>
                <select id="session" title="Session">
                    <option>audio+video+data+screen</option>
                    <option>audio+video+data</option>
                    <option>audio+data+screen</option>
                    <option>audio+video+screen</option>
                    <option selected>audio+video</option>
                    <option>audio+screen</option>
                    <option>video+screen</option>
                    <option>data+screen</option>
                    <option>audio+data</option>
                    <option>video+data</option>
                    <option>audio</option>
                    <option>video</option>
                    <option>data</option>
                    <option>screen</option>
                </select>
                <select id="direction" title="Direction">
                    <option>many-to-many</option>
                    <option>one-to-one</option>
                    <option>one-to-many</option>
                    <option>one-way</option>
                </select>
                <input type="text" id="session-name">
                <button id="setup-new-session" class="setup">New Session</button>
            </section>

            <!-- list of all available broadcasting rooms -->
            <table style="width: 100%;" id="rooms-list"></table>

            <!-- local/remote videos container -->
            <div id="videos-container"></div>
        </section>

        <section class="experiment data-box">
            <h2 class="header" style="border-bottom: 0;">WebRTC DataChannel</h2>
            <table style="width: 100%;">
                <tr>
                    <td>
                        <h2 style="display: block; font-size: 1em; text-align: center;">Text Chat</h2>

                        <div id="chat-output"></div>
                        <input type="text" id="chat-input" style="font-size: 1.2em;" placeholder="chat message" disabled>
                    </td>
                    <td style="background: white;">
                        <h2 style="display: block; font-size: 1em; text-align: center;">Share Files</h2>
                        <input type="file" id="file" disabled>

                        <div id="file-progress"></div>
                    </td>
                </tr>
            </table>
        </section>

        <script>
        // Muaz Khan     - www.MuazKhan.com
        // MIT License   - www.WebRTC-Experiment.com/licence
        // Documentation - www.RTCMultiConnection.org

        var connection = new RTCMultiConnection();

        connection.session = {
            audio: true,
            video: true
        };

        var roomsList = document.getElementById('rooms-list'),
            sessions = {};
        connection.onNewSession = function(session) {
            if (sessions[session.sessionid]) return;
            sessions[session.sessionid] = session;

            var tr = document.createElement('tr');
            tr.innerHTML = '<td><strong>' + session.extra['session-name'] + '</strong> is an active session.</td>' +
                '<td><button class="join">Join</button></td>';
            roomsList.insertBefore(tr, roomsList.firstChild);

            tr.querySelector('.join').setAttribute('data-sessionid', session.sessionid);
            tr.querySelector('.join').onclick = function() {
                this.disabled = true;

                session = sessions[this.getAttribute('data-sessionid')];
                if (!session) alert('No room to join.');

                connection.join(session);
            };
        };

        var videosContainer = document.getElementById('videos-container') || document.body;
        connection.onstream = function(e) {
            var buttons = ['mute-audio', 'mute-video', 'record-audio', 'record-video', 'full-screen', 'volume-slider', 'stop'];

            if (connection.session.audio && !connection.session.video) {
                buttons = ['mute-audio', 'full-screen', 'stop'];
            }

            var mediaElement = getMediaElement(e.mediaElement, {
                width: (videosContainer.clientWidth / 2) - 50,
                title: e.userid,
                buttons: buttons,
                onMuted: function(type) {
                    connection.streams[e.streamid].mute({
                        audio: type == 'audio',
                        video: type == 'video'
                    });
                },
                onUnMuted: function(type) {
                    connection.streams[e.streamid].unmute({
                        audio: type == 'audio',
                        video: type == 'video'
                    });
                },
                onRecordingStarted: function(type) {
                    // www.RTCMultiConnection.org/docs/startRecording/
                    connection.streams[e.streamid].startRecording({
                        audio: type == 'audio',
                        video: type == 'video'
                    });
                },
                onRecordingStopped: function(type) {
                    // www.RTCMultiConnection.org/docs/stopRecording/
                    connection.streams[e.streamid].stopRecording(function(blob) {
                        if (blob.audio) connection.saveToDisk(blob.audio);
                        else if (blob.video) connection.saveToDisk(blob.video);
                        else connection.saveToDisk(blob);
                    }, type);
                },
                onStopped: function() {
                    connection.peers[e.userid].drop();
                }
            });

            videosContainer.insertBefore(mediaElement, videosContainer.firstChild);

            if (e.type == 'local') {
                mediaElement.media.muted = true;
                mediaElement.media.volume = 0;
            }
        };

        connection.onstreamended = function(e) {
            if (e.mediaElement.parentNode && e.mediaElement.parentNode.parentNode && e.mediaElement.parentNode.parentNode.parentNode) {
                e.mediaElement.parentNode.parentNode.parentNode.removeChild(e.mediaElement.parentNode.parentNode);
            }
        };

        var setupNewSession = document.getElementById('setup-new-session');

        setupNewSession.onclick = function() {
            setupNewSession.disabled = true;

            var direction = document.getElementById('direction').value;
            var _session = document.getElementById('session').value;
            var splittedSession = _session.split('+');

            var session = {};
            for (var i = 0; i < splittedSession.length; i++) {
                session[splittedSession[i]] = true;
            }

            var maxParticipantsAllowed = 256;

            if (direction == 'one-to-one') maxParticipantsAllowed = 1;
            if (direction == 'one-to-many') session.broadcast = true;
            if (direction == 'one-way') session.oneway = true;

            var sessionName = document.getElementById('session-name').value;
            connection.extra = {
                'session-name': sessionName || 'Anonymous'
            };

            connection.session = session;
            connection.maxParticipantsAllowed = maxParticipantsAllowed;

            if (!!document.querySelector('#fakeDataChannels').checked) {
                // http://www.rtcmulticonnection.org/docs/fakeDataChannels/
                connection.fakeDataChannels = true;
            }

            connection.sessionid = sessionName || 'Anonymous';
            connection.open();
        };

        connection.onmessage = function(e) {
            appendDIV(e.data);

            console.debug(e.userid, 'posted', e.data);
            console.log('latency:', e.latency, 'ms');
        };

        connection.onclose = function(e) {
            appendDIV('Data connection is closed between you and ' + e.userid);
        };

        connection.onleave = function(e) {
            appendDIV(e.userid + ' left the session.');
        };

        // on data connection gets open
        connection.onopen = function() {
            if (document.getElementById('chat-input')) document.getElementById('chat-input').disabled = false;
            if (document.getElementById('file')) document.getElementById('file').disabled = false;
            if (document.getElementById('open-new-session')) document.getElementById('open-new-session').disabled = true;
        };

        var progressHelper = {};

        connection.autoSaveToDisk = false;

        connection.onFileProgress = function(chunk) {
            var helper = progressHelper[chunk.uuid];
            helper.progress.value = chunk.currentPosition || chunk.maxChunks || helper.progress.max;
            updateLabel(helper.progress, helper.label);
        };
        connection.onFileStart = function(file) {
            var div = document.createElement('div');
            div.title = file.name;
            div.innerHTML = '<label>0%</label> <progress></progress>';
            appendDIV(div, fileProgress);
            progressHelper[file.uuid] = {
                div: div,
                progress: div.querySelector('progress'),
                label: div.querySelector('label')
            };
            progressHelper[file.uuid].progress.max = file.maxChunks;
        };

        connection.onFileEnd = function(file) {
            progressHelper[file.uuid].div.innerHTML = '<a href="' + file.url + '" target="_blank" download="' + file.name + '">' + file.name + '</a>';
        };

        function updateLabel(progress, label) {
            if (progress.position == -1) return;
            var position = +progress.position.toFixed(2).split('.')[1] || 100;
            label.innerHTML = position + '%';
        }

        function appendDIV(div, parent) {
            if (typeof div === 'string') {
                var content = div;
                div = document.createElement('div');
                div.innerHTML = content;
            }

            if (!parent) chatOutput.insertBefore(div, chatOutput.firstChild);
            else fileProgress.insertBefore(div, fileProgress.firstChild);

            div.tabIndex = 0;
            div.focus();
        }

        document.getElementById('file').onchange = function() {
            connection.send(this.files[0]);
        };

        var chatOutput = document.getElementById('chat-output'),
            fileProgress = document.getElementById('file-progress');

        var chatInput = document.getElementById('chat-input');
        chatInput.onkeypress = function(e) {
            if (e.keyCode !== 13 || !this.value) return;
            appendDIV(this.value);

            // sending text message
            connection.send(this.value);

            this.value = '';
        };

        connection.connect();
        </script>

        <section class="experiment">
            <ol>
                <li>Mesh networking model is implemented to open multiple (1:1) interconnected peer connections</li>
                <li>Maximum peer connections limit per page is
                    <strong>256</strong> (on chrome) i.e. 256 users can connect together!</li>
            </ol>
        </section>

        <section class="experiment">
            <h2 class="header">How to use <a href="http://www.RTCMultiConnection.org/" target="_blank">RTCMultiConnection</a>?</h2>

            <pre>
// https://cdn.webrtc-experiment.com/RTCMultiConnection.js
</pre>
        </section>

        <section class="experiment">
            <h2 class="header">Common Code</h2>

            <pre>
var MODERATOR_CHANNEL_ID = 'ABCDEF'; // channel-id
var MODERATOR_SESSION_ID = 'XYZ';    // room-id
var MODERATOR_ID         = 'JKL';    // user-id
var MODERATOR_SESSION    = {         // media-type
    audio: true,
    video: true
};
var MODERATOR_EXTRA      = {};       // empty extra-data
</pre>
        </section>

        <section class="experiment">
            <h2 class="header">Code for Room Moderator (i.e. Initiator)</h2>

            <pre>
var moderator     = <a href="http://www.RTCMultiConnection.org/docs/constructor/">new RTCMultiConnection</a>(MODERATOR_CHANNEL_ID);
moderator.<a href="http://www.RTCMultiConnection.org/docs/session/">session</a> = MODERATOR_SESSION;
moderator.<a href="http://www.RTCMultiConnection.org/docs/userid/">userid</a>  = MODERATOR_ID;
moderator.<a href="http://www.RTCMultiConnection.org/docs/extra/">extra</a>   = MODERATOR_EXTRA;
moderator.<a href="http://www.RTCMultiConnection.org/docs/open/">open</a>({
    dontTransmit: true,
    sessionid:    MODERATOR_SESSION_ID
});
</pre>
        </section>

        <section class="experiment">
            <h2 class="header">Code for Room Participants</h2>

            <pre>
var participants = <a href="http://www.RTCMultiConnection.org/docs/constructor/">new RTCMultiConnection</a>(MODERATOR_CHANNEL_ID);
participants.<a href="http://www.RTCMultiConnection.org/docs/join/">join</a>({
    sessionid: MODERATOR_SESSION_ID,
    userid:    MODERATOR_ID,
    extra:     MODERATOR_EXTRA,
    session:   MODERATOR_SESSION
});
</pre>
        </section>

        <section class="experiment">
            <h2 class="header">(optional) Handle how to get streams</h2>

            <pre>
// same code can be used for participants
// (it is optional) 
connection.<a href="http://www.RTCMultiConnection.org/docs/onstreamid/">onstreamid</a> = function(event) {
    // got a clue of incoming remote stream
    // didn't get remote stream yet
    
    var incoming_stream_id = event.streamid;
    
    YOUR_PREVIEW_IMAGE.show();
    
    // or
    YOUR_PREVIEW_VIDEO.show();
};

// same code can be used for participants
// it is useful
connection.<a href="http://www.RTCMultiConnection.org/docs/onstream/">onstream</a> = function(event) {
    // got local or remote stream
    // if(event.type == 'local')  {}
    // if(event.type == 'remote') {}
    
    document.body.appendChild(event.mediaElement);
    
    // or YOUR_VIDEO.src = event.blobURL;
    // or YOUR_VIDEO.src = URL.createObjectURL(event.stream);
};

// same code can be used for participants
// it is useful but optional
connection.<a href="http://www.RTCMultiConnection.org/docs/onstreamended/">onstreamended</a> = function(event) {
    event.mediaElement.parentNode.removeChild(event.mediaElement);
};
</pre>
        </section>

        <section class="experiment own-widgets">
            <h2 class="header" id="updates" style="color: red;padding-bottom: .1em;"><a href="https://github.com/muaz-khan/RTCMultiConnection/issues">Latest Issues</a></h2>
            <div id="github-issues"></div>
        </section>

        <section class="experiment">
            <h2 class="header" id="feedback">Feedback</h2>
            <div>
                <textarea id="message" style="border: 1px solid rgb(189, 189, 189); height: 8em; margin: .2em; outline: none; resize: vertical; width: 98%;" placeholder="Have any message? Suggestions or something went wrong?"></textarea>
            </div>
            <button id="send-message" style="font-size: 1em;">Send Message</button>
            <small style="margin-left: 1em;">Enter your email too; if you want "direct" reply!</small>
        </section>

        <section class="experiment own-widgets latest-commits">
            <h2 class="header" id="updates" style="color: red; padding-bottom: .1em;"><a href="https://github.com/muaz-khan/RTCMultiConnection/commits/master" target="_blank">Latest Updates</a>
            </h2>
            <div id="github-commits"></div>
        </section>
    </article>

    <a href="https://github.com/muaz-khan/RTCMultiConnection" class="fork-left"></a>

    <footer>
        <a href="https://www.webrtc-experiment.com/" target="_blank">WebRTC Experiments!</a> and
        <a href="http://www.RTCMultiConnection.org/" target="_blank">RTCMultiConnection.js</a> ©
        <a href="mailto:muazkh@gmail.com" target="_blank">Muaz Khan</a>:
        <a href="https://twitter.com/WebRTCWeb" target="_blank">@WebRTCWeb</a>
    </footer>

    <!-- commits.js is useless for you! -->
    <script>
        window.useThisGithubPath = 'muaz-khan/RTCMultiConnection';
    </script>
    <script src="https://cdn.webrtc-experiment.com/commits.js" async>
    </script>
</body>

</html>