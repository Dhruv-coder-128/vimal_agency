package com.vimal.utils;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class MailSender {

    // Mail Details
    private static final String SENDER_EMAIL = System.getenv("SMTP_USER");
    private static final String APP_PASSWORD = System.getenv("SMTP_PASSWORD");

    public static boolean sendInvoiceMail(String toEmail, String orderId, String customerName) {
        
        // SMTP Server Setting
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", System.getenv("SMTP_HOST"));
        props.put("mail.smtp.port", System.getenv("SMTP_PORT"));

        // Create a mail session with authentication
        Session session = Session.getInstance(props, new javax.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(SENDER_EMAIL, APP_PASSWORD);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(SENDER_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            
            // Mail subject
            message.setSubject("Order Confirmed! #VML-" + orderId + " | Vimal Agency");

            // Mail content
            String content = "Hello " + customerName + ",\n\n"
                    + "Your order #VML-" + orderId + " has been successfully confirmed at Vimal Agency.\n"
                    + "You can download your tax invoice from your account history.\n\n"
                    + "Thank you for business with us!\n"
                    + "Team Vimal Agency";
            
            message.setText(content);

            // Send the email
            Transport.send(message);
            return true;
            
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
}