<cfinclude template="styles.cfm">
<cfinclude template="includes/header.cfm">
<br>
<strong>View Message:</strong> <cfoutput>#url.msgnumber#</cfoutput><br>
<br>
<cfscript>
function pformat(str)
{
str = replace(str,chr(13)&chr(10),chr(10),"ALL");
str = replace(str,chr(13),chr(10),"ALL");
str = replace(str,chr(9),"&nbsp;&nbsp;&nbsp;","ALL");
return replace(str,chr(10),"<br>","ALL");
}
    </cfscript>
    
<!---
We have to define a few variables for the attachments
we will create a directory named with the user name
if it doesn't already exsist, cfpop will create.
--->
<cfset baseDirectory = "./mailbox/" />
<cfset session.Directory = "#hash(session.username)#">
<cfset session.AttachDir = ExpandPath(baseDirectory) & "#session.Directory#">
<cfset TAB = Chr(9)>
<!---
Get the full message from the server
I dont create unique file names because we don't put all the files into the same directory
thus we can leave the file names as they were originally sent
--->
<cfpop action="GETALL"
          messagenumber="#url.msgnumber#"
          name="qGetMessageDetails"
          username="#session.username#"
          password="#decrypt(session.userpass, session.username)#"
          server="#session.defaultserver#"
          attachmentpath="#session.AttachDir#"
          generateuniquefilenames="no">

<table width="100%" border="0" cellpadding="3" cellspacing="0" class="headerbackground">
  <tr>
    <td width="30%" height="15">&nbsp;
    </td>
    <td width="40%" align="center" height="15">
    </td>
    <td width="30%" colspan="2" align="right" height="15">&nbsp;
    </td>
  </tr>
</table>
<br>

<cfoutput query="qGetMessageDetails">
  <table width="70%" border="0" align="center">
    <tr>
      <td colspan="2">

        <table width="200" border="0">
          <tr>
            <td valign="top">
              <a href="compose.cfm?action=reply&msgnumber=#msgnumber#">Reply</a>
            </td>
            <td valign="top">
              <a href="compose.cfm?action=forward&msgnumber=#msgnumber#">Forward</a>
            </td>
            <td valign="top">
              <a href="inbox.cfm?action=delete&msgnumber=#msgnumber#">Delete</a>
            </td>
          </tr>
        </table>
      </td>
    </tr>

    <tr>
      <td>
        <font size="2" face="Arial">
          <b>From:</b> #from#<BR>
          <b>Date:</b> #date#<BR>
          <b>Subject:</b> #subject#<BR>
        </font>
      </td>
    </tr>

    <tr>
      <td colspan="2">
        <hr noshade>
        <font size="2" face="Arial">
          <b>Message:</b><BR>

          #pformat(body)#
        <BR>
        <BR>

<!---
look for attachments,
if they exsist, download them to the directory we created
then display them as links
if they don't exsist, do nothing
--->
<cfset session.NumAttachments = ListLen(qGetMessageDetails.Attachments, TAB)>
<cfif session.NumAttachments GTE 1>
  <hr noshade color="##000000">
  <b>Attachments:</b><br>
  <cfloop from="1" to="#session.NumAttachments#" index="i">
    <cfset session.ThisFileOrig = ListGetAt(qGetMessageDetails.Attachments, i, TAB)>
    <cfset session.ThisFilePath = ListGetAt(qGetMessageDetails.Attachments, i, TAB)>
    <cfset session.ThisFileURL = baseDirectory & "#session.Directory#/#GetFileFromPath(session.ThisFilePath)#">
      <cfoutput><a href="#session.ThisFileURL#" target="_blank">#session.ThisFilePath#</a></cfoutput><br>
  </cfloop>
<BR>
</cfif>

        <table width="200" border="0">
          <tr>
            <td valign="top">
              <a href="compose.cfm?action=reply&msgnumber=#msgnumber#">Reply</a>
            </td>
            <td valign="top">
              <a href="compose.cfm?action=forward&msgnumber=#msgnumber#">Forward</a>
            </td>
            <td valign="top">
              <a href="inbox.cfm?action=delete&msgnumber=#msgnumber#">Delete</a>
            </td>
          </tr>
        </table>

      </td>
    </tr>
  </table>
</cfoutput>
<cfinclude template="includes/footer.cfm">