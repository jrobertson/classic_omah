# Introducing the Classic_omah gem

    require 'classic_omah'

    mail = {
            user_name: 'james', 
            address: 'mail.jamesrobertson.eu',
            password: 'secret'
           }

    comah = ClassicOmah.new mail: mail
    comah.fetch_email

The above example demonstrates how I fetch the email from my email server. Classic_omah does the following:

1. connects to your email server using the Mail gem
2. retrieves all messages in the inbox
3. stores the messages in a file directory called *email*
4. deletes all messages from the inbox


## Resources

* ?classic_omah https://rubygems.org/gems/classic_omah?
* ?Omah 0.3.0 can now save message attachments http://www.jamesrobertson.eu/snippets/2015/may/22/omah-0-3-0-can-now-save-message-attachments.html?

email classicomah gem mail
