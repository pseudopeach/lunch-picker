<style>
	h4 {margin:15px 0px 5px}
</style>
<cfoutput>
<cfif isDefined("FORM.submitted")>
	<cfset poll_time = createTime(FORM.hour,FORM.minute,0)/>
	<cfset poll_time = dateAdd("n",-zone*60,poll_time) />
	<cfset result = LUNCH.updateGroupInfo(FORM.name, poll_time, FORM.e_type,zone) />
    <cfif result.success>
    	<div class="message">Information updated</div>
    <cfelse>
		<div class="message error">#result.message#. #result.count_added# added.</div>
	</cfif>
</cfif>

<cfset info = LUNCH.getGroupInfo(SESSION.admin_group_id) />
<cfset local_time = dateAdd("n",info.zone*60,info.poll_close_utc) />


<cfform action="#CGI.SCRIPT_NAME#" method="post">
<h4>Group Name</h4>
<cfinput type="text" name="name" style="width:300px"  maxlength="64"  class="formInput" value="#info.name#"/>

<h4>Polls Close</h4>
<cfselect name="hour" style="width:60px" selected="#hour(local_time)#">
<cfloop from="1" to="24" index="i">
	<option value="#i-1#" <cfif hour(local_time) is (i-1)> selected='selected' </cfif> >#numberFormat(i-1,"09")#</option>
</cfloop>
</cfselect>
:
<cfselect name="minute" style="width:60px" selected="#minute(local_time)#">
<cfloop from="1" to="12" index="i">
	<option value="#(i-1)*5#" <cfif minute(local_time) is (i-1)*5> selected='selected' </cfif>  >#numberFormat((i-1)*5,"09")#</option>
</cfloop>
</cfselect>
<h4>Zone</h4> 
<cfselect name="zone" selected="5">
    <option value="-8" <cfif info.zone is -8> selected='selected' </cfif>>San Francisco</option>
    <option value="-7" <cfif info.zone is -7> selected='selected' </cfif>>Phoenix</option>
    <option value="-7" <cfif info.zone is -7> selected='selected' </cfif>>Denver</option>
    <option value="-6" <cfif info.zone is -6> selected='selected' </cfif>>Chicago</option>
    <option value="-5" <cfif info.zone is -5> selected='selected' </cfif>>New York</option>
    <option value="-1" <cfif info.zone is -1> selected='selected' </cfif>>Anchorage</option>
    <option value="-9" <cfif info.zone is -9> selected='selected' </cfif>>Honolulu</option>
    <option value="0" <cfif info.zone is 0> selected='selected' </cfif>>(UTC) - London</option>
    <option value="1" <cfif info.zone is 1> selected='selected' </cfif>>(UTC+1) - Paris</option>
    <option value="2" <cfif info.zone is 2> selected='selected' </cfif>>(UTC+2) - Istanbul</option>
    <option value="3" <cfif info.zone is 3> selected='selected' </cfif>>(UTC+3) - Moscow</option>
    <option value="4" <cfif info.zone is 4> selected='selected' </cfif>>(UTC+4) - Oman</option>
    <option value="5" <cfif info.zone is 5> selected='selected' </cfif>>(UTC+5) - Karachi</option>
    <option value="5.5" <cfif info.zone is 5.5> selected='selected' </cfif>>(UTC+5.5) - Mumbai</option>
    <option value="6" <cfif info.zone is 6> selected='selected' </cfif>>(UTC+6) - Astana</option>
    <option value="7" <cfif info.zone is 7> selected='selected' </cfif>>(UTC+7) - Jakarta</option>
    <option value="8" <cfif info.zone is 8> selected='selected' </cfif>>(UTC+8) - Hong Kong</option>
    <option value="9" <cfif info.zone is 9> selected='selected' </cfif>>(UTC+9) - Seoul</option>
    <option value="9.5" <cfif info.zone is 9.5> selected='selected' </cfif>>(UTC+9.5) - Darwin</option>
    <option value="1" <cfif info.zone is 1> selected='selected' </cfif>>(UTC+10) - Sydney</option>
    <option value="1" <cfif info.zone is 1> selected='selected' </cfif>>(UTC+11) - Magadan</option>
    <option value="1" <cfif info.zone is 1> selected='selected' </cfif>>(UTC+12) - Aukland</option>
    <option value="-1" <cfif info.zone is -1> selected='selected' </cfif>>(UTC-11) - Samoa</option>
    <option value="-4" <cfif info.zone is -4> selected='selected' </cfif>>(UTC-4) - Santiago</option>
    <option value="-3" <cfif info.zone is -3> selected='selected' </cfif>>(UTC-3) - S&atilde;o Paulo </option>
    <option value="-2" <cfif info.zone is -2> selected='selected' </cfif>>(UTC-2) - South Georgia</option>
    <option value="-1" <cfif info.zone is -1> selected='selected' </cfif>>(UTC-1) - Azores</option>
</cfselect>


<h4>Election Rules</h4>
<cfselect name="e_type" style="width:300px" selected="alt">
	<option value="borda" <cfif info.election_type is 'borda'> selected='selected' </cfif>>Consensus Builder (Borda)</option>
    <option value="alt" <cfif info.election_type is 'alt'> selected='selected' </cfif>>Instant Runoff (Alternate Vote)</option>
    <option value="FPP" <cfif info.election_type is 'FPP'> selected='selected' </cfif>>Traditional (First Past the Post)</option>
</cfselect>

<br/><br/>

<cfinput type="submit" value="Save" name="submitted" />

<br/><br/><br/>

</cfform>
</cfoutput>
