require 'nokogiri'
require 'rubygems'
require 'open-uri'


search_page = "http://jobs.rubynow.com/"
search_results = Nokogiri::HTML(open(search_page))
puts search_results

jobs_array = search_results.css('#jobs-list a:nth-child(1)').map { |n| n['href'] }
