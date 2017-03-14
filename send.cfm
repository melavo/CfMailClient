<!---
	Create temporary attachment upload 
	If attachment field has content, then create folder using hashed username.
	Following this, you have to upload file to server, saving server path as attachment path for mail method.
--->
<cfset MAIL_ATTACH = "" />
<cfset hasAttachment = false />
<cfif isdefined("form.mail_attach") and trim(form.mail_attach) neq "">
	<cfset hasAttachment = true />
	<cfset attachPath = ExpandPath("./outbox/#hash(session.username)#/") />
	<cftry>
		<cfdirectory action="create" directory="#attachPath#" />
		<cfcatch><!--- supress errors to client ---></cfcatch>
	</cftry>
	<!--- use separate try/catch as failure in create could be because already exists --->
	<cftry>
		<cffile filefield="mail_attach" action="upload" nameconflict="makeunique" destination="#attachPath#" />
		<cfset MAIL_ATTACH = attachPath & "\" & cffile.serverFile />
		<cfcatch><!--- supress errors to client ---></cfcatch>
	</cftry>
</cfif>

<cfscript>
	MAIL_BODY = "";
	MAIL_SRVR = session.defaultserver;
	MAIL_TO = "";
	MAIL_FROM = session.username;	
	MAIL_CC = "";
	MAIL_BCC = "";
	MAIL_SUBJ = "";
	
	// repopulate mail fields if form data content exists for parameter
	if(isdefined("form.mail_to")) { MAIL_TO = trim(form.mail_to); }
	if(isdefined("form.mail_cc")) { MAIL_CC = trim(form.mail_cc); }
	if(isdefined("form.mail_bcc")) { MAIL_BCC = trim(form.mail_bcc); }
	if(isdefined("form.mail_subject")) { MAIL_SUBJ = trim(form.mail_subject); }
	if(isdefined("form.mail_body")) { MAIL_BODY = trim(form.mail_body); }

	// instantiate PostMaster component, then send message.
	if( (MAIL_TO neq "") and (MAIL_SRVR neq "") and (MAIL_FROM neq "") ) {
		postmaster = createObject("component", "includes.PostMaster");
		postsuccess = 
			postmaster.deliverMail( 
				MAIL_BODY, 
				MAIL_SRVR, 
				MAIL_TO,
				MAIL_FROM,
				MAIL_CC,
				MAIL_BCC,
				MAIL_SUBJ,
				MAIL_ATTACH
			);
		if(postsuccess) { sent = true; }
	}
</cfscript>

<!--- manipulate file system to cleanup temporary attachment uploads --->
<cfif isdefined("sent") and hasAttachment>
	<cftry>
  		<cffile action="delete" file="#MAIL_ATTACH#"/>
	  	<cfdirectory action="delete" directory="#attachPath#"/>
		<cfcatch><!--- supress errors from user ---></cfcatch>
	</cftry>
</cfif>