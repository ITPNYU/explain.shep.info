Explain.shep.info is designed to let mailing list subscribers send confidential questions about content FROM a particular mailing list back TO that mailing list, with a request for explanation.

## Scenario:

1. User KnowItAll sends a mail to the list saying "AFAIC, this idea is a CWOT. FWIW, TANSTAAFL. (YMMV.) L8R D00D3Z."

2. This message is distributed to all the recipients of the list. User IJustGotHere reads this message and says to himself "zomg wtf do all those acronyms mean!"

3. User IJustGotHere then forwards the message to shep@shep.info, adding "[explain]" to the subject line.

4. When shep@shep.info receives a message with "[explain]" in the subject, it checks that the sender is valid, then records the email (and all headers) and puts the body of the message in a database.

    (The admin can toggle between manual and automated for step #5 or #6.)

5. Manual: When the explain.shep admin logs in, shep displays messages that do not yet have SENT flags, along with the senders name and email, and presents them to the admin in a list. The admin can UNCHECK mail that SHOULD NOT be sent, then bundle them in a single message.

6. Automated: Shep periodically queries the db, looking for messages without SENT flags. When there are N or more such messages (N >= 3, at this point) or H hours have passed after the message was delivered (H == 48 at this point), and bundle them in a single message.

7. Shep then sends an email with a message or messages back to the mailing list, *without the original user's name* (or users' names, in the case of multiple messages), under the subject line [Please Explain] and a header that reads:

    "One of your fellow list members found the following hard to understand. Would someone be willing to offer an explanation? If so, reply to this email with your explanation. Thanks, Shep."

8. After sending the mail, shep watches the list for replies to the [Please Explain] message, and records those as well.

9. Optionally, a user receiving a [Please Explain] message that contains objectionable content can forward the message to shep with [flag] anywhere in the subject line, and shep will forward the message to the admins' email addresses.)


### TESTS, FLAGS and VARIABLES:

- TEST The incoming mail is from a list user
- VARIABLE Maximum character/word count in the mail body
- TEST That the mail doesn't have a .sig/Delete if it does
- FLAG Store mail in the db without a SENT flag/Set on send
- FLAG Is mail sending manual or automatic
- VARIABLE Send mail after N messages
- VARIABLE Send mail after H hours
- TEST That the outbound message doesn't bounce

### Development

1. Have Ruby 1.9.X. Tested on Ruby 1.9.3. If you aren't running Ruby 1.9.2 or
higher I recommend doing so with [rvm](http://rvm.io).

2. Clone this repository by doing the following in Terminal:

        $ git clone git@github.com:ITPNYU/explain.shep.info.git
        $ cd explain.shep.info

3. While still in Terminal, get the necessary dependencies by running Bundler.
We'll skip the Postgres gem for now by ignoring the *production* group.

        $ bundle install --without production

If this command completed without errors, proceed, otherwise Google the error.

4. The Gmail account information is contained in environment variables which
must be set every time you open a new Terminal window or tab. Here are all the
variables that must be set:

        $ export GMAIL_ADDRESS=<your_email@domain.com>
        $ export GMAIL_PASSWORD=<your_password>
        $ export DESTINATION_ADDRESS=<email_to_send_digest_to>

When `PREAPPROVE` is set to `false` emails are automatically approved to be
added to digest emails. If `PREAPPROVE` is set to `true` then emails must be
approved through the web interface.

5. Run the site

        $ rackup

6. Or run the Rake tasks.

        $ rake -T # to see what tasks are available

## License

The MIT License (MIT)
Copyright (c) 2012

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
