

module FileScraper

  class Download

    def self.run(data, download_path )
      
      data.each do |item|
        name          = item.title
        download_name = File.join( download_path, name)

        if not File.exist?( download_name )  
          puts "--> #{name}"
          open( download_name, 'wb') do |file|
            file << open( item.link ).read
          end
        else 
          puts "Got #{name}"
        end
      end
    end

  end
end

