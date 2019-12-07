#!/usr/bin/ruby
#
# https://api-portal.nhk.or.jp/ja
# http://api-portal.nhk.or.jp/doc-request
#
#
require 'oauth2'
require 'json'
require 'net/http'
require 'uri'

CONF_DIR = '/usr/local/etc/nhk-prginfo'
LIB_DIR  = '/usr/local/lib/nhk-prginfo'

require File.expand_path('genre_code', LIB_DIR)

APIKEY_FILE  = File.expand_path('apikey.conf', CONF_DIR)
AREA_FILE    = File.expand_path('areas.dat', CONF_DIR)
SERVICE_FILE = File.expand_path('services.dat', CONF_DIR)

class String
  public
  # 文字列の画面表示幅を算出する。
  # 注意：ASCII 文字のみを half width 文字としている。
  def jwidth()
    return self.length + self.chars.reject(&:ascii_only?).length
  end
end

class HTTPCommError < ::IOError
  attr_reader :http_code, :http_message
  public
  def initialize(message, http_code, http_message)
    @http_code = http_code
    @http_message = http_message
    super(message)
  end
end

def get_apikey()
  key = ""
  File.open(APIKEY_FILE) do |f|
    line = f.gets
    key = line[/[^\s]+$/]
  end
  return key
end

APIKEY = get_apikey()

# -------------------------------------------------------------------
def read_area(fname)
  area = []
  File.open(fname) do |f|
    while line = f.gets do
      area.concat(line.chomp.split(/,\s*/))
    end
  end
  return area
end
# -------------------------------------------------------------------
def read_service(fname)
  service = []
  File.open(SERVICE_FILE) do |f|
    while line = f.gets do
      service << line.chomp
    end
  end
  return service
end
# -------------------------------------------------------------------
def print_area_list(area)
  i = 0
  step = 5
  max_width = area.max{|a, b| a.jwidth <=> b.jwidth}.jwidth
  while i < area.size do
    line = ""
    size = area[i..(i + step)].size
    area[i..(i + step)].each.with_index do |a, idx|
      padding_len = max_width - a.jwidth
      line += "#{a}"
      if idx < size - 1 then
        line += ", "
        for n in Range.new(0, padding_len - 1) do
          line += " "
        end
      end
    end
    if i < area.size - step then
      puts("    #{line},")
    else
      puts("    #{line}")
    end
    i += 5
  end
end
# -------------------------------------------------------------------
def usage()
  $stderr.puts(<<EOF__
Usage: #{File.basename($0)} command

  command:
      help
    テキスト形式で出力
      list  area service YYYY-MM-DD
      genre area service genre-code YYYY-MM-DD
      info  area service program-id
      nowonair area service
    JSON 形式で出力
      jlist  area service YYYY-MM-DD
      jgenre area service genre-code YYYY-MM-DD
      jinfo  area service program-id
      jnowonair area service

EOF__
)

  area = read_area(AREA_FILE)
  service = read_service(SERVICE_FILE)

  $stderr.puts("  area:")
  print_area_list(area)
  $stderr.puts()
  $stderr.puts("  service:")
  service.each do |s|
    $stderr.puts("    " + s)
  end
end

# -------------------------------------------------------------------
def endpoint_program_list(area, service, date, apikey)
  return "http://api.nhk.or.jp/v2/pg/list/#{area}/#{service}/#{date}.json?key=#{apikey}"
end

def endpoint_by_genre(area, service, genre, date, apikey)
  return "http://api.nhk.or.jp/v2/pg/genre/#{area}/#{service}/#{genre}/#{date}.json?key=#{apikey}"
end

def endpoint_program_info(area, service, prog_id, apikey)
  return "http://api.nhk.or.jp/v2/pg/info/#{area}/#{service}/#{prog_id}.json?key=#{apikey}"
end

def endpoint_now_on_air(area, service, apikey)
  return "http://api.nhk.or.jp/v2/pg/now/#{area}/#{service}.json?key=#{apikey}"
end

# -------------------------------------------------------------------
def download_data(endpoint)
  ret = nil
  url = URI.parse(endpoint)
  req = Net::HTTP::Get.new("#{url.path}?#{url.query}")
  res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
  }
  hash = nil
  if res.is_a?(Net::HTTPSuccess) then
    File.open('result.json', 'w') do |f|
      hash = JSON.parse(res.body, :symbolize_names => true)
      f.puts(hash.to_json())
    end
    ret = JSON.parse(res.body, :symbolize_names => true)
  else
    $stderr.puts("Download error:")
    $stderr.puts(res.code)
    $stderr.puts(res.message)
    $stderr.puts(res.body)
  end
  return ret, res
end

# -------------------------------------------------------------------
def program?(hash, service)
  return hash[:list][service][0].has_key?(:act)
end
# -------------------------------------------------------------------
def description?(hash, service)
  return !hash[:list][service][0].has_key?(:act)
end

# -------------------------------------------------------------------
def show_programs(hash, service)
  hash.each do |key, val|
    puts("key: #{key}")
  end 
  if hash.has_key?(:list) then
    if hash[:list].nil? then
      $stderr.puts("WARNING: No information.")
    else
      hash[:list][service.to_sym].each do |key, val|
        start_time = Time.parse(key[:start_time]).localtime.strftime('%Y-%m-%d %H:%M:%S')
        end_time   = Time.parse(key[:end_time]).localtime.strftime('%Y-%m-%d %H:%M:%S')
        puts("Program ID  : #{key[:id]}")
        puts("Event ID    : #{key[:event_id]}")
        puts("Time        : #{start_time} - #{end_time}")
        puts("Title       : #{key[:title]}")
        puts("Subtitle    : #{key[:subtitle]}")
        key[:genres].each do |genre|
          genre_code = Integer(genre, 10)
          main_genre = genre_code.div(100) 
          subgenre   = genre_code - (main_genre * 100)
          if !!CONTENT_TYPE[main_genre] then
            main_genre_name = CONTENT_TYPE[main_genre][:genre]
            if !!CONTENT_TYPE[main_genre][:subgenre] then
              subgenre_name   = CONTENT_TYPE[main_genre][:subgenre][subgenre]
              puts("Genre       : #{genre} #{main_genre_name} (#{subgenre_name})")
            else
              puts("Genre       : #{genre} #{main_genre_name}")
            end
          else
            puts("Genre       : #{genre}")
          end
        end
        puts("Program URL : #{key[:program_url]}")
        puts("Episode URL : #{key[:episode_url]}")
        service = key[:service]
        puts("Servicei ID : #{service[:id]}")
        puts("Service name: #{service[:name]}")
        if key.has_key?(:act) then
          puts("Act         : #{key[:act]}")
        end
        if key.has_key?(:extras) then
          extras = key[:extras]
          puts("!!!!!! Extras:")
          puts("  On-demand program: #{extras[:ondemand_program]}")
          puts("  On-demand episode: #{extras[:ondemand_episode]}")
        end
        puts()
      end
    end
  end
end

# -------------------------------------------------------------------
def show_now_on_air(hash, service)
  if hash.has_key?(:nowonair_list) then
    if hash[:nowonair_list][service.to_sym] then
      if hash[:nowonair_list][service.to_sym].has_key?(:previous) then
        hash_for_disp = {:list => {}}
        hash_for_disp[:list][service.to_sym] = []
        hash_for_disp[:list][service.to_sym] << hash[:nowonair_list][service.to_sym][:previous]
        hash_for_disp[:list][service.to_sym] << hash[:nowonair_list][service.to_sym][:present]
        hash_for_disp[:list][service.to_sym] << hash[:nowonair_list][service.to_sym][:following]
        show_programs(hash_for_disp, service)
      end
    end
  end
end

# -------------------------------------------------------------------
def print_json(hash)
  $stdout.puts(hash.to_json)
end

# -------------------------------------------------------------------
# Main Routine
# -------------------------------------------------------------------

if ARGV.size < 1 || ARGV.size > 5 then
  usage()
  exit(1)
end

begin
  if ARGV.size == 3 then
    if ARGV[0] =~ /^j?nowonair$/ then
      area    = ARGV[1]
      service = ARGV[2]
      endpoint = endpoint_now_on_air(area, service, APIKEY)
      hash, httpres = download_data(endpoint)
      if hash.nil? then
        raise HTTPCommError.new("", httpres.code, httpres.message)
      end
      if ARGV[0][0] == 'j' then
        print_json(hash)
      else
        show_now_on_air(hash, service)
      end
    end
  elsif ARGV.size == 4 then
    if ARGV[0] =~ /^j?list$/ then
      area    = ARGV[1]
      service = ARGV[2]
      date    = ARGV[3]
      endpoint = endpoint_program_list(area, service, date, APIKEY)
      hash, httpres = download_data(endpoint)
      if hash.nil? then
        raise HTTPCommError.new("", httpres.code, httpres.message)
      end
      if ARGV[0][0] == 'j' then
        print_json(hash)
      else
        show_programs(hash, service)
      end
    elsif ARGV[0] =~ /^j?info$/ then
      area    = ARGV[1]
      service = ARGV[2]
      prog_id = ARGV[3]
      endpoint = endpoint_program_info(area, service, prog_id, APIKEY)
      hash, httpres = download_data(endpoint)
      if hash.nil? then
        raise HTTPCommError.new("", httpres.code, httpres.message)
      end
      if ARGV[0][0] == 'j' then
        print_json(hash)
      else
        show_programs(hash, service)
      end
    else
      usage()
      exit(1)
    end
  elsif ARGV.size == 5 then
    if ARGV[0] =~ /^j?genre$/ then
      area    = ARGV[1]
      service = ARGV[2]
      genre   = ARGV[3]
      date    = ARGV[4]
      endpoint = endpoint_by_genre(area, service, genre, date, APIKEY)
      hash, httpres = download_data(endpoint)
      if hash.nil? then
        raise HTTPCommError.new("", httpres.code, httpres.message)
      end
      if ARGV[0][0] == 'j' then
        print_json(hash)
      else
        show_programs(hash, service)
      end
    end
  else
    usage()
    exit(1)
  end

rescue HTTPCommError => e
  $stderr.puts("番組表を取得できませんでした。")
  $stderr.puts(e.http_code)
  $stderr.puts(e.message)
  exit(1)
end

exit(0)
