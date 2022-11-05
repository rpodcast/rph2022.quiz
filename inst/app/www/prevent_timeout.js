$( document ).on('shiny:sessioninitialized', function(event) {
 // Initialize revive_count value
 var revive_count = 0;
 Shiny.setInputValue('revive_count', revive_count, {priority: 'event'});
 
 // Set xtime < session timeout (in seconds)
 // Based on session timeout = 1m:
 var xtime = 50;
 // var xtime = 5; // DEV TESTING VALUE @ 5 SECONDS
 var t = setTimeout(doRevive, xtime * 1000);
 window.onmousemove = resetTimer;
 window.onmousedown = resetTimer;
 window.onclick = resetTimer;
 window.onscroll = resetTimer;
 window.onkeypress = resetTimer;
 
 // Increment input$revive_count
 function doRevive() {
   revive_count ++;
   Shiny.setInputValue('revive_count', revive_count, {priority: 'event'});
   console.log('Session revived. Revive count:' + revive_count);
   resetTimer();
 }
 
 function resetTimer() {
   clearTimeout(t);
   t = setTimeout(doRevive, xtime * 1000);
 }
});
