#!/usr/bin/env ruby

# file: classic_omah.rb

require 'mail'
require 'omah'
require 'sps-pub'

class ClassicOmah

  def initialize(user: 'user', filepath: '.', mail: {}, sps: {})

    @user = user
    @mail = {    address: '',
                    port: 110,
               user_name: '',
                password: '',
              enable_ssl: false }.merge mail

    field = %i(address user_name password).detect {|x| @mail[x].empty?}
    return "ClassicOmah: missing %s" % field if field

    @sps = SPSPub.new(address: sps[:address], port: sps[:port]) if sps

    Dir.chdir filepath

  end

  def fetch_email()

    Mail.defaults { retriever_method :pop3, @mail }

    email = Mail.all
    return 'no new messages' unless email.any?

    messages = email.map.with_index.inject([]) do |r, x|

      msg, i = x

      begin
        r << {
          id:         msg.message_id,
          from:       msg.from.is_a?(Array) ? msg.from.join(', ') : msg.from,
          to:         msg.to.is_a?(Array) ? msg.to.join(', ') : msg.to,
          subject:    msg.subject,
          date:       msg.date.to_s,
          body_text:  (msg.text_part ? msg.text_part.body.decoded : msg.body),
          body_html:  (msg.html_part ? msg.html_part.body.decoded : msg.body), 
          attachments: msg.attachments.map {|x| [x.filename, x.body.decoded] }
        }
      rescue
        puts 'warning: ' + ($!).inspect
      end
    r

    end

    o = Omah.new user: @user

    # messages are stored to the file dynarexdaily.xml
    o.store messages

    if @sps then
      
      m = 'message'
      m += 's' if messages.length > 1
      @sps.notice "email/new/%s: received %s new %s" \
                                    % [@mail[:user_name], messages.length, m]
    end

    Mail.delete_all
  end
end
