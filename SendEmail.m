%%% sending email code :)

setpref('Internet', 'E_mail', 'jjguan1996@gmail.com');
setpref('Internet', 'SMTP_Username', 'jjguan1996@gmail.com');
setpref('Internet', 'SMTP_Password', 'Holly2534');
setpref('Internet', 'SMTP_Server', 'smtp.gmail.com');
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port', '465');

% sendmail(emailto,subject,message,attachment) 
sendmail('jiajingguan@gmail.com', 'Mail from MATLAB','Code done!')

%%%
% for atteachment  {'sub_folder/signals.m', 'system.mdl'}