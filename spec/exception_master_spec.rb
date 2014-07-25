require_relative '../lib/exception_master'

describe ExceptionMaster do

  it "writes Pony settings" do
    em = ExceptionMaster.new(environment: 'production', email_config: {via: :smtp, to: 'exception-master-receiver@localhost'})
    em.email_config[:via].should == :smtp
  end

  it "sends en email on error" do
    Pony.should_receive(:mail).once
    ExceptionMaster.new(environment: 'production', raise_error: false, email_config: {to: 'exception-master-receiver@localhost'}).watch { 1/0 }
  end

  it "raises error after sending an email" do
    Pony.stub(:mail)
    expect { ExceptionMaster.new(environment: 'production', raise_error: true, email_settings: { to: 'exception-master-receiver@localhost'}).watch { 1/0 } }.to raise_exception
  end

  it "doesn't deliver when deliver_email flag is set to false" do
    Pony.should_receive(:mail).exactly(0).times
    expect { ExceptionMaster.new(environment: 'production', raise_error: true, deliver_email: false, email_settings: { to: 'exception-master-receiver@localhost'}).watch { 1/0 } }.to raise_exception
  end

  it "doesn't deliver emails when the environment is not in the send_when_environment_is list" do
    Pony.should_receive(:mail).exactly(0).times
    expect { ExceptionMaster.new(environment: 'development', raise_error: true, deliver_email: false, email_settings: { to: 'exception-master-receiver@localhost'}).watch { 1/0 } }.to raise_exception
  end

end
