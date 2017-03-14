<!------------------------------------------------------------------------------
	Quick utility to test the PostMaster Component.
	This page consumes the checkMailDelivery function of the component,
		which uses the deliverMail method to send a test e-mail to address passed.
------------------------------------------------------------------------------->
<font color="#aa0000">
<cfscript>
	if(isdefined("form.email") and trim(form.email) neq "") {
		/*
			component needs to be prefixed with folder structure
			e.g. 
				if it is moved to folder mail\util\PostMaster,
				object name is mail.util.PostMaster
			
			Note: for security reasons, most mail servers require either the send to or from address
				to be a valid mailbox on the mail server.  Can't be an alias, but an actual account.
		*/
		MAIL_BODY = "CF-Mail test e-mail!";
		MAIL_SRVR = session.defaultserver;
		MAIL_TO = trim(form.email);
		MAIL_FROM = defaultpostmaster;
		MAIL_CC = "";
		MAIL_BCC = "";
		MAIL_SUBJ = "CF-Mail Test";
		postmaster = createObject("component", "Includes.PostMaster");
		postsuccess = 
			postmaster.deliverMail( 
				MAIL_BODY, 
				MAIL_SRVR, 
				MAIL_TO,
				MAIL_FROM,
				MAIL_CC,
				MAIL_BCC,
				MAIL_SUBJ
			);
		if(postsuccess) {
			writeoutput("Mail message sent successfully!");
		} else {
			writeoutput("Error sending message, please try again!");		
		}
	}
</cfscript>
</font>
<cfform method="post">
	Enter e-mail address:<br/>
	<cfinput type="text" name="email" required="true" size="50"
		message="Please enter email first" maxsize="150" /><br/>
	<input type="submit" name="cmdProces" value="Send Test Mail Message!"/>
</cfform>