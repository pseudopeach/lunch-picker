<cfparam name="URL.weeksAgo" default="0" />
<cfif not isNumeric(URL.weeksAgo)> <cfabort/></cfif>

<cfset date = dateAdd("D",-dayOfWeek(NOW())-7*URL.weeksAgo+2,NOW()) />

<cfoutput>
<b>
<cfif weeksAgo lt 10>
	<a href="#CGI.SCRIPT_NAME#?section=manageHistory&weeksAgo=#URL.weeksAgo+1#">&laquo;</a> 
</cfif>
Week of #dateFormat(date,"mmm d")#
<cfif weeksAgo gt 0>
	<a href="#CGI.SCRIPT_NAME#?section=manageHistory&weeksAgo=#URL.weeksAgo-1#">&raquo;</a> 
</cfif>
</b>
<br/><br/>




<cfset hist = LUNCH.getHistory(date,SESSION.admin_group_id) />
<cfset qindex = 1 />

<cfform name="calendar_form" >
<table>
<cfloop from="1" to="7" index="i">
	<tr style="height:50px">
		<td>#dateFormat(date,"dddd, mmm d")#</td>
        <td style="padding:0px 0px 0px 40px;width:220px">
        	<div id="editor_area_#day(date)#">
			<cfif qindex lte hist.recordCount and day(date) is day(hist.visited[qindex])>
                <b>#hist.name[qindex]#</b>
                <cfset svalue = hist.place_id[qindex] />
                <cfset qindex = qindex + 1 />
            <cfelse>
            	-
                <cfset svalue = 0 />
            </cfif>
            </div>
            <cfinput type="hidden" value="#svalue#" name="selected_place_#day(date)#" />
            <cfinput type="hidden" value="#dateFormat(date,'yyyy-mm-dd')#" name="selected_place_date_#day(date)#" />
        </td>
        <td><a id="edit_link_#day(date)#" class="actionLink" style="padding:5px" href="javascript:showEditor(#day(date)#)">edit</a></td>
    <cfif day(date) is day(now())> <cfbreak /> </cfif>
	<cfset date = dateAdd("D",1,date) />
    </tr>
</cfloop>
</table>

</cfform>

</cfoutput>

<cfajaxproxy cfc="acre-services.model.lunch_api" jsclassname="LunchAPI" />
<script type="text/javascript" src="/jQuery/jquery-1.7.1.js" > </script>
<script type="text/javascript">
var lunchAPI = new LunchAPI();

var selectHTML = "<select id='sele' name='history_selector' onchange='onChangeSelect(this.options[selectedIndex]);'/>";

var ballot;
var editingDay;
var currentValue;
var initialText;
function showEditor(day){
	if(!ballot){
		response = lunchAPI.getFullBallot();
		if(response.success)
			ballot = response.result;
		else{
			alert("Error from server: "+response.message);
			return;
		}
	}
	var hiddenField = $('#selected_place_'+day);	
		
	if(editingDay && editingDay != 0){
		if(editingDay == day){
			hideEditor(editingDay);
			return;
		}else
			hideEditor(editingDay);
	}
	
	var div = $('#editor_area_'+day);
	var selectedId = hiddenField.val();
	
	initialText = div.html();
	div.html('');
	div.append(selectHTML);
	var sel = $("#sele");
	sel.css({width:"200px"});
	
	sel.append(new Option(" - ",0));
	console.log('selectedId: '+selectedId);
	//console.log('select.val(): '+sel.val());
	for(var i=0;i<response.result.length;i++){
		//console.log("add option "+i+": "+response.result[i].place_name);
		var opt = new Option(response.result[i].name, response.result[i].id);
		sel.append(opt);
	}
	sel.val(selectedId);
	currentValue = selectedId;
	//hiddenField.val(selectedId);
	
	editingDay = day;
	$('#edit_link_'+day).html('done');
}

function onChangeSelect(opt){
	currentValue = opt.value;
}

function hideEditor(day){
	var oldValue = $('#selected_place_'+editingDay).val();
	var div = $('#editor_area_'+day);
	if(currentValue != oldValue){
		var response = lunchAPI.setHistory($('#selected_place_date_'+editingDay).val(),currentValue);
		
		if(!response.success){
			alert("Server message: "+response.message);
			div.html(initialText);
			return;
		}
	}
	div.html("<b>"+$('#sele > option:selected').text()+"</b>");
	
	editingDay = 0;
	initialText = "";
	$('#edit_link_'+day).html('edit');
}


</script>