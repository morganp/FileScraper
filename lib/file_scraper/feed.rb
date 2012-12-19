

module FileScraper

  class Feed

    def self.fetch( source )
      #http://rubyrss.com//
      #Read RSS Feed
      content = "" # raw content of rss feed will be loaded here

      open( source ) do |s| content = s.read end
      rss = RSS::Parser.parse(content, false)
      
      ## Return items (to allow chaining filters)
      ##   
      return rss.items
    end 

    def self.list( data )
      data.items.each do |item|
        name          = "#{item.title}" #This does not include fileextension
        puts name
      end 
    end

  end
end

