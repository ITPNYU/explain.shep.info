require './app'
require 'net/imap'
require 'mail'
require 'net/smtp'

imap = Net::IMAP.new('imap.gmail.com', ssl: true)
# LOGIN
imap.login(ENV['GMAIL_ADDRESS'], ENV['GMAIL_PASSWORD'])
# Open up the inbox
imap.select("INBOX")

# Get message IDs for unread mail.
unread = imap.search(["NOT","SEEN"])

explain_ids = imap.search(["SUBJECT","explain"])

explain_ids.each do |id|
  envelope = imap.fetch(id, "ENVELOPE")[0].attr["ENVELOPE"]
  body = imap.fetch(id, "BODY[TEXT]")[0].attr["BODY[TEXT]"]
  mail = Mail.new(imap.uid_fetch(2200, "RFC822")[0].attr["RFC822"])
  # Doesn't detect for signature.
  content = mail.body.parts().first.to_s.match(/Content-ID: <.*?>..(.*)/m)[1]
end
