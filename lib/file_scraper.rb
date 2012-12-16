
module FileScraper
  VERSION = '0.0.1'
end
  
  require 'rss/1.0'
  require 'rss/2.0'
  require 'open-uri'
  require 'httpclient'

begin
  require_relative 'file_scraper/filter'
  require_relative 'file_scraper/feed'
rescue
  require 'file_scraper/filter'
  require 'file_scraper/feed'
end
