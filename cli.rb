require 'optparse'
require 'colorize'

class Cli
  def initialize
    @optparse = OptionParser.new do |opts|
      opts.banner = "\n----------------- Soundcloud Top List Getter -----------------\n".colorize(:yellow) +
          "Usage: SCTopList.rb [options]".colorize(:green)

      opts.separator ""
      opts.separator "Specific options:".colorize(:magenta)

      opts.on("-a", "--all", "Show All Categories") do
        $options[:all] = true
        $optionName = "all"
      end

      opts.on("-s <similar>", "--similar", "Show Similar Categories") { |similar|
        $options[:similar] = similar
        $optionName = "similar"
      }

      opts.on("-c <category>", "--category", "Show This Category Only") { |category|
        $options[:category] = category
        $optionName = "category"
      }

      opts.on("-j", "--json", "Show Data in JSON") {
        $options[:json] = true
      }

      opts.on("-g", "--geo", "Show Data with Location Parameters") {
        $options[:geo] = true
      }

      opts.on("-f", "--file", "Create Report File") {
        $options[:file] = true
      }

      opts.on("-l <limit>", "--limit", "Max number of Categories (recommended)") { |limit|
        $options[:limit] = limit
      }


      opts.on("-h", "--help", "Help") {
        puts @optparse
        exit
      }

      opts.separator ""
      opts.separator "--------------------------------------------------------------".colorize(:yellow)
      opts.separator ""
    end

    begin
      @optparse.parse!
      control

      rescue OptionParser::InvalidOption, OptionParser::MissingArgument
      puts "\nSoundcloud Top List Getter Argument Problem. Please run with --help to see arguments\n".colorize(:yellow)
      #puts @optparse
      exit
    end
  end

  def control
    mandatory = [:all, :similar, :category]
    missing = false

    $options.each { |option|
      if $options[option].nil? && missing == false
        missing = true
      end
    }

    if not missing
      puts "\nSoundcloud Top List Getter Argument Problem. Please run with --help to see arguments\n".colorize(:yellow)
      #puts @optparse
      exit
    end

    case $optionName
      when "all"
        $scFuncs.render(nil, $options[:json], $options[:geo])
      when "category"
        $scFuncs.render($options[:category], $options[:json], $options[:geo])
      when "similar"
        $scFuncs.render($options[:similar], $options[:json], $options[:geo])
      else
        puts "\nArgument Problem\n".colorize(:red)
        exit
    end
  end
end