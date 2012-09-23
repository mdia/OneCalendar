jQuery.webshims.register("track-ui",function(i,f,o){var p=f.cfg.track,l={type:"enter"},m={type:"exit"},n={subtitles:1,captions:1},k={show:function(a,b,d){if(!b.trackDisplay)b.trackDisplay=i('<div class="cue-display"></div>').insertAfter(d),b.hasVisibleTrack=0,this.addEvents(b,d);!b.currentTrack||a.track==b.currentTrack?(b.hasVisibleTrack++,b.currentTrack=a.track,b.visibleCue=a,b.hasDirtyTrackDisplay&&d.triggerHandler("forceupdatetrackdisplay"),b.trackDisplay.html('<span class="cue-text"><span>'+a.text+
"</span></span>")):f.warn("we only handle one visible track")},addEvents:function(a,b){if(p.positionDisplay){var d,g=function(c){if(a.hasVisibleTrack||!0===c){a.trackDisplay.css({display:"none"});var g=b.getShadowElement();g.offsetParent();var c=g.innerHeight(),d=g.innerWidth(),g=g.position(),e=c*d;a.trackDisplay.css({left:g.left,width:d,height:c-5,top:g.top,display:"block"});8E4>e?e="xs":8E4<=e&&1E5>e?e="s":1E5<=e&&3E5>e?e="m":3E5<=e&&55E4>e?e="l":55E4<=e&&99E4>e?e="xl":99E4<=e&&(e="xxl");a.trackDisplay.attr("data-displaysize",
e);a.hasDirtyTrackDisplay=!1}else a.hasDirtyTrackDisplay=!0},j=function(a){clearTimeout(d);d=setTimeout(g,a&&"resize"==a.type?99:9)},f=function(){g(!0)};b.bind("playerdimensionchange mediaelementapichange updatetrackdisplay updatemediaelementdimensions swfstageresize",j);i(o).bind("resize emchange",j);b.bind("forceupdatetrackdisplay",f);f()}},hide:function(a,b){if(b.trackDisplay&&a==b.currentTrack)b.hasVisibleTrack--,b.currentTrack=!1,b.visibleCue=!1,b.trackDisplay.empty()}};f.mediaelement.trackDisplay=
k;f.mediaelement.getActiveCue=function(a,b,d,g){if(!a._lastFoundCue)a._lastFoundCue={index:0,time:0};if(Modernizr.track&&!a._shimActiveCues)a._shimActiveCues=[];var f=a.cues.length,h=a._lastFoundCue.time<d?a._lastFoundCue.index:0,c;if(a.shimActiveCues.length)if(a.shimActiveCues[0].startTime>d||a.shimActiveCues[0].endTime<d){if(c=a.shimActiveCues[0],a.shimActiveCues.pop(),k.hide(a,g),c.pauseOnExit&&i(b).pause(),c.onexit)m.target=c,c.onexit(m)}else g.visibleCue!=a.shimActiveCues[0]&&1<a.mode&&n[a.kind]&&
k.show(a.shimActiveCues[0],g,b);if(!a.shimActiveCues.length)for(;h<f;h++){c=a.cues[h];if(c.startTime<=d&&c.endTime>=d){a.shimActiveCues.push(c);1<a.mode&&n[a.kind]&&k.show(c,g,b);if(c.onenter)l.target=c,c.onenter(l);a._lastFoundCue.time=d;a._lastFoundCue.index=h;break}if(c.startTime>d)break}};Modernizr.track&&function(){var a,b=function(g){a||setTimeout(function(){a=!0;i(g).triggerHandler("updatetrackdisplay");a=!1},9)},d=f.defineNodeNameProperty("track","track",{prop:{get:function(){b(i(this).parent("audio, video"));
return d.prop._supget.apply(this,arguments)}}});["audio","video"].forEach(function(a){var d,h;h=f.defineNodeNameProperty(a,"textTracks",{prop:{get:function(){b(this);return h.prop._supget.apply(this,arguments)}}});d=f.defineNodeNameProperty(a,"addTextTrack",{prop:{value:function(){b(this);return d.prop._supvalue.apply(this,arguments)}}})})}();f.addReady(function(a,b){i("video, audio",a).add(b.filter("video, audio")).each(function(){var a,b=i(this),j,h=function(){b.unbind(".trackview").bind("play.trackview timeupdate.trackview updatetrackdisplay.trackview",
function(){var c,h;if(!a||!j)a=b.prop("textTracks"),j=f.data(b[0],"mediaelementBase")||f.data(b[0],"mediaelementBase",{});if(a&&((h=b.prop("currentTime"))||0===h))for(var i=0,e=a.length;i<e;i++)c=a[i],0<c.mode&&c.cues&&c.cues.length?f.mediaelement.getActiveCue(c,b,h,j):k.hide(c,j)})};(!Modernizr.track||b.is(".nonnative-api-active"))&&h();Modernizr.track&&b.bind("mediaelementapichange",function(){if(b.is(".nonnative-api-active"))h();else{if(!a||!j)a=b.prop("textTracks"),j=f.data(b[0],"mediaelementBase")||
f.data(b[0],"mediaelementBase",{});i.each(a,function(a,b){k.hide(b,j);b._shimActiveCues&&delete b._shimActiveCues});b.unbind(".trackview")}})})})});