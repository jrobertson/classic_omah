#!/usr/bin/env ruby

# file: classic_omah.rb

require 'mail'
require 'omah'


class ClassicOmahException < Exception 
end

class ClassicOmah < Omah

  def initialize(user: 'user', filepath: '.', mail: {}, port: 110, 
                 email_address: nil, options: {xslt: 'listing.xsl'}, 
                 plugins: [], debug: false)
        
    puts 'inside ClassicOmah::initialize' if debug        
    
    @mail = {    address: '',
                    port: port,
               user_name: '',
                password: '',
              enable_ssl: false }.merge mail

    field = %i(address user_name password).detect {|x| @mail[x].to_s.empty?}

    raise ClassicOmahException, "missing %s" % field if field        
    
    @variables = {user_name: @mail[:user_name] , \
                  address: @mail[:address], email_address: email_address}
    
    super(user: user, filepath: filepath, plugins: plugins, 
          options: options, debug: debug)
    
    puts 'initialize ClassicOmah complete' if @debug
    
    
  end

  def fetch_email()
    
    puts 'inside fetch_email' if @debug
    mail = @mail
    puts 'mail: ' + mail.inspect if @debug
    
    Mail.defaults { retriever_method(:pop3, mail) }
    
    puts 'before Mail.all' if @debug
    email = Mail.all
    puts 'after Mail.all' if @debug

    return 'no new messages' unless email.any?
    
    puts 'before email.map' if @debug

    messages = email.map.with_index.inject([]) do |r, x|
      
      
      puts 'x: ' + x.inspect if @debug
            
      msg, i = x


      begin
        r << [x, {
          msg_id:     msg.message_id,
          from:       msg.from.is_a?(Array) ? msg.from.join(', ') : msg.from,
          to:         msg.to.is_a?(Array) ? msg.to.join(', ') : msg.to,
          subject:    msg.subject,
          date:       msg.date.to_s,
          body_text:  (msg.text_part ? msg.text_part.body.decoded : msg.body),
          body_html:  (msg.html_part ? msg.html_part.body.decoded : msg.body), 
          attachments: msg.attachments.map {|x| [x.filename, x.body.decoded] },
          raw_source: msg.raw_source
        }]
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
