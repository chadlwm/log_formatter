require 'spec_helper'
require 'log_formatter/ruby_text_formatter'

describe 'Ruby::TextFormatter' do
  context 'plain initialization' do
    let(:json_formatter){ Ruby::TextFormatter::Base.new }
    it do
       json_formatter.instance_eval{@app}.should be_nil
       json_formatter.instance_eval{@ext}.should be_empty
       json_formatter.respond_to?(:call).should be_truthy
    end
  end

  context 'specify app name' do
    let(:json_formatter){ Ruby::TextFormatter::Base.new('TestApp') }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}.should be_empty
       json_formatter.respond_to?(:call).should be_truthy
    end
  end

  context 'specify ext' do
    let(:json_formatter){ Ruby::TextFormatter::Base.new('TestApp', {ext: 'ext info'}) }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}[:ext].should eq 'ext info'
       json_formatter.respond_to?(:call).should be_truthy
    end
  end

   context 'call with string' do
    let(:json_formatter){ Ruby::TextFormatter::Base.new('TestApp', {ext: 'ext info'}) }
    let(:time){ Time.now }
    let(:json_formatter_call){ json_formatter.call('Info', time, 'worker', 'test data') }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}[:ext].should eq 'ext info'
       json_formatter.respond_to?(:call).should be_truthy
       json_formatter_call.class.should eq String
       json_formatter_call.should match(/\n$/)

       text = json_formatter_call.chomp
       text.should match(/log_level:Info/)
       text.should match(/log_type:worker/)
       text.should match(/log_app:TestApp/)
       text.include?("log_timestamp:#{time.iso8601}").should be_truthy
       text.should match(/message:test data/)
    end
  end

  context 'call with json string' do
    let(:json_formatter){ Ruby::TextFormatter::Base.new('TestApp', {ext: 'ext info'}) }
    let(:time){ Time.now }
    let(:json_formatter_call){ json_formatter.call('Info', time, 'worker', "{\"data\":\"test data\"}") }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}[:ext].should eq 'ext info'
       json_formatter.respond_to?(:call).should be_truthy
       json_formatter_call.class.should eq String
       json_formatter_call.should match(/\n$/)

       text = json_formatter_call.chomp
       text.should match(/log_level:Info/)
       text.should match(/log_type:worker/)
       text.should match(/log_app:TestApp/)
       text.include?("log_timestamp:#{time.iso8601}").should be_truthy
       text.should match(/data:test data/)
    end
  end

  context 'call with hash' do
    let(:json_formatter){ Ruby::TextFormatter::Base.new('TestApp', {ext: 'ext info'}) }
    let(:time){ Time.now }
    let(:json_formatter_call){ json_formatter.call('Info', time, 'worker', {data:"test data"}) }
    it do
       json_formatter.instance_eval{@app}.should eq 'TestApp'
       json_formatter.instance_eval{@ext}[:ext].should eq 'ext info'
       json_formatter.respond_to?(:call).should be_truthy
       json_formatter_call.class.should eq String
       json_formatter_call.should match(/\n$/)

       text = json_formatter_call.chomp
       text.should match(/log_level:Info/)
       text.should match(/log_type:worker/)
       text.should match(/log_app:TestApp/)
       text.include?("log_timestamp:#{time.iso8601}").should be_truthy
       text.should match(/data:test data/)
    end
  end

  context 'set customer keys' do
    let(:json_formatter) do
      Ruby::TextFormatter::Base.new('TestApp', {ext: 'ext info'}) do |config|
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

       text = json_formatter_call.chomp
       text.should match(/cus_level:Info/)
       text.should match(/cus_type:worker/)
       text.should match(/cus_app:TestApp/)
       text.include?("cus_timestamp:#{time.iso8601}").should be_truthy
       text.should match(/data:test data/)
    end
  end

  context 'disable some keys' do
    let(:json_formatter) do
      Ruby::TextFormatter::Base.new('TestApp', {ext: 'ext info'}) do |config|
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
    
       text = json_formatter_call.chomp
       text.should match(/cus_app:TestApp/)
       text.include?("cus_timestamp:#{time.iso8601}").should be_truthy
       text.should match(/data:test data/)
    end
  end
end
