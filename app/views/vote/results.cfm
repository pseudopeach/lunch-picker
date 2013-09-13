<cfoutput> 

<cfif isDefined("URL.purgeVoter") or isDefined("URL.unpurgeVoter")>
	<cfif isDefined("URL.purgeVoter")>
        <cfset result = LUNCH.purgeVotes(URL.purgeVoter) />
    <cfelse> 
        <cfset result = LUNCH.unpurgeVotes(URL.unpurgeVoter) />
    </cfif>
    <cfif not result.success>
    	<div class="message error">#result.message#</div>
    </cfif>
</cfif>

<cfset election = LUNCH.runElection(SESSION.group_id) />
<cfif isDefined("SESSION.admin_group_id") and election.potential_count is 1>
	<cflocation url="/acre-services/lunch/admin.cfm?section=manageMembers" addtoken="no"/>
</cfif>

<cfinclude template="/acre-services/lunch/poll_clock.cfm" />
<a href="#cgi.SCRIPT_NAME#" class="actionLink" style="float:right">refresh</a><br/>
<cfif not poll_info.polls_are_open or (election.voterList.recordCount is election.potential_count)>
    <h2>Results</h2>
    <div>
    
    <cfif not election.success>
        <h4>[No results for today]</h4>
    <cfelse>
        <table>
        
        <cfloop query="election.tally" endrow="3">
            <tr>
            
            <td class="placeName">
                <cfif currentRow is 1><b></cfif>
                #election.tally.place_name#
                <cfif currentRow is 1></b></cfif>
            </td>
            <td>#election.tally.score#</td>
            </tr>
        </cfloop>
        </table>
        </div>
    </cfif>
    <cfif election.tally.recordCount gt 0 and LUNCH.getHistoryItem(SESSION.group_id) is "">
    	<cfset LUNCH.setHistoryItem(election.tally.place_id[1], SESSION.group_id) />
    </cfif>
</cfif>

<h3>
	Voters 
	#election.voterList.recordCount# / #election.potential_count# 
    (#round(100 * election.voterList.recordCount / election.potential_count)#%)
</h3>
<div>
<ul>
<table>
<cfloop query="election.voterLIst">
    <tr>
    <td class="placeName">
        #election.voterList.voter#
    </td>
    <td>
    	<cfif isDefined("SESSION.admin_group_id")>
        	<cfif election.voterList.purged is 0>
            	<a href="#cgi.SCRIPT_NAME#?purgeVoter=#election.voterList.voter_id#" class="actionLink">purge</a>
            <cfelse>
            	<a href="#cgi.SCRIPT_NAME#?unpurgeVoter=#election.voterList.voter_id#" class="actionLink"><b>un-purge</b></a>
            </cfif>
        <cfelse>
        	<cfif election.voterList.purged is not 0>[purged]</cfif>
        </cfif>
    </td>
    </tr>
</cfloop>
</table>
</ul>
</div>


</cfoutput>

