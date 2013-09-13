<cfoutput>
<cfif isDefined("FORM.submitted")>
	<cfset ar = arrayNew(1) />
	<cfloop from="1" to="5" index="i">
		<cfif isDefined("FORM.place_name_#i#") and trim(FORM["place_name_"&i]) is not "">
			<cfset arrayAppend(ar, FORM["place_name_"&i]) />
		</cfif>
	</cfloop>
	<cfset result = LUNCH.addPlaces(ar, SESSION.admin_group_id) />
	<cfif result.success>
    	<div class="message">Added #result.count_added# places</div>
    <cfelse>
		<div class="message error">#result.message#</div>
	</cfif>
</cfif>

<cfset places = LUNCH.getGroupPlaces(SESSION.admin_group_id) />

<h2>Lunch Places</h2>
<div id="place_list">
<table>
	<tr>
		<td><b>Place Name</b></td>
		<td></td>
	</tr>
	<cfloop query="places">
		<tr id="place_row_#places.id#">
			<td>#places.name#</td>
			<td><a class="actionLink" href="javascript:removePlace(#places.id#)">remove</a></td>
		</tr>
	</cfloop>
	<cfif places.recordCount is 0>
		<tr><td colspan="2"><i>[no places]</i></td></tr>
	</cfif>
</table>

<div class="add_section">
<a href="javascript:showPlaceForm()" id="show_place_add_link">(+) Add Some Places</a>
<div id="place_add_div" style="display:none">
<cfform action="#CGI.SCRIPT_NAME#?section=managePlaces" method="post" preservedata="yes">
<table id="ballotTbl" cellspacing="20">
	<cfloop from="1" to="5" index="i">
		<tr>
			<td>Place Name:</td>
			<td class="inputCell"><cfinput name="place_name_#i#" type="text"
             autocomplete="off" onFocus="startSuggestion('place_name_#i#')" maxlength="64"/></td>
		</tr>
	</cfloop>
	
	<td colspan="2" style="text-align:center">
		<cfinput type="submit" value="Add Places" name="submitted"/>
	</td>
	</tr>
</table>
</cfform>
</div></div>


<div id="suggestionBox">
	<ul/>
</div>

</div>

</cfoutput>

<cfajaxproxy cfc="acre-services.model.lunch_api" jsclassname="LunchAPI" />
<script type="text/javascript" src="/jQuery/jquery-1.7.1.js" > </script>
<script type="text/javascript">
var lunchAPI = new LunchAPI();

function showPlaceForm(){
	$('#place_add_div').css({display:"block"});
	$('#show_place_add_link').css({display:"none"});
}
function removePlace(id){
	var result = lunchAPI.removePlace(id);
	if(result.success)
		$('#place_row_'+id).css({display:"none"});
}
	
//============== ajax suggest ===========================	
	
var selectedSuggestion = -1;	
var qtimeout = -1;
$(document).keydown(function(e){
	//alert("keypress");
	if(!currentSuggestionInput) return;
	var keyId = e.keyCode;
	if(keyId == 38 || keyId == 40){ //up/down arrows
		e.preventDefault();
		var blocks = $("#suggestionBox li");
		if(keyId == 38) selectedSuggestion--;
		else selectedSuggestion++;
		selectedSuggestion = (blocks.length+selectedSuggestion) % blocks.length;
		blocks.each(function(i) {
			if(i==selectedSuggestion)
				$(this).addClass('suggestionSelected');
			else
				$(this).removeClass('suggestionSelected');
		});
	}else if(keyId == 13 && selectedSuggestion >= 0){ //enter key with something selected
		e.preventDefault();
		onChoiceSelected(selectedSuggestion);
	}else{//all keystroks
		clearTimeout(qtimeout);
		qtimeout = setTimeout(doSuggestions,200);	
	}
});

var currentSuggestionInput;

function startSuggestion(inputId){// start watching a certain field
	console.log("Start suggestions");
	inputItem = $("#"+inputId);
	currentSuggestionInput = inputItem;
}

function doSuggestions(){//query the server for suggestions
	if(!currentSuggestionInput || currentSuggestionInput.val().length < 3) return;	
	var response = lunchAPI.suggestPlaces(currentSuggestionInput.val());
	if(response.success && response.result.length > 0){
		loadSuggestions(response.result)
		showSuggestions();
	}else
		hideSuggestions();
}

function loadSuggestions(list){//render an array of strings as the contents of the suggestionBox
	$("#suggestionBox ul").html('');
	for(var i=0;i<list.length;i++){
		$("#suggestionBox ul").append('<a href="javascript:onChoiceSelected('+i+');" ><li>'+list[i]+'</li></a>');
	}
}

function showSuggestions(){//position and show suggestion div
	pos = currentSuggestionInput.position();
	$("#suggestionBox").css({ display:'block', top: (pos.top+inputItem.height()+10), left:pos.left});
}

function hideSuggestions(){//hide suggestion div
	currentSuggestionInput = null;
	$("#suggestionBox").css({display:'none'});
}

function onChoiceSelected(index){//user selected a choice, copy value to text box and hide suggestions
	var item = $("#suggestionBox li").eq(index);
	currentSuggestionInput.val(item.html());
	hideSuggestions();
	selectedSuggestion = -1;
}

</script>

