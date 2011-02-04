require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper.rb'))

describe TestbotCloud::Providers::Ec2 do

  describe "generate_project" do

    it "should use a generator to copy config files" do
      mock_generator = MiniTest::Mock.new
      mock_generator.expect :copy_file, nil, [ "ec2/config.yml", "demo/config.yml" ]
      mock_generator.expect :copy_file, nil, [ "ec2/ssh_key.pem", "demo/ssh_key.pem" ]
      provider = TestbotCloud::Providers::Ec2.new(mock_generator)
      provider.generate_project("demo")
      mock_generator.verify
    end

  end

end

