require 'singleton'
require_relative 'm3u_parse'

class CreateM3u
  include Singleton

  def call(file_name_input, file_name_output, query)
    return [] unless check_existence_of_input_file?(file_name_input)
    @video_list = []
    object_m3u = M3uParse.new(file_name_input).video_list
    string_m3u = if !query[:title].empty? && query[:group_title].empty?
                   create_string_title(
                     object_m3u,
                     query[:title]
                   )
                 else
                   create_string_group_title(
                     object_m3u, query[:group_title]
                   )
                 end
    file_write(file_name_output, string_m3u)
    @video_list
  end

  private

  def create_string_title(object_m3u, query)
    string_m3u = "#EXTM3U\n"
    for m3u in object_m3u do
      next unless m3u[:title].downcase.include?(query.downcase)

      string_m3u.concat("#EXTINF:-1 tvg-id=\"#{m3u[:tvg_id]}\" tvg-name=\"#{m3u[:tvg_name]}\" tvg-logo=\"#{m3u[:tvg_logo]}\" group-title=\"#{m3u[:group_title]}\",#{m3u[:title]}\n")
      string_m3u.concat("#{m3u[:localization]}\n")
      @video_list.append(m3u)
    end
    string_m3u
  end

  def create_string_group_title(object_m3u, query)
    string_m3u = "#EXTM3U\n"
    for m3u in object_m3u do
      next unless m3u[:group_title].downcase.include?(query.downcase)

      string_m3u.concat("#EXTINF:-1 tvg-id=\"#{m3u[:tvg_id]}\" tvg-name=\"#{m3u[:tvg_name]}\" tvg-logo=\"#{m3u[:tvg_logo]}\" group-title=\"#{m3u[:group_title]}\",#{m3u[:title]}\n")
      string_m3u.concat("#{m3u[:localization]}\n")
      @video_list.append(m3u)
    end
    string_m3u
  end

  def file_write(filename, query)
    File.write("#{OUTPUT_FILE_FOLDER}#{filename}", query)
  end

  def check_existence_of_input_file?(filename)
    file_path = "#{INPUT_FILE_FOLDER}#{filename}"
    existence = File.exist?(file_path)
    puts "O arquivo \"#{file_path}\" não encontrado" unless existence
    existence
  end
end
