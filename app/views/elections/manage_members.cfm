<cfoutput>
<cfif isDefined("FORM.submitted")>
	<cfset email_list = "" />
    
    <cfloop from="1" to="5" index="i">
		<cfif isDefined("FORM.member_email_#i#") and trim(FORM["member_email_"&i]) is not "">
			<cfset email_list = listAppend(email_list, FORM["member_email_"&i]) />
		</cfif>
	</cfloop>
    <cfset result = LUNCH.addGroupMembers(email_list, SESSION.admin_group_id) />
	<cfif result.success>
    	<div class="message">Invited #result.count_added# voters</div>
    <cfelse>
		<div class="message error">#result.message#. #result.count_added# added.</div>
	</cfif>
</cfif>

<cfset response = LUNCH.getGroupMembers(SESSION.admin_group_id) />
<cfset members = response.result />

<h2>Lunch Group Voters</h2>
<div id="place_list">
<table>
	<tr>
		<td><b>Email</b></td>
		<td></td>
        <td></td>
	</tr>
	<cfloop query="members">
		<tr id="member_row_#members.id#">
			<td class="member_email_cell">#members.email#</td>
			<td class="member_remove_cell">
            	<cfif members.is_admin is 0><a class="actionLink" href="javascript:askRemoveMember(#members.id#)">remove</a></cfif>
            </td>
            <td class="member_reinvite_cell"><a class="actionLink" href="javascript:askEmailMember(#members.id#)">re-invite</a></td>
		</tr>
	</cfloop>
	<cfif members.recordCount is 0>
		<tr><td colspan="2"><i>[no voters]</i></td></tr>
	</cfif>
</table>

<div class="add_section">
<a href="javascript:showPlaceForm()" id="show_place_add_link">(+) Register New Voters</a>
<div id="place_add_div" style="display:none">
<cfform action="#CGI.SCRIPT_NAME#?section=manageMembers" method="post" preservedata="yes">
<table id="ballotTbl" cellspacing="20">
	<cfloop from="1" to="3" index="i">
		<tr>
			<td>Voter Email:</td>
			<td class="inputCell"><cfinput name="member_email_#i#" type="text"/></td>
		</tr>
	</cfloop>
	
	<td colspan="2" style="text-align:center">
		<cfinput type="submit" value="Add Voters" name="submitted"/>
	</td>
	</tr>
</table>
</cfform>
</div></div>

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
function askRemoveMember(id){
	var name = $("#member_row_"+id+" .member_email_cell").html();
	if(confirm("Are you sure you want to remove "+name+" from your group's voter list?"))
		removeMember(id);
		
}
function removeMember(id){
	var result = lunchAPI.removeGroupMember(id);
	if(result.success)
		$('#member_row_'+id).css({display:"none"});
}
function askEmailMember(id){
	var name = $("#member_row_"+id+" .member_email_cell").html();
	if(confirm("Are you sure you want send another invitation email to "+name+"?"))
		emailMember(id);
}
function emailMember(id){
	var result = lunchAPI.emailInviteMember(id);
	if(result.success)
		$("#member_row_"+id+" .member_email_cell a").css({display:"none"});
}
	
</script>

