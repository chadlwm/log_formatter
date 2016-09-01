require 'spec_helper'
require 'log_formatter/ruby_json_formatter'

describe 'Ruby::JSONFormatter' do
  context 'plain initialization' do
    let(:json_formatter){ Ruby::JSONFormatter::Base.new }
    it do
       json_formatter.instance_eval{@app}.should be_nil
       json_formatter.instance_eval{@ext}.should be_empty
       json_formatter.respond_to?(:call).should be_truthy
    end
  end

  context 'specify app name' do
    let(:json_formatter){ Ruby::JSONFormatter::Base.new('TestApp') }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}.should be_empty
       json_formatter.respond_to?(:call).should be_truthy
    end
  end

  context 'specify ext' do
    let(:json_formatter){ Ruby::JSONFormatter::Base.new('TestApp', {ext: 'ext info'}) }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}[:ext].should eq 'ext info'
       json_formatter.respond_to?(:call).should be_truthy
    end
  end

   context 'call with string' do
    let(:json_formatter){ Ruby::JSONFormatter::Base.new('TestApp', {ext: 'ext info'}) }
    let(:time){ Time.now }
    let(:json_formatter_call){ json_formatter.call('Info', time, 'worker', 'test data') }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}[:ext].should eq 'ext info'
       json_formatter.respond_to?(:call).should be_truthy
       json_formatter_call.class.should eq String
       json_formatter_call.should match(/\n$/)

       json_hash = JSON.parse(json_formatter_call.chomp)
       json_hash['log_level'].should eq 'Info'
       json_hash['log_type'].should eq 'worker'
       json_hash['log_app'].should eq 'TestApp'
       json_hash['log_timestamp'].should eq time.iso8601
       json_hash['message'].should eq 'test data'
    end
  end

  context 'call with json string' do
    let(:json_formatter){ Ruby::JSONFormatter::Base.new('TestApp', {ext: 'ext info'}) }
    let(:time){ Time.now }
    let(:json_formatter_call){ json_formatter.call('Info', time, 'worker', "{\"data\":\"test data\"}") }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}[:ext].should eq 'ext info'
       json_formatter.respond_to?(:call).should be_truthy
       json_formatter_call.class.should eq String
       json_formatter_call.should match(/\n$/)

       json_hash = JSON.parse(json_formatter_call.chomp)
       json_hash['log_level'].should eq 'Info'
       json_hash['log_type'].should eq 'worker'
       json_hash['log_app'].should eq 'TestApp'
       json_hash['log_timestamp'].should eq time.iso8601
       json_hash['data'].should eq 'test data'
    end
  end

  context 'call with hash' do
    let(:json_formatter){ Ruby::JSONFormatter::Base.new('TestApp', {ext: 'ext info'}) }
    let(:time){ Time.now }
    let(:json_formatter_call){ json_formatter.call('Info', time, 'worker', {data:"test data"}) }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}[:ext].should eq 'ext info'
       json_formatter.respond_to?(:call).should be_truthy
       json_formatter_call.class.should eq String
       json_formatter_call.should match(/\n$/)

       json_hash = JSON.parse(json_formatter_call.chomp)
       json_hash['log_level'].should eq 'Info'
       json_hash['log_type'].should eq 'worker'
       json_hash['log_app'].should eq 'TestApp'
       json_hash['log_timestamp'].should eq time.iso8601
       json_hash['data'].should eq 'test data'
    end
  end

  context 'set customer keys' do
    let(:json_formatter) do
      Ruby::JSONFormatter::Base.new('TestApp', {ext: 'ext info'}) do |config|
        config[:level] = :cus_level
        config[:type] = :cus_type
        config[:app] = :cus_app
        config[:timestamp] = :cus_timestamp
      end
    end
    let(:time){ Time.now }
    let(:json_formatter_call){ json_formatter.call('Info', time, 'worker', {data:"test data"}) }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}[:ext].should eq 'ext info'
       json_formatter.respond_to?(:call).should be_truthy
       json_formatter_call.class.should eq String
       json_formatter_call.should match(/\n$/)

       json_hash = JSON.parse(json_formatter_call.chomp)
       json_hash['cus_level'].should eq 'Info'
       json_hash['cus_type'].should eq 'worker'
       json_hash['cus_app'].should eq 'TestApp'
       json_hash['cus_timestamp'].should eq time.iso8601
       json_hash['data'].should eq 'test data'
    end
  end

  context 'disable some keys' do
    let(:json_formatter) do
      Ruby::JSONFormatter::Base.new('TestApp', {ext: 'ext info'}) do |config|
        config[:level] = false
        config[:type] = false
        config[:app] = :cus_app
        config[:timestamp] = :cus_timestamp
      end
    end
    let(:time){ Time.now }
    let(:json_formatter_call){ json_formatter.call('Info', time, 'worker', {data:"test data"}) }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}[:ext].should eq 'ext info'
       json_formatter.respond_to?(:call).should be_truthy
       json_formatter_call.class.should eq String
       json_formatter_call.should match(/\n$/)

       json_hash = JSON.parse(json_formatter_call.chomp)
       json_hash['cus_level'].should be_nil
       json_hash['cus_type'].should be_nil
       json_hash['cus_app'].should eq 'TestApp'
       json_hash['cus_timestamp'].should eq time.iso8601
       json_hash['data'].should eq 'test data'
    end
  end
end
