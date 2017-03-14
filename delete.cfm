<!--- delete the message specified --->
<cfpop action="DELETE"
          server="#session.defaultserver#"
          username="#session.username#"
          password="#decrypt(session.userpass, session.username)#"
          messagenumber="#msgnumber#">
<cfset delete = "true"> 