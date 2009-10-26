require File.join(File.dirname(__FILE__), 'spec_helper')

describe Sunspot::Rails::Server do
  before(:each) do
    @sunspot_configuration = Sunspot::Rails::Configuration.new
  end

  describe "rake task commands" do
    before(:each) do
      Sunspot::Rails::Server.should_receive(:pid_path).and_return('/tmp')
    end
    
    it "should generate and execute the start command" do
      Sunspot::Rails::Server.should_receive(:start_command).and_return('sunspot-start')
      Sunspot::Rails::Server.should_respond_to_and_receive(:bootstrap_neccessary?).and_return(false)
      Kernel.should_receive(:system).with('sunspot-start').and_return(true)
      Sunspot::Rails::Server.start.should == true
    end

    it "should generate and execute the stop command" do
      Sunspot::Rails::Server.should_receive(:stop_command).and_return('sunspot-stop')
      Sunspot::Rails::Server.should_not_receive(:bootstrap_neccessary?)
      Kernel.should_receive(:system).with('sunspot-stop').and_return(true)
      Sunspot::Rails::Server.stop.should == true
    end

    it "should generate and execute the run command" do
      Sunspot::Rails::Server.should_receive(:run_command).and_return('sunspot-run')
      Sunspot::Rails::Server.should_respond_to_and_receive(:bootstrap_neccessary?).and_return(false)
      Kernel.should_receive(:system).with('sunspot-run').and_return(true)
      Sunspot::Rails::Server.run.should == true
    end
  end

  describe "bootstraping" do
    before(:each) do
      @temp_dir = File.join( Dir.tmpdir, 'solr_rspec', Time.now.to_i.to_s, rand(1000).to_s )
      Sunspot::Rails::Server.should_receive(:solr_home).at_least(1).and_return( @temp_dir )
    end
    
    it "should require bootstraping" do
      Sunspot::Rails::Server.bootstrap_neccessary?.should == true
    end
    
    it "should not require bootstrapping again" do
      Sunspot::Rails::Server.bootstrap_neccessary?.should == true
      Sunspot::Rails::Server.bootstrap
      Sunspot::Rails::Server.bootstrap_neccessary?.should == false
    end
  end

  describe "delegate methods" do
    before(:each) do
      Sunspot::Rails::Server.should_receive(:configuration).at_least(1).and_return(@sunspot_configuration)
    end

    it "should delegate the port method to the configuration" do
      @sunspot_configuration.should_respond_to_and_receive(:port).and_return(1234)
      Sunspot::Rails::Server.port.should == 1234
    end
    
    it "should delegate the solr_home method to the configuration" do
      @sunspot_configuration.should_respond_to_and_receive(:solr_home).and_return('/some/path')
      Sunspot::Rails::Server.solr_home.should == '/some/path'
    end
    
    it "should delegate the log_level method to the configuration" do
      @sunspot_configuration.should_respond_to_and_receive(:log_level).and_return('LOG_LEVEL')
      Sunspot::Rails::Server.log_level.should == 'LOG_LEVEL'
    end

    it "should delegate the log_dir method to the configuration" do
      @sunspot_configuration.should_respond_to_and_receive(:log_file).and_return('log_file')
      Sunspot::Rails::Server.log_file.should =~ /log_file/
    end

    it "should delegate the max_memory method to the configuration" do
      @sunspot_configuration.should_respond_to_and_receive(:max_memory).and_return('max_memory')
      Sunspot::Rails::Server.max_memory.should == 'max_memory'
    end
    
    it "should delegate the min_memory method to the configuration" do
      @sunspot_configuration.should_respond_to_and_receive(:min_memory).and_return('min_memory')
      Sunspot::Rails::Server.min_memory.should == 'min_memory'
    end
  end

  describe "protected methods" do
    it "should generate the start command" do
      Sunspot::Rails::Server.should_respond_to_and_receive(:port).and_return('1')
      [ :solr_home, :data_path, :log_level, :log_file, :max_memory, :min_memory ].each do |key|
        Sunspot::Rails::Server.should_respond_to_and_receive( key ).and_return( key.to_s )
      end

      Sunspot::Rails::Server.send(:start_command).should == \
          [ 'sunspot-solr', 'start', '-p', '1', '-d', 'data_path', '-s', 'solr_home', '-l', 'log_level', 
                  '--log-file', 'log_file', '--max-memory', 'max_memory', '--min-memory', 'min_memory' ]
    end
  
    it "should generate the stop command" do
      Sunspot::Rails::Server.send(:stop_command).should == [ 'sunspot-solr', 'stop' ]
    end
  
    it "should generate the run command" do
      Sunspot::Rails::Server.should_respond_to_and_receive(:port).and_return('1')
      [ :solr_home, :data_path, :log_level, :log_file, :max_memory, :min_memory ].each do |key|
        Sunspot::Rails::Server.should_respond_to_and_receive( key ).and_return( key.to_s )
      end

      Sunspot::Rails::Server.send(:run_command).should == \
          [ 'sunspot-solr', 'run', '-p', '1', '-d', 'data_path', '-s', 'solr_home', '-l', 'log_level', 
                  '--log-file', 'log_file', '--max-memory', 'max_memory', '--min-memory', 'min_memory' ]
      
    end

    it "should generate the path for config files" do
      Sunspot::Rails::Server.should_receive(:solr_home).and_return('/solr/home')
      Sunspot::Rails::Server.config_path.should == '/solr/home/conf'
    end
    
    it "should generate the path for custom libraries" do
      Sunspot::Rails::Server.should_receive(:solr_home).and_return('/solr/home')
      Sunspot::Rails::Server.lib_path.should == '/solr/home/lib'
    end
  
    it "should generate the path for the index data" do
      Sunspot::Rails::Server.should_receive(:solr_home).and_return('/solr/home')
      Sunspot::Rails::Server.data_path.should == '/solr/home/data/test'
    end

    it "should generate the path for pid files" do
      Sunspot::Rails::Server.should_receive(:solr_home).and_return('/solr/home')
      Sunspot::Rails::Server.pid_path.should == '/solr/home/pids/test'
    end
  end
end