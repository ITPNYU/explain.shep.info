## Development

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
      $ export PREAPPROVE=<false OR true>
      $ export DESTINATION_ADDRESS=<email_to_send_digest_to>

When `PREAPPROVE` is set to `false` emails are automatically approved to be
added to digest emails. If `PREAPPROVE` is set to `true` then emails must be
approved through the web interface.

5. Run the site

      $ rackup

6. Or run the Rake tasks.

      $ rake -T # to see what tasks are available