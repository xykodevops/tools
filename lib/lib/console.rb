require 'singleton'
class ToolsConsole
  include Singleton


  def self.create_console

      extend Prompt::DSL

      group "Console commands"

      desc "configure"
      param :config_type , "Config type search for roots locations...", %(location show)
      command "config :config_type" do |config_type|

        Prompt.application.prompt = "#{Tools.configuration.console_prompt} console > ".light_blue
        puts "Choise yuor config action .:".yellow

      end

      desc "history"
      command "history" do
        File.open(@history_file, 'r') do |f|
          while line = f.gets
            puts line
          end
        end
      end

      desc "test"
      command "test" do
        puts 'Im a test.!'.yellow
      end

  end

  def self.my_method_missing
    ap "my_method_missing"
  end

  def self.run_console
      Prompt.application.prompt = "#{Tools.configuration.console_prompt} console > ".light_green
      @history_file = File.join(File.expand_path(File.dirname(__FILE__)).to_s, ".workin-history")
      Prompt::Console.start @history_file
  end

end








# class Console

# 	def initialize(options = {})
# 		commands
# 	end

#   def commands

#   	extend Prompt::DSL 

# 		group "Commands"

# 		desc "config"
# 		command "config" do ||
# 			Prompt.application.prompt = " tools > ".light_blue
# 		end

# 		desc "show"
# 		command "show :param" do |param|
# 			case param
# 			when 'config'
# 				puts "ROOT      .: #{Tools.root}"
# 				puts "USER      .: #{Tools.configuration.user}"
# 				puts "HOME      .: #{Tools.configuration.home}"
# 				puts "PWD       .: #{Tools.configuration.pwd}"
# 				puts "ldap_user .: #{Tools.configuration.ldap_user}"
# 				puts "ldap_pass .: #{Tools.configuration.ldap_pass}"
# 				Tools.configuration.info.each do |k,v|
# 					ap k
# 					ap v
# 				end
# 			else 
# 				ap Tools.get_variable param
# 			end
# 		end

# 		desc "rsync"
# 		command "rsync :from :to" do |from, to|

# ap Tools.configuration.info[:directorys_to][from].nil?

# 			unless Tools.configuration.info[:directorys_to][from].nil?
# 			 from = Tools.configuration.info[:directorys_to][from]
# 			 from += ask("?? ") 
# 			else
# 				sourcefiles = File.join("**", from)
# 				Dir.glob(sourcefiles).each do |source|
# 					ap source
# 				end
# 			end

# ap from

# 					# if File.file?(source)
# 					# 	result = Rsync.run(source, dest)
# 					# 	ap result
# 					# end

# 		end

# 		desc "connect"
# 		command "connect :host" do |host|
# 			if host.split('@').size == 2
# 				user = host.split('@')[0]
# 				host = host.split('@')[1]
# 			else
# 				unless Tools.configuration.info[:servers][host].nil?
# 					user = Tools.configuration.info[:servers][host].split('@')[0]
# 					host = Tools.configuration.info[:servers][host].split('@')[1]
# 				else
# 					ap "No hosts selected! Exiting..."
# 				end
# 			end
# 			ssh = Tools.ssh_connect_knowhost host, user
# 			Tools.set_variable 'ssh', ssh
# 		end


# 		desc "cmd"
# 		command "cmd :variable :command " do |variable, command|
# 			ssh = Tools.get_variable 'ssh'
# 			Tools.set_variable variable, (Tools.ssh_cmd ssh, command).split("\n")
# 		end


# 		Prompt.application.prompt = " tools > ".light_red
# 		history_file = ".tools-history"  
# 		Prompt::Console.start history_file

#   end

# end
