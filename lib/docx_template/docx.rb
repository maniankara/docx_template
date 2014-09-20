require 'zip'

module DocxTemplate

  class DocxTemplate::Docx
    attr_reader :dest_path, :file_path, :text_replacer_list, :image_replacer_list
    def initialize(file_path)
      @file_path = file_path
      @text_replacer_list = []
      @image_replacer_list = []
    end

    def replace_text(src_text, dest_text, multiple_occurances=false)
      @text_replacer_list << EntityReplacer.new(src_text, dest_text, multiple_occurances)
    end

    def replace_image(src_image_file_name, dest_image_file)
      replacer = EntityReplacer.new(src_image_file_name, dest_image_file, false)
      replacer.type = "IMAGE"
      @image_replacer_list << replacer
    end

    def save(dest_path=Dir.mktmpdir)
      @dest_path = dest_path
      buffer = nil
      Zip::File.open(@file_path) do |zip_file|
        buffer = Zip::OutputStream.write_buffer do |out|
          exclusion_files_list = derive_exclusion_file_list
          prepare_rest_of_archive(zip_file, out, exclusion_files_list)
          # text part
          unless @text_replacer_list.empty?
            out.put_next_entry(DOCUMENT_FILE_PATH)
            replacer = @text_replacer_list.first
            out.write zip_file.read(DOCUMENT_FILE_PATH).gsub(replacer.src_entity,replacer.dest_entity)
          end
          # image part
          @image_replacer_list.each do |replacer|
            out.put_next_entry("#{IMAGES_DIR_PATH}/#{replacer.src_entity}")
            out.write File.read(replacer.dest_entity)
          end
        end
      end

      File.open(dest_path, "w") {|f| f.write(buffer.string) }
    end

    private

    DOCUMENT_FILE_PATH = "word/document.xml"
    IMAGES_DIR_PATH = "word/media"
    RELS_FILE_PATH = "word"

    def prepare_rest_of_archive(zip_file, out, exclude_list)
      zip_file.entries.each do |e|
        unless exclude_list.include?(e.name)
          out.put_next_entry(e.name)
          out.write e.get_input_stream.read
         end
      end
    end

    def derive_exclusion_file_list
      e_list = []
      unless @text_replacer_list.empty?
        e_list << DOCUMENT_FILE_PATH
      end
      @image_replacer_list.each do |replacer|
        e_list << "#{IMAGES_DIR_PATH}/#{replacer.src_entity}"
      end
      e_list
    end


    class EntityReplacer
      attr_reader :src_entity, :dest_entity, :occurances
      attr_writer :type
      def initialize(src, dest, occurances)
        @src_entity = src
        @dest_entity = dest
        @occurances = occurances
      end

      def type
        @type || "FILE"
      end
    end

  end

end