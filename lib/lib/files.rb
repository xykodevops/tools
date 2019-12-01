require 'singleton'
class ToolsFiles
  include Singleton

  def initialize(options = {})
  end


  # Purge files in directory
  #
  #  Sample
  # ToolsFiles. purge_files Cmdapi.configuration.home+'/.cmdapi/backup', '*',   14*24*60*60'
  #
  # @param path_to_clean
  # @param select (sample: *.log)
  # @param elipsed_time in seconds (sample: 2 weeks = 14*24*60*60)
  # @return
  def self.purge_files path, select, time #Cmdapi.configuration.home+'/.cmdapi/backup', '*',   14*24*60*60
    to_clean = Dir.glob(File.join(path, select)).select { |a|
      Time.now - File.ctime(a) > time }
    to_clean.each do |file_to_delete|
      File.delete(file_to_delete)
    end
  end


  # Create a directory in work area
  #
  #  Sample
  # ToolsFiles.create_dir Tools.home + '/2018/xykotools/tools/home', 'tools_home'
  # home = (ToolsUtil.get_variable 'tools_home') => ~/2018/xykotools/tools/home
  #
  # @param directory
  # @param directory_name
  # @return
  def self.create_dir directory, directory_name
    unless directory.end_with? '/'
      directory += '/'
    end
    complete_file = (directory + '/').gsub('//','/')
    unless File.exists? complete_file
      Dir.mkdir(complete_file)
    end
    ToolsUtil.set_variable directory_name, complete_file
  end

  # Create a file in work area
  #
  #  Sample
  #
  #  ToolsFiles.create_file home, 'xyko_file.txt', 'xyko_file'
  #  xyko = (ToolsUtil.get_variable 'xyko_file') => ~/2018/xykotools/tools/home/xyko_file.txt
  #
  # @param directory
  # @param file_name
  # @param file_name_set
  # @return
  def self.create_file directory, file_name, file_name_set
    complete_file = (directory + '/' + file_name).gsub('//','/')
    unless File.exists? complete_file
      file = File.open( complete_file , 'w')
    end
    ToolsUtil.set_variable file_name_set, complete_file
  end

  # Load a file in work area
  #
  #  Sample
  #
  #  ToolsFiles.load_file file_to_load
  # @param file_to_load Object
  # @return
  def self.load_file file_to_load
    if File.exists? file_to_load
      file = File.open( file_to_load , 'r')
      return file
    end
  end

  # Delete a file in work area
  #
  #  Sample
  #
  #  ToolsFiles.delete_file file_to_delete
  # @param file_to_delete Object
  # @return
  def self.remove_file file_to_removee
    if File.exists? file_to_removee
      file = FileUtils.remove_file( file_to_removee )
      return file
    end
  end


  def self.open_file file, default_editor=nil
    begin
      if default_editor.nil?
        TTY::Editor.open( file, command: :vi)
      else
        TTY::Editor.open( file, command: default_editor)
      end
    rescue Exception => e
      return e
    end
  end

end



