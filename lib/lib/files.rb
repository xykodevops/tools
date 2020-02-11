require 'singleton'
class ToolsFiles
  include Singleton

  def initialize(options = {}); end

  # Purge files in directory
  #
  #  Sample
  # ToolsFiles. purge_files Cmdapi.configuration.home+'/.cmdapi/backup', '*',   14*24*60*60'
  #
  # @param path_to_clean
  # @param select (sample: *.log)
  # @param elipsed_time in seconds (sample: 2 weeks = 14*24*60*60)
  # @return
  # Cmdapi.configuration.home+'/.cmdapi/backup', '*',   14*24*60*60
  def self.purge_files(path, select, time)
    to_clean = Dir.glob(File.join(path, select)).select do |a|
      Time.now - File.ctime(a) > time
    end
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
  def self.create_dir(directory, directory_name)
    directory += '/' unless directory.end_with? '/'
    complete_file = (directory + '/').gsub('//', '/')
    Dir.mkdir(complete_file) unless File.exist? complete_file
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
  def self.create_file(directory, file_name, file_name_set)
    complete_file = (directory + '/' + file_name).gsub('//', '/')
    File.open(complete_file, 'w') unless File.exist? complete_file
    ToolsUtil.set_variable file_name_set, complete_file
  end

  # Load a file in work area
  #
  #  Sample
  #
  #  ToolsFiles.load_file file_to_load
  # @param file_to_load Object
  # @return
  def self.load_file(file_to_load)
    return unless File.exist? file_to_load

    File.open(file_to_load, 'r')
  end

  # Delete a file in work area
  #
  #  Sample
  #
  #  ToolsFiles.delete_file file_to_delete
  # @param file_to_delete Object
  # @return
  def self.remove_file(file_to_remove)
    return unless File.exist? file_to_remove

    FileUtils.remove_file(file_to_remove)
  end

  def self.open_file(file, default_editor = nil)
    if default_editor.nil?
      TTY::Editor.open(file, command: :vi)
    else
      TTY::Editor.open(file, command: default_editor)
    end
  end

  def create_file_array file_name, content
    file = File.open(file_name, 'w')
    file.write content
    file.close
  end

  def create_file_lines file_name, content
    file = File.open(file_name, 'w')
    content.each do |line|
      file.puts line
    end
    file.close
  end

end
