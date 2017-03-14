<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title><cfoutput>#apptitle#</cfoutput></title>
	
<cfinclude template="styles.cfm">

<!-----------------------------------------------------------------------------------------
Here we only need to check for stuff on the server if the user has defined an action.
Other wise it will just skip this process and continue with normal client processing!

The reason we have it checking for those two variables it to prevent from any accidental
processing that is not needed!

If action is reply or foward then continue with this procedure otherwise keep on going!
------------------------------------------------------------------------------------------>

</head>

<body>

<cfinclude template="Includes/header.cfm">
<!--- set defaults for form fields --->
<cfset prefilltextarea = false />
<cfset emailTo = "" />
<cfset subject = ""/>
<!---
	Only if an action is defined do we grab the information off the server
	if not we just skip this step altogether
--->		
<cfif IsDefined("action")>
	<cfset act = lcase(trim(action)) /><!--- normalize action text for later use --->
    <cfpop action="GETALL" 
    	messagenumber="#url.msgnumber#" 
    	name="qGetMessageDetails" 
    	username="#session.username#" 
    	password="#decrypt(session.userpass,session.username)#" 
    	server="#session.defaultserver#">

	<cfset prefilltextarea = true />
    <cfif act is "reply">
    	<!--- change emailTo default for responses --->
    	<cfset emailTo = qGetMessageDetails.from />
    	<!--- change subject default for responses --->
		<cfset subject = "Re:" & qGetMessageDetails.subject />     	
    <cfelseif act is "forward">
		<!--- change subject default for forwards --->
    	<cfset subject = "Fwd:" & qGetMessageDetails.subject />
    </cfif> 
</cfif>
<br/><br/>
<!---
	We set the ENCTYPE to multipart/form-data
	This is REQUIRED if you plan to send attachments along with the email
	if you do not wish to add the attachment feature this setting is not required
	but it will not effect anything to leave it there, so I sugesst just leaving it as is
--->      
<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<cfform action="inbox.cfm" method="post" enctype="multipart/form-data">
		<!--DWLayoutTable-->
		<input type="hidden" name="action" value="send"/>
		  <tr>
		    <td width="12" rowspan="4" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
		    <td width="51" height="50" align="right" valign="middle">To:</td>
		    <td width="8" rowspan="5" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
		    <td colspan="5" valign="middle">
		    	<cfinput name="mail_to" type="text" value="#emailTo#" size="102"
		    		required="true" message="Mail to address required!"/>		    </td>
		    <td width="71">&nbsp;</td>
	      </tr>
		  <tr>
		    <td height="50" align="right" valign="middle">Cc:</td>
		    <td width="317" valign="middle">
		    	<cfinput name="mail_cc" type="text" size="40"/>
		    </td>
		    <td width="71" align="right" valign="middle">Bcc:</td>
		    <td colspan="3" valign="middle">
	    	<cfinput name="mail_bcc" type="text" size="40"/>		    </td>
		  <td>&nbsp;</td>
	      </tr>
		  <tr>
		    <td height="50" align="right" valign="middle">Subject:</td>
		    <td colspan="5" valign="middle">
	    	  <cfinput name="mail_subject" type="text" value="#subject#" size="102"/></td>
		  <td>&nbsp;</td>
		  </tr>
		  <tr>
		    <td height="50" align="right" valign="middle">Attach:</td>
		    <td colspan="5" valign="middle">
	    	  <input type="file" size="92" name="mail_attach"></td>
		    <td>&nbsp;</td>
	      </tr>
		  <tr>
		    <td height="537" align="right" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
			<td valign="top">Message:</td>
		    <td colspan="5" valign="top">
	    	  <cfif prefilltextarea>	    	 
			    <!---
					If prefill text area flag set, then input default textarea
					we use the CFPROCESSINGDIRECTIVE tag so that the CF software doesnt squish it all together
					thus leaving the original message in the form that it was sent in, with line breaks and everything
				--->   			
			    <cfprocessingdirective suppresswhitespace="no">
	   		    <textarea name="mail_body" cols="80" rows="15">
					<cfoutput>
-----Original Message-----
From: #qGetMessageDetails.from#
Sent: #qGetMessageDetails.date#
To: #qGetMessageDetails.to#
Subject: #qGetMessageDetails.subject#
#qGetMessageDetails.body#
				    </cfoutput>
	    		</textarea>
	    		</cfprocessingdirective>
	    	<cfelse>
	    		<textarea name="mail_body" cols="80" rows="15"></textarea>
		  	      </cfif>		   	</td>
		    <td>&nbsp;</td>
	      </tr>
		  <tr>
		    <td height="37" colspan="6" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
		    <td width="82" align="center" valign="middle"><input name="Submit" type="submit" value="Submit"></td>
		    <td colspan="2" valign="top"><!--DWLayoutEmptyCell-->&nbsp;</td>
		  </tr>
		  <tr>
		    <td height="0"></td>
		    <td></td>
		    <td></td>
		    <td></td>
		    <td></td>
		    <td></td>
		    <td></td>
		    <td width="350"></td>
		    <td></td>
      </tr>
		  <tr>
		    <td height="1"></td>
		    <td></td>
		    <td></td>
		    <td></td>
		    <td></td>
		    <td width="50"></td>
		    <td></td>
		    <td></td>
		    <td></td>
      </tr>
  	</cfform>
</table>
</body>
</html>

