<style>
	h4 {margin:15px 0px 5px}
</style>

<cfoutput>
<cfform action="#CGI.SCRIPT_NAME#" method="post">

<h1>Create a GLCC Group</h1>

<cfif isDefined("FORM.submitted")>
	<cfif FORM.captcha is not SESSION.lastCaptcha>
    	<div class="message error">The word you typed was incorrect</div>
    <cfelse>
		<cfset result = LUNCH.createGroup(FORM.email, FORM.group_name) />
        <cfif not result.success>
            <div class="message error">#result.message#</div>
        
        </cfif>
    </cfif>
</cfif>

<cfif isDefined("FORM.submitted") and result.success>
     <h2>Please check your email.</h2>
<cfelse>

    <h4>Lunch Secretary's (Your) Email Address</h4>
    <cfinput type="text" name="email" maxlength="128" style="width:300px" class="formInput"/>
    
    <h4>Lunch Group's Name</h4>
    <cfinput type="text" name="group_name" maxlength="128" style="width:300px"  class="formInput" />
    
    <h4>Type This Word</h4>
   
    <cfinput type="text" name="captcha"  style="width:300px"  class="formInput"/>
    <br/><br/>
    <cfset UDF.printCaptcha() />
    <br/><br/>
    <cfinput type="image" src="/acre-services/resourceImages/save_btn.png" value="VOTE" name="submitted"/>
    <cfinput type="hidden" value="yaysubmit" name="submitted"/>
</cfif>

<br/><br/><br/>
</cfform>
</cfoutput>