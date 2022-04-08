class M3uParse
  def initialize(file_name)
    @video_list = []
    @file_name = file_name
    read_file
  end

  attr_accessor :video_list

  private

  def get_attributes(line)
    line = line.gsub('#EXTINF:-1 ', '')
    line = line.gsub('tvg-id=', '')
    line = line.gsub('tvg-name=', '')
    line = line.gsub('tvg-logo=', '')
    line = line.gsub('group-title=', '')
    line = line.gsub('",', '|')
    line = line.gsub('" ', '"')
    line = line.gsub(' "', '"')
    line = line.gsub('""', '|')
    line = line.gsub('"', '')
    line = line.gsub(', ', ' ')
    line = line.gsub("\r\n", '|')
    line = line.slice 0..-2
    quant = line.split('|').count
    extract_data = line.split('|')
    puts 'Erro na leitura' if quant != 6

    video = {
      tvg_id: extract_data[0],
      tvg_name: extract_data[1],
      tvg_logo: extract_data[2],
      group_title: extract_data[3],
      title: extract_data[4],
      localization: extract_data[5]
    }

    @video_list.push(video)
  end

  def read_file
    arq = File.readlines("#{INPUT_FILE_FOLDER}#{@file_name}")
    amount_line = arq.count

    amount_line.times do |i|
      next unless arq[i].include?('#EXTINF:-1')

      get_attributes arq[i].concat arq[i + 1]
    end
  end
end
