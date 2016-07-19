Gem::Specification.new do |s|
  s.name = 'classic_omah'
  s.version = '0.2.2'
  s.summary = 'Mail gem + Omah (Offline Mail Helper) gem'
  s.authors = ['James Robertson']
  s.files = Dir['lib/classic_omah.rb']
  s.add_runtime_dependency('omah', '~> 0.7', '>=0.7.0')
  s.add_runtime_dependency('mail', '~> 2.6', '>=2.6.3')
  s.signing_key = '../privatekeys/classic_omah.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@r0bertson.co.uk'
  s.homepage = 'https://github.com/jrobertson/classic_omah'
end
