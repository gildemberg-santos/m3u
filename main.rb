require_relative 'config'
require_relative 'lib/download_m3u'
require_relative 'lib/create_m3u'
require_relative 'lib/teste'

@title_terminal = ''
@group_title_terminal = ''
@print_terminal = false
@no_cache_m3u = true
@url_m3u = LINK_M3U
download = DownloadM3u.new(@url_m3u)
@file_name_m3u = download.name
@filter = { title: '', group_title: '' }

ARGV.each do |arg|
  if arg.include?('title')
    @title_terminal = arg.split('=')[1].to_s || ''
  elsif arg.include?('group')
    @group_title_terminal = arg.split('=')[1].to_s || ''
  elsif arg.include?('output')
    @print_terminal = true
  elsif arg.include?('cache')
    @no_cache_m3u = false
  end
end

download.start unless @no_cache_m3u

if !@title_terminal.empty? && @group_title_terminal.empty?
  @filter = { title: @title_terminal, group_title: '' }
elsif @title_terminal.empty? && !@group_title_terminal.empty?
  @filter = { title: '', group_title: @group_title_terminal }
end

video_list = CreateM3u.instance.call(@file_name_m3u, OUTPUT_FILE_NAME, @filter)

if @print_terminal
  video_list.each do |video|
    puts video[:title]
    puts video[:group_title]
    puts video[:localization]
    puts "\n\n"
  end
end

puts 'Link de configuração da tv'
puts LINK_CONFIG_TV
