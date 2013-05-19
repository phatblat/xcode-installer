command :'download' do |c|
  c.syntax = 'xcodedl download'
  c.summary = 'Initiates the download'
  c.description = ''

  c.action do |args, options|
    try{agent.download}
  end
end
