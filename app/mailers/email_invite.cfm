<cfoutput>
<cfmail from="lunch@apptinic.com" to="#to_email#" subject="Invitation to #group_name#" type="html">
<html>
<title>Lunch Club Voter Invitation</title>
<body style="margin-top:0;margin-bottom:0;margin-right:0;margin-left:0;padding-top:0;padding-bottom:0;padding-right:0;padding-left:0; font-family:Georgia, 'Times New Roman', Times, serif;">

<!-- Start Main Table -->
<table width="100%" height="100%"  cellpadding="0" cellspacing="0" style="padding: 20px 0px 20px 0px" bgcolor="##ececec">
	<tr align="center">
		<td>
				
				
			<table cellpadding="0" cellspacing="0"  width="562"  bgcolor="##202020"> <!-- Start Ribbon -->
            	<tr>
				<td width="300" height="203" bgcolor="##abd40a" style="font-family: Georgia, 'Times New Roman', Times, serif; padding: 10px 25px 0px 15px; font-size: 14px; color:##505050;" >
					                 <span style="font-size: 30px; font-weight: bold;">Vote in the Lunch Election</span><br><br>
					                      <span style="font-weight: bold; width: 525px;">
<!---content--->
Hello you,<br/>
Lunch secretary #admin_email# has invited to vote a lunch election. The link below will take you to your ballot.
<!--- END content --->
</span><br><br/>
										<a href="http://actinicapps.com/acre-services/lunch?key=#key#" style="display:block; color:##ffffff"><img src="http://actinicapps.com/acre-services/resourceImages/vote_btn.png" width="163" height="68" alt="Vote" border="0"></a>
								</td>
						</tr>
				</table>
			</td>
		</tr>
</table>

</body>
</html>
</cfmail>
</cfoutput>