Gem::Specification.new do |s|
  s.name = 'classic_omah'
  s.version = '0.3.0'
  s.summary = 'Mail gem + Omah (Offline Mail Helper) gem'
  s.authors = ['James Robertson']
  s.files = Dir['lib/classic_omah.rb']
  s.add_runtime_dependency('omah', '~> 0.9', '>=0.9.1')
  s.add_runtime_dependency('mail', '~> 2.7', '>=2.7.0')
  s.signing_key = '../privatekeys/classic_omah.pem'
  s.cert_chain  = ['gem-public_cert.pem']
  s.license = 'MIT'
  s.email = 'james@jamesrobertson.eu'
  s.homepage = 'https://github.com/jrobertson/classic_omah'
end
