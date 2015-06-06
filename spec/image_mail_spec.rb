require 'rspec'
require_relative '../lib/image_mail'

describe Pony do

  before(:each) do
    allow(Pony).to receive(:deliver)
  end

  it "sends mail" do
    expect(Pony).to receive(:deliver) do |mail|
      expect(mail.to).to eq [ 'joe@example.com' ]
      expect(mail.from).to eq [ 'sender@example.com' ]
      expect(mail.subject).to eq 'hi'
      expect(mail.body).to eq 'Hello, Joe.'
    end
    Pony.mail(:to => 'joe@example.com', :from => 'sender@example.com', :subject => 'hi', :body => 'Hello, Joe.')
  end

  it "requires :to param" do
    expect{ Pony.mail({}) }.to raise_error(ArgumentError)
  end

  it "doesn't require any other param" do
    expect{ Pony.mail(:to => 'joe@example.com') }.to_not raise_error
  end

  it 'can list its available options' do
    expect( Pony.permissable_options ).to include(:to, :body)
  end

  describe "builds a Mail object with field:" do
    it "to" do
      expect(Pony.build_mail(:to => 'joe@example.com').to).to eq [ 'joe@example.com' ]
    end

    it "to with multiple recipients" do
      expect(Pony.build_mail(:to => 'joe@example.com, friedrich@example.com').to).to eq [ 'joe@example.com', 'friedrich@example.com' ]
    end

    it "cc" do
      expect(Pony.build_mail(:cc => 'joe@example.com').cc).to eq [ 'joe@example.com' ]
    end

    it "reply_to" do
      expect(Pony.build_mail(:reply_to => 'joe@example.com').reply_to).to eq [ 'joe@example.com' ]
    end

    it "cc with multiple recipients" do
      expect(Pony.build_mail(:cc => 'joe@example.com, friedrich@example.com').cc).to eq [ 'joe@example.com', 'friedrich@example.com' ]
    end

    it "from" do
      expect(Pony.build_mail(:from => 'joe@example.com').from).to eq [ 'joe@example.com' ]
    end

    it "charset" do
      mail = Pony.build_mail(:charset => 'UTF-8')
      expect(mail.charset).to eq 'UTF-8'
    end

    it "default charset" do
      expect(Pony.build_mail(body: 'body').charset).to eq 'UTF-8'
      expect(Pony.build_mail(html_body: 'body').charset).to eq 'UTF-8'
    end

    it "subject" do
      expect(Pony.build_mail(:subject => 'hello').subject).to eq 'hello'
    end

    it "body" do
      expect(Pony.build_mail(body: 'What do you know, Joe?').body)
        .to eq 'What do you know, Joe?'
    end

    it "date" do
      now = Time.now
      expect(Pony.build_mail(:date => now).date).to eq DateTime.parse(now.to_s)
    end

    it "attachments" do
      mail = Pony.build_mail(:attachments => {"foo.txt" => "content of foo.txt"}, :body => 'test')
      expect(mail.parts.length).to eq 2
      expect(mail.parts.first.to_s).to match( /Content-Type: text\/plain/ )
      expect(mail.attachments.first.content_id).to eq "<foo.txt@#{Socket.gethostname}>"
    end
  end
end
