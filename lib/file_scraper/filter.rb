

module FileScraper

  class Filter
    ## Constants
    SEPERATOR  = '[-\._ ]'
    def SEPERATOR? 
      "#{SEPERATOR}?"
    end
    
    def initialize( rss_data, path, search_path, block_path, options={})
      @rss_data      = rss_data
      @download_path = path
      @quiet         = options[:quiet] || false

      @search        = open_file_or_url( search_path )

      ## Validate source (non nill check)
      if @rss_data.nil?
        $stderr.puts "rss_data not supplied"
        exit -1
      end

    end

    def run
      matched_data = Array.new
      @rss_data.each do |item|
        name          = "#{item.title}" #This does not include file extension

        matched = @search.any? do |regexp|
          name.match(regexp)
        end
        if matched 
          matched_data << item
        end

        ## Debugging info
        puts name
      end 

      return matched_data
    end


    def open_file_or_url path
      require 'open-uri'
      if path.nil?
        return []
      end
      if path.match(/^http/) 
        open( path, "rb").map{ |line| parse_regexp( line.strip ) } 
      else 
        ::File.open( path, "rb").map{ |line| parse_regexp( line.strip ) } 
      end
    end


    def parse_regexp( a_string )
      arr     = a_string.split('/')
      if  arr == ''
        $stderr.puts "Blank Regular expression '#{a_string}'"
      end
      main    = arr[1]
      options = arr[2] 

      main.gsub!('#{SEPERATOR}', '[-\._ ]')
      main.gsub!('#{SEPERATOR?}', '[-\._ ]?')

      Regexp.new(main, Regexp::IGNORECASE)
    end


  end
end

