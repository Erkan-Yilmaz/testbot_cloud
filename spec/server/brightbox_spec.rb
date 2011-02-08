require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper.rb'))

describe TestbotCloud::Server::Brightbox, "running?" do

  it "should be true when the server status is active" do
    TestbotCloud::Server::Brightbox.new(nil, mock(Object, :status => "active")).should be_running
  end

  it "should be false when the server status is not active" do
    TestbotCloud::Server::Brightbox.new(nil, mock(Object, :status => "deleted")).should_not be_running
  end

end

describe TestbotCloud::Server::Brightbox, "bootstrap!" do

  it "should find unmapped ips and map to the server" do
    compute = mock(Object, :cloud_ips => [ mock(Object, :status => "mapped"), available_ip = mock(Object, :status => "unmapped") ])
    fog_server = mock(Object, :interfaces => [ { "id" => "int-xxyyy" } ])
    server = TestbotCloud::Server::Brightbox.new(compute, fog_server)

    available_ip.should_receive(:map).with("int-xxyyy")

    server.bootstrap!
  end

  it "should create a cloud ip and map when none are available" do
    # Found no good way to assert the order of events other than creating a custom mock class.
    class ComputeWithNoFreeIps
      def initialize; @cloud_ips = []; end
      attr_reader :cloud_ips

      def create_cloud_ip
        @cloud_ips << OpenStruct.new(:status => "unmapped")
        @cloud_ips.last.should_receive(:map).with("int-xxyyy")
      end
    end

    compute = ComputeWithNoFreeIps.new
    fog_server = mock(Object, :interfaces => [ { "id" => "int-xxyyy" } ])
    server = TestbotCloud::Server::Brightbox.new(compute, fog_server)

    server.bootstrap!
  end

end
