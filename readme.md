Explain.shep.info is designed to let mailing list subscribers send confidential questions about content FROM a particular mailing list back TO that mailing list, with a request for explanation.

Scenario:

1. User KnowItAll sends a mail to the list saying "AFAIC, this idea is a CWOT. FWIW, TANSTAAFL. (YMMV.) L8R D00D3Z."

2. This message is distributed to all the recipients of the list. User IJustGotHere reads this message and says to himself "zomg wtf do all those acronyms mean!"

3. User IJustGotHere then forwards the message to shep@shep.info, adding "[explain]" to the subject line.

4. When shep@shep.info receives a message with "[explain]" in the subject, it checks that the sender is valid, then records the email (and all headers) and puts the body of the message in a database.

(The admin can toggle between manual and automated for step #5.)

5. Manual: When the explain.shep admin logs in, shep displays messages that do not yet have SENT flags, along with the senders name and email, and presents them to the admin in a list. The admin can UNCHECK mail that SHOULD NOT be sent, then bundle them in a single message. 

5. Automated: Shep periodically queries the db, looking for messages without SENT flags. When there are N or more such messages (N >= 3, at this point) or H hours have passed after the message was delivered (H == 48 at this point), and bundle them in a single message.

6. Shep then sends an email with a message or messages back to the mailing list, *without the original user's name* (or users' names, in the case of multiple messages), under the subject line [Please Explain] and a header that reads:

"One of your fellow list members found the following hard to understand. Would someone be willing to offer an explanation? If so, reply to this email with your explanation. Thanks, Shep."

7. After sending the mail, shep watches the list for replies to the [Please Explain] message, and records those as well.

(8. Optionally, a user receiving a [Please Explain] message that contains objectionable content can forward the message to shep with [flag] anywhere in the subject line, and shep will forward the message to the admins' email addresses.)

