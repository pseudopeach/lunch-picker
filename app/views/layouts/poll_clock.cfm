<cfoutput>
<div style="overflow:auto">
<div style="float:left;padding:5px;">
	<cfif poll_info.polls_are_open>
    	Polls Close: 
        <script type="text/javascript">var remaining = #poll_info.time_to_close#;</script>
    <cfelse>
    	Polls Open: 
        <script type="text/javascript">var remaining = #poll_info.time_to_open#;</script>
    </cfif>
</div>
<div style="font-size:24px;font-family:Arial, Helvetica, sans-serif; font-weight:bold; float:left" id="poll_clock">00:00:00</div>
</div>
</cfoutput>



<script type="text/javascript">

function formatTime(seconds){
	var h = Math.floor(seconds/3600);
	seconds -= h*3600;
	var m = Math.floor(seconds/60);
	seconds -= m*60;
	return l0(h)+h+":"+l0(m)+m+":"+l0(seconds)+seconds;	
}
function l0(num){
	return num < 10 ? "0" : "";	
}


function clockTick(){
	$("#poll_clock").html(formatTime(remaining));	
	if(remaining == 0)
		clearInterval(theInterval);
	remaining--;
}

$("#poll_clock").html(formatTime(remaining));

var theInterval = setInterval(clockTick,1000);

</script>

