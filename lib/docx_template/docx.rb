require 'zip'

module DocxTemplate

  class DocxTemplate::Docx
    attr_reader :dest_path, :file_path, :entity_replacer_list
    def initialize(file_path)
      @file_path = file_path
      @entity_replacer_list = []
    end

    def replace_text(src_text, dest_text, multiple_occurances=false)
      @entity_replacer_list << EntityReplacer.new(src_text, dest_text, multiple_occurances)
    end

    def replace_image(src_image, dest_image_file_name)
      replacer = EntityReplacer.new(src_image, dest_image_file_name)
      replacer.type = "IMAGE"
      @entity_replacer_list << replacer
    end

    def save(dest_path=Dir.mktmpdir)
      @dest_path = dest_path
      buffer = nil
      Zip::File.open(@file_path) do |zip_file|
        buffer = Zip::OutputStream.write_buffer do |out|
          zip_file.entries.each do |e|
            unless [DOCUMENT_FILE_PATH, RELS_FILE_PATH].include?(e.name)
              out.put_next_entry(e.name)
              out.write e.get_input_stream.read
             end
          end

          @entity_replacer_list.each do |replacer|
            if replacer.type == "FILE"
              out.put_next_entry(DOCUMENT_FILE_PATH)
              out.write zip_file.read(DOCUMENT_FILE_PATH).gsub(replacer.src_entity,replacer.dest_entity)
            elsif replacer.type == "IMAGE"
              puts "nothing happens here in image"
            else
              out.put_next_entry(RELS_FILE_PATH)
              out.write rels.to_xml(:indent => 0).gsub("\n","")
            end
          end

        end
      end

      File.open(dest_path, "w") {|f| f.write(buffer.string) }
    end

    private

    DOCUMENT_FILE_PATH = "word/document.xml"
    IMAGES_DIR_PATH = "word/media"
    RELS_FILE_PATH = "word"



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