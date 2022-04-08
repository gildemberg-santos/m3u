require 'uri'

class DownloadM3u
  def initialize(url)
    @url = url
    get_name
    create_folders
  end

  attr_accessor :m3u, :name

  def start
    system("wget #{@url} --output-document=#{INPUT_FILE_FOLDER}#{get_name}")
  end

  private

  def get_name
    file_name = URI.parse(@url).path.gsub('/', '')
    @name = file_name.concat('.m3u')
    @name
  end

  def create_folders
    Dir.mkdir(FOLDER) unless File.exist?(FOLDER)
    Dir.mkdir(DB_FILE_FOLDER) unless File.exist?(DB_FILE_FOLDER)
    Dir.mkdir(INPUT_FILE_FOLDER) unless File.exist?(INPUT_FILE_FOLDER)
    Dir.mkdir(OUTPUT_FILE_FOLDER) unless File.exist?(OUTPUT_FILE_FOLDER)
  end
end
