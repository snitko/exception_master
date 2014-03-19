Exception Master
================

Because ExceptionNotification only works with Rails and it sucks.
Because other exception notification gems require you to have an account on one of those error managing web services.

Fuck that.

Pure Ruby. Pure exceptions. Sends via sendmail by default (but can do SMTP). Uses Pony gem to send emails, so you can provide all the options that `Pony.mail` expects. This is how you use this gem:

    require 'exception_master'

    ExceptionMaster.new(
      raise_error: true,
      email_settings: { to: 'your-email@here.com' }
    }).watch do

      # all your code goes inside the block here
      1/0

    end


If `raise_error` is set to true, then after sending an email, it still raises the exception and exits the program (default is `true`). `email_settings` is a hash of options that `Pony.mail` receives - consult the documentation for that gem. But don't worry too much, by default we use Sendmail, so your emails should be sent just alright if you have something like Postfix running.
