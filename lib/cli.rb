require 'rubygems'
require 'thor'
require File.expand_path(File.join(File.dirname(__FILE__), 'cluster.rb'))
require File.expand_path(File.join(File.dirname(__FILE__), 'testbot_cloud/version.rb'))

module TestbotCloud
  class Cli < Thor
    include Thor::Actions

    def self.source_root
      File.dirname(__FILE__) + "/templates"
    end

    desc "new PROJECT_NAME", "Generate a testbot cloud project"
    def new(name)
      copy_file "config.yml", "#{name}/config.yml"
      copy_file "gitignore", "#{name}/.gitignore"
      copy_file "runner.sh", "#{name}/bootstrap/runner.sh"
    end

    desc "start", "Start a testbot cluster as configured in config.yml"
    def start
      Cluster.new.start
    end

    desc "stop", "Shutdown servers"
    def stop
      Cluster.new.stop
    end

    desc "version", "Show version"
    def version
      puts "TestbotCloud #{TestbotCloud::VERSION}"
    end

  end
end

