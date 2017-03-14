<cfcomponent 
	name="PostMaster" 
	displayname="CF-Mail Mail Broker Component" 
	hint="Mail Component">

	<!---
		deliverMail()
			MAIL_BODY string holding mail content
			MAIL_SRVR string holding pop/smtp server name or IP
			MAIL_TO string holding the recipient(s) of e-mail
			MAIL_FROM string holding sender e-mail address
			MAIL_CC string holding carbon copied recipient(s)
			MAIL_BCC string holding blind copied recipient(s)
			MAIL_SUBJ string holding subject for mail message
			MAIL_ATTACH string holding path to file to attach
			
			returns boolean flag indicating success or failure
	--->
	<cffunction 
		name="deliverMail" 
		access="public" 
		output="false" 
		returntype="boolean">
		<!--- function parameters --->
		<cfargument name="MAIL_BODY" type="string" required="true"/>
		<cfargument name="MAIL_SRVR" type="string" required="true"/>
		<cfargument name="MAIL_TO" type="string" required="true"/>
		<cfargument name="MAIL_FROM" type="string" required="true"/>
		<cfargument name="MAIL_CC" type="string" required="false" default=""/>
		<cfargument name="MAIL_BCC" type="string" required="false" default=""/>
		<cfargument name="MAIL_SUBJ" type="string" required="false" 
			default="[No Specific Subject Specified]"/>
		<cfargument name="MAIL_ATTACH" type="string" required="false" default=""/>
		<!--- /function parameters --->
		<cftry>
		<CFMAIL to="#ARGUMENTS.MAIL_TO#" from="#ARGUMENTS.MAIL_FROM#" 
			cc="#ARGUMENTS.MAIL_CC#" bcc="#ARGUMENTS.MAIL_BCC#" 
			subject="#ARGUMENTS.MAIL_SUBJ#" server="#ARGUMENTS.MAIL_SRVR#">

			#ARGUMENTS.MAIL_BODY#

			---------------------
			Mailed Using CF-Mail:	#DateFormat(Now(), "dddd, mmmm dd, yyyy")#	
			
			<cfif trim(ARGUMENTS.MAIL_ATTACH) neq "" and FileExists(ARGUMENTS.MAIL_ATTACH)>
				<cfmailparam file="#ARGUMENTS.MAIL_ATTACH#" />
			</cfif>
		</CFMAIL>
		<cfreturn true/>
		<cfcatch type="any">
			<cfreturn false/>	
		</cfcatch>
		</cftry>	
	</cffunction>
</cfcomponent>