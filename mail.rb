require 'bundler'
Bundler.require
require 'net/imap'
require 'net/smtp'
require './models'

imap = Net::IMAP.new('imap.gmail.com', ssl: true)
# LOGIN
imap.login(ENV['GMAIL_ADDRESS'], ENV['GMAIL_PASSWORD'])
# Open up the inbox
imap.select("INBOX")

# Find ids for messages that have "explain" in the subject.
# Not sure how net/imap handles search, but so far it's working well.
explain_ids = imap.search(["SUBJECT","explain"])

explain_ids.each do |id|
  # envelope = imap.fetch(id, "ENVELOPE")[0].attr["ENVELOPE"]
  # body = imap.fetch(id, "BODY[TEXT]")[0].attr["BODY[TEXT]"]
  msg = imap.fetch(id, "RFC822")[0].attr["RFC822"]
  # mail = Mail.new(imap.uid_fetch(id, "RFC822")[0].attr["RFC822"])
  mail = Mail.read_from_string(msg)
  content = mail.body.parts().first.to_s.match(/Content-ID: <.*?>..(.*)/m)[1]

  new_mail = Email.new
  new_mail.from = mail.from
  new_mail.subject = mail.subject
  new_mail.date = mail.date
  new_mail.body = content
  new_mail.message_id = mail.message_id
  puts new_mail.save
end
