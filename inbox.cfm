<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
    <title>
    	<cfoutput>
    		#apptitle#
    	</cfoutput>
    </title>
    <cfinclude template="Styles.cfm">
</head>
   <body>
       <cfinclude template="Includes/header.cfm">
	   <!--- Here we will check to see if the admin has enabled
	   the ability for the user to define their own server
	   if they have then we will therefore set that server
	   --->

<!---
Some if/else statements to start us off here
First we find out if the user filled out the login form,
or if they were simply redirected because their session
was still valid.
--->   		
   	<cfif IsDefined("login")>  
	
	   <cfif chooseserver IS("yes")>
	   <cfif form.userserver is "">
	   <cflocation url="index.cfm?error=true">
	   <cfelse>
	   <cfset session.defaultserver = "#form.userserver#">
	   </cfif>
	   <cfelse>
	   <cfset session.defaultserver = "#session.defaultserver#">
	   </cfif> 	
	   	<!---
   		If the user did use the login form,
   		we check to make sure the user entered data,
   		if so, we set the form variables up as session variables for easy use
   		--->   			
   		<cfif IsDefined("form.userNAME") and #form.userPASS# is not "">   		    
   		    <cfset session.username = "#form.userNAME#">
   		    <!---
   		    	Encrypt password and store in session.
   		    	Simply encryption using built in CF function.
   		    	Requires SEED String that needs to be used in decryption.
   		    		Initial method uses username as SEED.
   		    --->
   		    <cfset session.userpass = "#encrypt(form.userPASS, form.userNAME)#"><!---
If they want us to remember there login info We'll set a cookie
otherwise we will set a cookie with the same name to expire now
that way there will deffinently be no cookies set on the users machine
--->   				
   			<cfif IsDefined("form.remember")>
   			    <cfcookie name="username" value="#form.userNAME#" expires="never">
   			<cfelse>
   			    <cfcookie name="username" expires="now">
   			</cfif>
   			<!---
   			If the user didn't use the login form OR they didn't enter valid information
   			Redirect them to the index screen with error set to true
   			--->
   		<cfelse>
   		    <cflocation url="index.cfm?error=true" addtoken="yes">
   		</cfif>
   	</cfif>
   	<!---
   	Here is where the sending and deleting includes come in
   	We check to see if an action is defined at all,
   	then we find out what that function is and include the appropriete file for that action
   	--->   		
   	<cfif isDefined("action")>   			
   		<cfif action is "send">
   		    <cfinclude template="send.cfm">
   		 <cfelseif action is "delete">
   		    <cfinclude template="delete.cfm">
   		</cfif>
   	</cfif>
   	<!---
   	This is where we retrieve the messages from the POP3 server
   	We've surrounded the CFPOP tag with a CFTRY statement
   	This is another way to check to be sure that the user entered valid data
   	if there are any errors thrown back at us we redirect the user to the login screen
   	this is what they are used to anyway right?
   	
   	Session username and password passed to cfpop tag; subsequently,
   		userpass must be decrypted first since we stored with encryption.
   	--->
       <cftry>
       <cfpop action="getheaderonly" name="qGetMessages" server="#session.defaultserver#" timeout="90" username="#session.username#" password="#decrypt(session.userpass, session.username)#">
       <cfcatch type="Any">
       <cfscript>
StructClear(Session);</cfscript>
       <cflocation url="index.cfm?error=true">
       <cfabort>
</cfcatch></cftry><!-------------------------------------------------------------------------------------------------------------
This is just a header,
I like to have an image here at the top,
you can of course put whatever you want here
-------------------------------------------------------------------------------------------------------------->
   	<table width="100%" border="0">
   	</table>
   	<table width="100%" border="0" cellpadding="3" cellspacing="0">
   		<tr>
   			<td width="44%" height="38">   			              Inbox   			                     &nbsp;&nbsp; You have :
   			              	<cfoutput>
   			              		#qGetMessages.RecordCount# Messages
   			              	</cfoutput>
   			</td>
   			<td width="20%" align="center">   			   
   			   <font size="2" face="Arial" color="red">   			              <!----------------------------------------------------------------------------------------------------------
   			              This is our conformation cell,
   			              if the user sent or deleted something,
   			              this is where we tell them
   			              Its just one of those user friendly kinda things
   			              ----------------------------------------------------------------------------------------------------------->   			       		
   			       	<cfif IsDefined("sent")>   			       		MESSAGE SENT   			       	
   			       	<cfelseif IsDefined("delete")>MESSAGE DELETED
   			       	</cfif>
</font>
   			</td>
   			<td width="36%" align="right" valign="middle">
   				<cfoutput>
   					Welcome : #session.username#
   				</cfoutput>
   			</td>
   		</tr>
   	</table>	<!-----------------------------------------------------------------------------------------------------
	This is our column headers, They are displayed regaurdless of weather or 
	not there are messages so there is really nothing all that special about them
	------------------------------------------------------------------------------------------------------>
   	<table width="100%" border="0" cellpadding="2" cellspacing="1">
   		<tr bgcolor="#efefef">
   			<td height="15" width="14%" colspan="2" class="headerbackground" valign="top">   			   
   			   <font size="1" face="Arial">   			              DATE</font>
   			</td>
   			<td width="20%" height="15" class="headerbackground" valign="middle">   			   
   			   <font size="1" face="Arial">   			              FROM</font>
   			</td>
   			<td width="40%" class="headerbackground">   			   
   			   <font size="1" face="Arial">   			              SUBJECT</font>
   			</td>
   			<td width="26%" colspan="2" align="center" class="headerbackground">   			   
   			   <font size="1" face="Arial">   			              ACTIONS</font>
   			</td>
   		</tr>	<!-------------------------------------------------------------------------------------------------------------------
	We wrap the whole thing in a form
	that way we can delete multiple messages all at once
	the checkboxes have a value that is equal to the message number
	when/if the form is submitted it only deletes those messages that have been checked
	how convenient right?
	------------------------------------------------------------------------------------------------------------------->   	      
   	   <form action="inbox.cfm?action=delete" method="post">   	   		
   	   	<cfif qGetMessages.RecordCount>
   	   		<cfoutput query="qGetMessages">
   	   			<!---
   	   			Alternating row colors
   	   			ooooooooo, ahhhhhh
   	   			--->
   	   			<tr bgcolor="###iif(currentrow MOD 2,DE('#row1color#'),DE('#row2color#'))#">
   	   				<td width="1%">
   	   				   <input name="msgnumber" type="checkbox" class="forForms" value="#qGetMessages.messagenumber#">
   	   				</td>
   	   				<td width="13%">   	   				   
   	   				   <font size="2" face="Arial"><!----------------------------------------------------------------------------------------------------------------
I used a regular expression to format the POP date
I know there are other ways to do it, this was just the simplest for me
---------------------------------------------------------------------------------------------------------------->

#reReplace(left(qGetMessages.date, 21), "^(.* ).*", "\1")#</font>
   	   				</td>
   	   				<td width="20%">   	   				   
   	   				   <font size="2" face="Arial">#qGetMessages.from#</font>
   	   				</td>
   	   				<td width="40%">   	   				   
   	   				   <font size="2" face="Arial">#qGetMessages.subject#</font>
   	   				</td>	<!------------------------------------------------------------------------------------------------------------
	These are our actions here, we can delete the message directly, or we can go 
	ahead and view and see what it says, then decide what to do from there
	------------------------------------------------------------------------------------------------------------>
   	   				<td width="8%" align="center"><a href="details.cfm?msgnumber=#qGetMessages.messagenumber#">
View
</a>
   	   				</td>
   	   				<td width="8%" align="center"><a href="inbox.cfm?action=delete&msgnumber=#qGetMessages.messagenumber#">
Delete
</a>
   	   				</td>
   	   		</cfoutput>
   	   		<tr>
   	   			<td height="17" width="100%" class="headerbackground" colspan="6">
   	   			</td>
   	   		</tr>
   	   		<tr>
   	   			<td colspan="6"><br/><br/>
   	   			   <input name="delete" type="submit" value="Delete Checked">
   	   			</td>
   	   		</tr>
   	</table>
</form>   <!---------------------------------------------------------------------------------------------------------------
   If there are no messages in the inbox we display this simple litle message telling 
   them so
   ---------------------------------------------------------------------------------------------------------------->
   <cfelse>
   	<tr bgcolor="#D7D7D7">
   		<td width="100%" colspan="6" align="center">   		   
   		   <font size="2" face="Arial">There are no messages in your inbox.</font>
   		</td>
   	</tr>
</table>
</cfif>
<br/><br/>
       <cfinclude template="Includes/footer.cfm">
   </body>
</html>
        <cfset session.username = "#session.username#">