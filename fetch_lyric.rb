#!/bin/ruby
require 'uri'
require 'nokogiri'
require 'open-uri'

class Lyric
  MAX_RESCUE_NUM = 3
  BASE_URL = 'http://j-lyric.net/artist/a0566ec/'.freeze
  SEARCH_URL = 'http://search.j-lyric.net/index.php'.freeze

  PARAM_SEARCH_BY_ARTIST = 'ka=%s&'.freeze
  PARAM_SEARCH_BY_TITLE = 'kt=%s&'.freeze
  PARAM_SEARCH_BY_LYRIC = 'kl=%s&'.freeze

  #
  def self.fetch_titles(queries)

    params = create_params queries

    puts "#{SEARCH_URL}?#{params}"
    res = request "#{SEARCH_URL}?#{params}"
    doc = Nokogiri::HTML.parse(res.read)

    lists = doc.css('#mnb .bdy a')
    results = []
    lists.each do |list, _index|
      results << { href: list[:href], title: list[:title] }
    end
    results
  end

  def self.create_params(queries)
    params = ''
    queries.each do |key, value|
      case key.to_s
      when 'title' then
        params += format(PARAM_SEARCH_BY_TITLE, value)
      when 'artist' then
        params += format(PARAM_SEARCH_BY_ARTIST, value)
      when 'lyric' then
        params += format(PARAM_SEARCH_BY_LYRIC, value)
      end
    end
    params
  end

  #
  def self.get_lyric_by_url(url)
    res = request url
    doc = Nokogiri::HTML.parse(res.read)
    doc.css('#Lyric').to_s.gsub('<br>', "\n")
  end

  private

  def self.request(url)
    rescue_num = 0
    begin
      res = open(URI.escape(url))
    rescue => e
      print 'error raise in rescue: '
      p e
      if rescue_num < MAX_RESCUE_NUM
        sleep 0.25
        rescue_num += 1
        retry
      else
        res = nil
      end
    end
    res
  end
end

# main 
if ARGV.count < 2 || ARGV.count.odd?
  raise "ruby #{$PROGRAM_NAME} [-t Title | -a Artist | -l Lyric]"
end

count = 0
search_queries = {}
# get argv and create hash
while ARGV.count / 2 > count
  case ARGV[count * 2]
  when '-t' then
    search_queries.merge!({ title: ARGV[count * 2 + 1] })
  when '-a' then
    search_queries.merge!({ artist: ARGV[count * 2 + 1] })
  when '-l' then
    search_queries.merge!({ lyric: ARGV[count * 2 + 1] })
  else
    raise "ruby #{$PROGRAM_NAME} [-t Title | -a Artist | -l Lyric]"
  end
  count += 1
end

puts search_queries

results = Lyric.fetch_titles search_queries

if results.count < 1
  puts 'nothing results.'
  exit
end

results.each_with_index do |result, index|
  puts "#{index}: #{result[:title]} (#{result[:href]})"
end

loop do
  print 'what do you want see? input number or exit => -1:'
  input_number = STDIN.gets.delete("\n").to_i
  if input_number === -1
    puts 'inuputed exist number(-1)'
    exit
  end
  if results[input_number].nil?
    puts 'invalid number. please input number(0 <= num < #{hashes.count}) or exit => -1'
    next
  end

  puts "\e[H\e[2J" # insted clear command
  puts Lyric.get_lyric_by_url results[input_number][:href]
  break
end
