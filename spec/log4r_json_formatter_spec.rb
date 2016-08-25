require 'spec_helper'
require 'log_formatter/log4r_json_formatter'

describe 'Log4r::JSONFormatter' do
  context 'plain initialization' do
    let(:json_formatter){ Log4r::JSONFormatter::Base.new }
    it do
       json_formatter.instance_eval{@app}.should be_nil
       json_formatter.instance_eval{@ext}.should be_empty
       json_formatter.respond_to?(:format).should be_truthy
    end
  end

  context 'specify app name' do
    let(:json_formatter){ Log4r::JSONFormatter::Base.new('TestApp') }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}.should be_empty
       json_formatter.respond_to?(:format).should be_truthy
    end
  end

  context 'specify ext' do
    let(:json_formatter){ Log4r::JSONFormatter::Base.new('TestApp', {ext: 'ext info'}) }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}[:ext].should eq 'ext info'
       json_formatter.respond_to?(:format).should be_truthy
    end
  end

   context 'format with string' do
    let(:json_formatter){ Log4r::JSONFormatter::Base.new('TestApp', {ext: 'ext info'}) }
    let(:logger){ Log4r::Logger.new('Log4RTest') }
    let(:time){ Time.now }
    let(:json_formatter_format){ json_formatter.format(Log4r::LogEvent.new(2, logger, nil, 'test data')) }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}[:ext].should eq 'ext info'
       json_formatter.respond_to?(:format).should be_truthy
       json_formatter_format.class.should eq String
       json_formatter_format.should match(/\n$/)

       json_hash = JSON.parse(json_formatter_format.chomp)
       json_hash['log_level'].should eq 'INFO'
       json_hash['log_type'].should eq 'Log4RTest'
       json_hash['log_app'].should eq 'TestApp'
       json_hash['log_timestamp'].should eq time.iso8601
       json_hash['message'].should eq 'test data'
    end
  end

  context 'format with json string' do
    let(:json_formatter){ Log4r::JSONFormatter::Base.new('TestApp', {ext: 'ext info'}) }
    let(:logger){ Log4r::Logger.new('Log4RTest') }
    let(:time){ Time.now }
    let(:json_formatter_format){ json_formatter.format(Log4r::LogEvent.new(2, logger, nil, "{\"data\":\"test data\"}")) }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}[:ext].should eq 'ext info'
       json_formatter.respond_to?(:format).should be_truthy
       json_formatter_format.class.should eq String
       json_formatter_format.should match(/\n$/)

       json_hash = JSON.parse(json_formatter_format.chomp)
       json_hash['log_level'].should eq 'INFO'
       json_hash['log_type'].should eq 'Log4RTest'
       json_hash['log_app'].should eq 'TestApp'
       json_hash['log_timestamp'].should eq time.iso8601
       json_hash['data'].should eq 'test data'
    end
  end

  context 'format with hash' do
    let(:json_formatter){ Log4r::JSONFormatter::Base.new('TestApp', {ext: 'ext info'}) }
    let(:logger){ Log4r::Logger.new('Log4RTest') }
    let(:time){ Time.now }
    let(:json_formatter_format){ json_formatter.format(Log4r::LogEvent.new(2, logger, nil, {data:"test data"})) }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}[:ext].should eq 'ext info'
       json_formatter.respond_to?(:format).should be_truthy
       json_formatter_format.class.should eq String
       json_formatter_format.should match(/\n$/)

       json_hash = JSON.parse(json_formatter_format.chomp)
       json_hash['log_level'].should eq 'INFO'
       json_hash['log_type'].should eq 'Log4RTest'
       json_hash['log_app'].should eq 'TestApp'
       json_hash['log_timestamp'].should eq time.iso8601
       json_hash['data'].should eq 'test data'
    end
  end

  context 'set customer keys' do
    let(:json_formatter) do
      Log4r::JSONFormatter::Base.new('TestApp', {ext: 'ext info'}) do |config|
        config[:level] = :cus_level
        config[:type] = :cus_type
        config[:app] = :cus_app
        config[:timestamp] = :cus_timestamp
      end
    end
    let(:logger){ Log4r::Logger.new('Log4RTest') }
    let(:time){ Time.now }
    let(:json_formatter_format){ json_formatter.format(Log4r::LogEvent.new(2, logger, nil, {data:"test data"})) }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}[:ext].should eq 'ext info'
       json_formatter.respond_to?(:format).should be_truthy
       json_formatter_format.class.should eq String
       json_formatter_format.should match(/\n$/)

       json_hash = JSON.parse(json_formatter_format.chomp)
       json_hash['cus_level'].should eq 'INFO'
       json_hash['cus_type'].should eq 'Log4RTest'
       json_hash['cus_app'].should eq 'TestApp'
       json_hash['cus_timestamp'].should eq time.iso8601
       json_hash['data'].should eq 'test data'
    end
  end
end
