#!/usr/bin/env ruby

# file: classic_omah.rb

require 'mail'
require 'omah'


class ClassicOmahException < Exception 
end

class ClassicOmah < Omah

  def initialize(user: 'user', filepath: '.', mail: {}, \
               email_address: nil, options: {xslt: 'listing.xsl'}, plugins: [])
        
    @mail = {    address: '',
                    port: 110,
               user_name: '',
                password: '',
              enable_ssl: false }.merge mail

    field = %i(address user_name password).detect {|x| @mail[x].to_s.empty?}

    raise ClassicOmahException, "missing %s" % field if field        
    
    @variables = {user_name: @mail[:user_name] , \
                  address: @mail[:address], email_address: email_address}
    
    super(user: user, filepath: filepath, plugins: plugins, options: options)    
    
    
  end

  def fetch_email()
    
    mail = @mail
    Mail.defaults { retriever_method(:pop3, mail) }

    email = Mail.all

    return 'no new messages' unless email.any?

    messages = email.map.with_index.inject([]) do |r, x|
      
      msg, i = x

      begin
        r << {
          msg_id:     msg.message_id,
          from:       msg.from.is_a?(Array) ? msg.from.join(', ') : msg.from,
          to:         msg.to.is_a?(Array) ? msg.to.join(', ') : msg.to,
          subject:    msg.subject,
          date:       msg.date.to_s,
          body_text:  (msg.text_part ? msg.text_part.body.decoded : msg.body),
          body_html:  (msg.html_part ? msg.html_part.body.decoded : msg.body), 
          attachments: msg.attachments.map {|x| [x.filename, x.body.decoded] },
          raw_source: msg.raw_source
        }
      rescue
        puts 'warning: ' + ($!).inspect
      end
    r

    end
    
    # messages are stored in the file dynarexdaily.xml
    self.store messages

    Mail.delete_all

    messages.length.to_s + " new messages"
  end
end