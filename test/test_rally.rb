require "test/unit"
require "json"
require 'json/add/core'
#require "./test_unit_extensions.rb"
#require "./rally/rally.rb"
require "test_unit_extensions"

class RallyConfig
  attr_accessor :username;
  attr_accessor :password;
  attr_accessor :serverurl;
  attr_accessor :workspace;
  attr_accessor :project;

  def initialize()
    @serverurl = "https://rally1.rallydev.com/"
    @username = "plaplante@pharos.com"
    @password = "Gr0sVag1n69"
    @workspace = "Pharos"
    @project = "MPS / Web Client"
  end
end

class RallyTest < Test::Unit::TestCase
  def setup
    @rallyConfig = RallyConfig.new
    @rally = Pharos::Utils::Rally::Rally.new(@rallyConfig)
  end
  
  must "connect to rally successfully" do
    @rally.openConnection
    iteration = @rally.getCurrentIteration
    puts "Iteration: " + iteration.name

    stories = @rally.getCurrentIterationStories iteration
    stories.each { |story|
      puts "(" + story.formatted_i_d + ") - " + story.name
      unless story.tasks.nil?
        story.tasks.each { |task|
          puts "\t" + task.formatted_i_d + ": " + task.name
        }
      end
    }
#    tasks.each { |task| puts "(" + task.work_product.formatted_i_d + ") - " + task.work_product.name +  ": " + task.inspect }

    defects = @rally.getAllOpenDefectsForIteration @rallyConfig.project, iteration
    defects.each { |defect| puts defect.state; puts defect.priority; puts defect.project.body; }
  end

#  %w[y Y YeS YES yes].each do |yes|
#    must "return true when yes_or_no parses #{yes}" do
#      assert @questioner.yes_or_no(yes), "#{yes.inspect} expected to parse as true" 
#    end
#  end

#  %w[n N no nO].each do |no|
#    must "return false when yes_or_no parses #{no}" do
#      assert ! @questioner.yes_or_no(no), "#{no.inspect} expected to parse as false" 
#    end
#  end

#  %w[Note Yesterday xyzaty].each do |mu|
#    must "return nil because #{mu} is not a variant of 'yes' or 'no'" do
#      assert_nil @questioner.yes_or_no(mu), "#{mu.inspect} expected to parse as nil" 
#    end
#  end 


end
