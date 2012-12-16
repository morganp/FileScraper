

module FileScraper

  class Filter
    
    def initialize( rss_data, path, search_path, block_path, options={})
      @rss_data      = rss_data
      @download_path = path
      @quiet         = options[:quiet] || false

      ## Validate source (non nill check)
      if @rss_data.nil?
        $stderr.puts "rss_data not supplied"
        exit -1
      end

    end

    def run
      ## TODO implement filters
      @rss_data.items.each do |item|
        name          = "#{item.title}" #This does not include fileextension
        puts name
      end 
    end
  end
end

