require_relative '../lib/exception_master'

describe ExceptionMaster do

  it "writes Pony settings" do
    em = ExceptionMaster.new(email_config: {via: :smtp, to: 'exception-master-receiver@localhost'})
    em.email_config[:via].should == :smtp
  end

  it "sends en email on error" do
    Pony.should_receive(:mail).once
    ExceptionMaster.new(raise_error: false, email_config: {to: 'exception-master-receiver@localhost'}).watch { 1/0 }
  end

  it "raises error after sending an email" do
    Pony.stub(:mail)
    expect { ExceptionMaster.new(raise_error: true, email_settings: { to: 'exception-master-receiver@localhost'}).watch { 1/0 } }.to raise_exception
  end

end
