require 'pony'
require 'erb'

class ExceptionMaster

  attr_reader :email_config

  def initialize(raise_error: true, deliver_email: true, email_config: {}, environment: 'development', send_when_environment_is: ['production', 'staging'])

    @email_config  = { via: :sendmail, from: 'exception-master@localhost', subject: 'Error' }
    @email_config.merge!(email_config)
    @raise_error   = raise_error
    @deliver_email = deliver_email
    @environment   = environment
    @send_when_environment_is = send_when_environment_is

    if @email_config[:to].nil?
      raise "Please specify email addresses of email recipients using :to key in email_config attr (value should be array)"
    end

  end

  def watch
    yield
  rescue Exception => e
    deliver_exception(e) if @deliver_email
    raise(e) and exit if @raise_error
  end

  def deliver_exception(e)
    if @send_when_environment_is.include?(@environment)
      Pony.mail(@email_config.merge({html_body: error_to_html(e)}))
    end
  end


  private

    def error_to_html(e)
      template = ERB.new(File.read(File.expand_path(File.dirname(__FILE__)) + '/../views/error.html.erb'))
      template.result(binding)
    end

end
