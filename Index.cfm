<cfif IsDefined("session.username") and IsDefined("session.userpass")>

 <cflocation url="inbox.cfm" addtoken="no">

</cfif>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>

<head>

<!-------------------------------------------------------------------------------------------------------------------------------------
Your title is being called from Applicatoin.cfm, if you would like to change it please change it there
-------------------------------------------------------------------------------------------------------------------------------------->
<title>

<cfoutput>

#apptitle#

</cfoutput>

</title>

<!-------------------------------------------------------------------------------------------------------------------------------------
Here we have included a dynamic style sheet page with a .cfm extension.  This page is called styles
and for those of you who do not know css we have made it easy for you to update this page
-------------------------------------------------------------------------------------------------------------------------------------->

<cfinclude template="styles.cfm">

<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>

</head>

<!-------------------------------------------------------------------------------------------------------------------------------------
Remember everything is provided in styles.cfm so dont add any of those attributes to body
-------------------------------------------------------------------------------------------------------------------------------------->
<body>

<cfinclude template="includes/header.cfm">

<!------------------------------------------------------------------------------------------------------------------------------------- 
Our login form Starts Here
--------------------------------------------------------------------------------------------------------------------------------------->

<!-------------------------------------------------------------------------------------------------------------------------------------
Here is also our action to log the user in.  The default login script is inside of inbox.cfm
--------------------------------------------------------------------------------------------------------------------------------------->
<form action="inbox.cfm?login=try" method="post">

<table width="396" border="0" cellpadding="0" cellspacing="0" align="center">

<tr align="center" valign="middle">
  
<td height="37" colspan="3">

<cfif isdefined("error")>

<p class="style1">
  
<cfoutput>

#errormessage#

</cfoutput>
  
</p>
  
<cfelse>
  
<p>
  
</p>
  
</cfif>
  
<p>
  
Please Enter A Username And Password
  
</p>
  
<p>
  
</p>
  
</td>

</tr>

<tr>

<td width="198" height="50" align="right" valign="middle">

UserName:

</td>
	
<td width="9" rowspan="2" valign="top">

</td>
	
<td width="189" align="left" valign="middle">
	
<!-------------------------------------------------------------------------------------------------------------------------------------
Here is where we check to see if the user has a cookie variable defined, if they do then we must put
that value inside the text box, if it doesnt then we just show a plain text box
-------------------------------------------------------------------------------------------------------------------------------------->

<cfif  IsDefined("cookie.username")>
  
<input type="text" name="username" value="<cfoutput>#cookie.username#</cfoutput>"  class="forForms">

<!-------------------------------------------------------------------------------------------------------------------------------------
If the user doesnt have anything defined then we just show them a plain old login screen
nothing special
-------------------------------------------------------------------------------------------------------------------------------------->
  
<cfelse>
  
<input type="text" name="username" class="forForms">
  
</cfif>

</td>

</tr>

<tr>

<td height="48" align="right" valign="middle">

Password

</td>

<td align="left" valign="middle">

<input type="password" name="userpass" class="forForms">

</td>

</tr>

<cfif chooseserver is("yes")>

<tr align="center" valign="middle">

<td height="48" align="right" valign="middle">Server</td>
  
<td>

</td>

<td align="left" valign="middle"><input name="userserver" type="text" class="forForms" id="userserver">

</td>

</tr>

</cfif>

<tr align="center" valign="middle">

<td height="14" colspan="3" valign="top">
  
</td>
  
</tr>

<!--------------------------------------------------------------------------------------------------------------------------------------
Here we check to see if the administrator has told the application that is alright if the user chooses
a colored template.  If they are allowed then it will show a drop down box, if they are not allowed
then it will not show this and will use a default template!
--------------------------------------------------------------------------------------------------------------------------------------->

<cfif choosecolor is("yes")>
  
<tr align="center" valign="middle">

<td height="36" colspan="3" valign="top">

<select name="select" class="forForms">
      
</select>

</td>
  
</tr>

</cfif>

<tr align="center" valign="middle">

<td height="20" colspan="3" valign="top">

<input type="submit" name="Submit" value="Submit" class="forButton">

</td>
	
</tr>

<tr align="center" valign="middle">

<td height="47" colspan="3" valign="top">

<!------------------------------------------------------------------------------------------------------------------------------------
Here we check to see if the user has a cookie alredy again. If the user doesnt then they get the
check box, if they do then they get a message
------------------------------------------------------------------------------------------------------------------------------------->

<cfif NOT IsDefined("cookie.username")>
	        
<input type="checkbox" name="remember" value="indeed">
        
Remember ID on this Computer?
        
<cfelse>
        
Not 
        
<cfoutput>
        
#cookie.username#
        
<a href="index.cfm?newuser=true">
         
Login as a different user!
         
 </a>
         
</cfoutput>
		          
</cfif>

</td>

</tr>

</table>

</form>

<cfinclude template="includes/footer.cfm">

</body>

</html>