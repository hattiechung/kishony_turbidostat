function send_text_from_kishony_turbidostat(number, title, message)

    % Send text message
    mail = 'kishonyturbidostat@gmail.com'; 
    password = 'Cheese907'; 
    setpref('Internet','E_mail',mail);
    setpref('Internet','SMTP_Username',mail);
    setpref('Internet','SMTP_Password',password);
    props = java.lang.System.getProperties;
    props.setProperty('mail.smtp.auth','true');
    props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
    props.setProperty('mail.smtp.socketFactory.port','465');

    % Send the email. Note that the first input is the address you are sending the email to
    sendmailto = strcat(number, '@tmomail.net'); 
%     sendmailto = strcat(number, '@gmail.com'); 
    sendmail(sendmailto,title,message); 
end