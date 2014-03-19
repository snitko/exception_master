require 'pony'
require 'erb'

class ExceptionMaster

  attr_reader :email_config

  def initialize(raise_error: true, email_config: {})

    @email_config = { via: :sendmail, from: 'exception-master@localhost', subject: 'Error' }
    @email_config.merge!(email_config)
    @raise_error  = raise_error

    if @email_config[:to].nil?
      raise "Please specify email addresses of email recipients using :to key in email_config attr (value should be array)"
    end

  end

  def watch
    yield
  rescue Exception => e
    Pony.mail(@email_config.merge({html_body: error_to_html(e)}))
    raise(e) if @raise_error
  end


  private

    def error_to_html(e)
      template = ERB.new(File.read(File.expand_path(File.dirname(__FILE__)) + '/../views/error.html.erb'))
      template.result(binding)
    end

end
