<!-- Application.Cfm Start -->

<cfapplication 
                             name="WellMailClient" 
							 sessionmanagement="yes" 
							 sessiontimeout="#CreateTimeSpan(0,0,10,0)#">
							 
<!------------------------------------------------------------------------------------------------------------------------------------
Here we will define some of our variables.  Read the name of the variable to determine what it is
used for
------------------------------------------------------------------------------------------------------------------------------------->

<!------------------------------------------------------------------------------------------------------------------------------------
Here we will set the message to the user if they incorrectly specify a password
------------------------------------------------------------------------------------------------------------------------------------->
<cfset errormessage = "Invalid UserName Or Password Please Try Again.  Thank You!">

<!------------------------------------------------------------------------------------------------------------------------------------
Here you must type yes or not to allow the user to choose a template color!

If yes is choose the user will beable to select from various colors of templates that we have
created.

If no is choosen then the user will never see this and they will see the default template color of
silver!
------------------------------------------------------------------------------------------------------------------------------------->

<cfset choosecolor = "No">

<!------------------------------------------------------------------------------------------------------------------------------------
Here you will choose wheather you want the user to beable to enter a server to check email on
or if they must be on your server

You will also enter the default server here too!
------------------------------------------------------------------------------------------------------------------------------------->

<cfset chooseserver = "Yes">

<cfparam name="session.defaultserver" default="mail.coldfusionzone.com">
<cfset defaultpostmaster = "cybercom">

<!------------------------------------------------------------------------------------------------------------------------------------
Here you will enter the colors for the alternating rows.  This is what will seperate each header
in your imbox.

Row1 = color1
Row2 = color2
Row3 = color1
Row4 = color2
------------------------------------------------------------------------------------------------------------------------------------->

<cfset row1color = "EEEEEE">
<cfset row2color = "FFFFFF">
							 
<!------------------------------------------------------------------------------------------------------------------------------------
Here we set the site title
------------------------------------------------------------------------------------------------------------------------------------>

<cfset apptitle = "Mail Client">
							 
<!--------------------------------------------------------------------------------------------------------------------------------------
Here we will check and see if the user has defined any of the specific variables if so then we perform
those functions otherwise we continue on with the processing.  Putting this inside of the application
instead of the index.cfm creates a much cleaner templating system and allows you to logout from
any template besides index.cfm
--------------------------------------------------------------------------------------------------------------------------------------->

<!-------------------------------------------------------------------------------------------------------------------------------------
Here we check to see if the user is ready to logout using a variable called logout
-------------------------------------------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------------------------------------------
If the user has logged out, we clear the session variables
 -------------------------------------------------------------------------------------------------------------------------------------->

<cfif IsDefined("logout")>
  <cfif IsDefined("session.AttachDir")>
	  <!--- 
	  	If attach directory is defined, gather all the files in directory and delete.
	  	Then delete folder itself.  Must do this since most servers won't let you delete non-empty folder.
	  	Have to do this recursively later if possible to have folder in folder.
	  		Assuming all files below attach directory at this point.
	  --->
	  <cftry>
		  <cfdirectory action="list" directory="#session.AttachDir#" name="attachDir"/>
		  <cfloop query="attachDir">
		  		<cffile action="delete" file="#session.AttachDir#\#name#"/>
		  </cfloop>
		  <cfdirectory action="delete" directory="#session.AttachDir#"/>
	  <cfcatch><!--- supress errors from user ---></cfcatch>
	  </cftry>
  </cfif>
  <cfscript>
 StructClear(Session);
  </cfscript>
  <!------------------------------------------------------------------------------------------------------------------------------------
  Here is where we do a double check.  We check to see if the user wants to login as a different user
  only if a cookie is actually defined.  Otherwise we must continue
  ------------------------------------------------------------------------------------------------------------------------------------->
<!-------------------------------------------------------------------------------------------------------------------------------------
if the cookie was set and the user wants to sign in as someone else, we clear the cookie 
-------------------------------------------------------------------------------------------------------------------------------------->

<cfelseif IsDefined("newuser")>
  <cfcookie name="username" expires="now">
  <cfscript>
    StructClear(Cookie);
  </cfscript>
</cfif>

<!-------------------------------------------------------------------------------------------------------------------------------------
Now we continue on with normal client processing.  We have done what we need to do inside of
application.cfm for now
-------------------------------------------------------------------------------------------------------------------------------------->

<!-- End Application.cfm -->