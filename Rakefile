require 'bundler'
Bundler.require
require 'net/imap'
require './models'

namespace :db do
  task :reset do
    DataMapper.auto_migrate!
  end
end

# http://railstips.org/blog/archives/2008/10/27/using-gmail-with-imap-to-receive-email-in-rails/

task :get_messages do
  imap = Net::IMAP.new('imap.gmail.com', ssl: true)
  # LOGIN
  imap.login(ENV['GMAIL_ADDRESS'], ENV['GMAIL_PASSWORD'])
  # Open up the inbox
  imap.select("INBOX")

  # Find uids for messages that have "explain" in the subject. UIDs are unique
  # to the message itself and always refer to the same email.
  # Not sure how net/imap handles search, but so far it's working well.
  explain_uids = imap.uid_search(["SUBJECT","explain"])

  explain_uids.each do |uid|
    # envelope = imap.fetch(id, "ENVELOPE")[0].attr["ENVELOPE"]
    # body = imap.fetch(id, "BODY[TEXT]")[0].attr["BODY[TEXT]"]
    msg = imap.uid_fetch(uid, "RFC822")[0].attr["RFC822"]
    # mail = Mail.new(imap.uid_fetch(id, "RFC822")[0].attr["RFC822"])
    mail = Mail.read_from_string(msg)
    # Get a cleaned body from the email.
    content = mail.body.parts().first.to_s.match(/Content-ID: <.*?>..(.*)/m)[1]

    # Create a new Email model.
    new_mail = Email.new
    new_mail.from = mail.from
    new_mail.subject = mail.subject
    new_mail.date = mail.date
    new_mail.body = content
    new_mail.message_id = uid
    # Automatically approve the email unless Preapprove is set.
    new_mail.approved = true unless ENV['PREAPPROVE']
    puts new_mail.save
    # Archive the mail. Move it out of the inbox so it doesn't get looked at again.
    imap.uid_copy(uid, "[Gmail]/All Mail")
    imap.uid_store(uid, "+FLAGS", [:Deleted])
  end
end

desc "sends an email"
task :send_email do
  # Configure Mail to send a message
  Mail.defaults do
    delivery_method :smtp, {
      :address              => "smtp.gmail.com",
      :port                 => 587,
      :domain               => 'explain.shep.info',
      :user_name            => ENV['GMAIL_ADDRESS'],
      :password             => ENV['GMAIL_PASSWORD'],
      :authentication       => 'plain',
      :enable_starttls_auto => true  }
  end

  # Get all emails that are approved but have not yet already been sent out.
  @unsent_approved = Email.all(conditions: { approved: true, sent: false || nil }, order: [:date.asc])

  # See if these emails meet the conditions to send out a digest.

  if @unsent_approved.nil? || @unsent_approved.length == 0
    puts "No emails"
  # If there are 3+ emails to check or the oldest one is more than 48 hours old
  elsif @unsent_approved.length >= 3 || (Time.now - @unsent.first.date.to_time) >= 172800

    digest = construct_digest(@unsent_approved)

    Mail.deliver do
      to 'sklise@gmail.com'
      from ENV['GMAIL_ADDRESS']
      subject "[Please Explain] Digest for #{Date.today}"
      body digest
    end
  else
    puts "#{Time.now} - less than 3 or riper than 2 days of emails."
  end
end

# Public: Take an array of questions and put them together into a form email to
# be sent to The List.
#
# emails - an array of Email objects
#
# Returns a long string consisting of the body of an email digest.
def construct_digest(emails)
  preamble = ""
  if emails.length == 1
    preamble += "Here are a few questions from some of your classmates"
  else
    preamble += "Here is a question from one of your classmates"
  end

  digest = <<-OYEZ
#{preamble} needing explanation.

If you'd be so kind as to reply to this email, we'll sleep better and I'll stop chewing the furniture.
  OYEZ

  emails.each_with_index do |email, index|
    digest += "    #{index + 1}. #{email.body}\n\n"
    email.update(sent:true)
  end

  digest += <<-OYEZ
Thank you.

If there's something here on the List, at ITP, in New York or just anything that you don't understand, you can ask for an explanation by sending an email to #{ENV['GMAIL_ADDRESS']} with "explain" in the subject line.

**YOUR EMAIL ADDRESS WILL NOT BE DISCLOSED TO OTHER STUDENTS, HOWEVER MIDORI AND CLAY ARE ABLE TO SEE WHO ASKED WHAT QUESTION -- TO PREVENT ABSUE.**

**BE SURE TO REMOVE YOUR SIGNATURE FROM THE EMAIL.**
  OYEZ

  digest
end