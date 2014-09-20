require 'docx_template/docx'

module SpecHelper

  class DocxVerifier

    def verify_text_exists?(docx_file_path, search_text)
      Zip::File.open(docx_file_path) do |zip_file|
        zip_file.entries.each do |entry|
          next if entry.name != DOCUMENT_FILE_PATH
          file_contents = entry.get_input_stream.read
          return true if file_contents.include?(search_text)
        end
      end
      return false
    end

    # verifies if the sizes of file are same
    def verify_image_exists?(docx_file_path, src_image, expected_image)
      Zip::File.open(docx_file_path) do |zip_file|
        zip_file.entries.each do |entry|
          next if entry.name != "#{IMAGE_DIR_PATH}/#{src_image}"
          archive_file_contents = entry.get_input_stream.read
          return archive_file_contents.size == File.size(expected_image)
        end
      end
      return false
    end

    private

    DOCUMENT_FILE_PATH = 'word/document.xml'
    IMAGE_DIR_PATH = 'word/media'
  end
end