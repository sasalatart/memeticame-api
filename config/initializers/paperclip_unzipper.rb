require 'zip'

module Paperclip
  class Unzipper < Processor
    attr_accessor :resolution, :whiny

    def initialize(file, options = {}, attachment = nil)
      super
      @file = file
      @whiny = options[:whiny].nil? ? true : options[:whiny]
      @basename = File.basename(@file.path, File.extname(@file.path))
      @attachment = attachment
    end

    def make
      path_to_return = @file.path
      dir_path = "public/system/unzipped/#{@attachment.original_filename}"

      Zip::File.open(@file.path) do |zip_file|
        zip_file.each do |entry|
          puts "Extracting #{entry.name}"

          f_path = File.join(dir_path, entry.name)
          FileUtils.mkdir_p(File.dirname(f_path))
          zip_file.extract(entry, f_path) unless File.exist?(f_path)

          next unless MIME::Types.type_for(f_path).first.content_type.include?('image')

          image = MiniMagick::Image.open(f_path)
          image.resize '640x480>'
          image.write(f_path)

          path_to_return = f_path
        end
      end

      # you return a file handle which is the processed result
      dest = File.new(path_to_return)
    end
  end
end
