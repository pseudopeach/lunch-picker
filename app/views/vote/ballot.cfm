<cfinclude template="/acre-services/lunch/poll_clock.cfm" />

<cfset ballot = LUNCH.getBallot(SESSION.group_id) /> 

<cfif isDefined("SESSION.admin_group_id") and ballot.recordCount lt 2>
	<cflocation url="/acre-services/lunch/admin.cfm?section=manageMembers" addtoken="no"/>
</cfif> 

<cfform action="#CGI.SCRIPT_NAME#" method="post" preservedata="yes">
<table id="ballotTbl" cellspacing="20">
    <tr>
        <td>First Choice:</td>
        <td class="inputCell"><cfselect name="choice_1" query="ballot" value="id" display="name" /></td>
    </tr><tr>
        <td>Second Choice:</td>
        <td class="inputCell"><cfselect name="choice_2" query="ballot" value="id" display="name" /></td>
    </tr><tr>
        <td>Third Choice:</td>
        <td class="inputCell"><cfselect name="choice_3" query="ballot" value="id" display="name" /></td>
    </tr><tr>
        <td colspan="2" style="text-align:center"><cfinput type="image" src="/acre-services/resourceImages/vote_btn.png" value="VOTE" name="submitted"/></td>
    </tr>
</table>
<cfinput type="hidden" src="/acre-services/resourceImages/vote_btn.png" value="yaysubmit" name="submitted"/>
</cfform>