require 'spec_helper'

RSpec.describe DocxTemplate::Docx do

  before(:all) do
    @docx_verifier = SpecHelper::DocxVerifier.new
  end
  
  it "Replaces text once" do
    template = DocxTemplate::Docx.new "spec/unit/templates/docx_template.docx"
    template.replace_text("##SINGLE_REPLACE_TEXT##", "DOCX_TEMPLATE_REPLACE_TEXT")
    template.save("/tmp/a.docx")
    expect(@docx_verifier.verify_text_exists?("/tmp/a.docx", "##SINGLE_REPLACE_TEXT##")).to be(false)
    expect(@docx_verifier.verify_text_exists?("/tmp/a.docx", "DOCX_TEMPLATE_REPLACE_TEXT")).to be(true)
  end

  it "Replaces text multiple occurances" do
    template = DocxTemplate::Docx.new "spec/unit/templates/docx_template.docx"
    template.replace_text("##MULTIPLE_REPLACE_TEXT##", "DOCX_TEMPLATE_REPLACE_TEXT", true)
    template.save("/tmp/a.docx")
    expect(@docx_verifier.verify_text_exists?("/tmp/a.docx", "##MULTIPLE_REPLACE_TEXT##")).to be(false)
    expect(@docx_verifier.verify_text_exists?("/tmp/a.docx", "DOCX_TEMPLATE_REPLACE_TEXT")).to be(true)
  end

  it "Replaces an image" do
    template = DocxTemplate::Docx.new "spec/unit/templates/docx_template.docx"
    template.replace_image("image1.jpeg", "spec/unit/images/image5.jpg")
    template.save("/tmp/a.docx")
    expect(@docx_verifier.verify_image_exists?("/tmp/a.docx", "image1.jpeg", "spec/unit/images/image5.jpg")).to be(true)
  end

  it "Replaces text in header" do
    template = DocxTemplate::Docx.new "spec/unit/templates/docx_template.docx"
    template.replace_header("##HEADER_REPLACE_TEXT##", "DOCX_TEMPLATE_REPLACE_TEXT", true)
    template.save("/tmp/a.docx")
    expect(@docx_verifier.verify_text_exists?("/tmp/a.docx", "##HEADER_REPLACE_TEXT##")).to be(false)
    #TODO: implement for header searching
    #expect(@docx_verifier.verify_text_exists?("/tmp/a.docx", "DOCX_TEMPLATE_REPLACE_TEXT")).to be(true)
  end

  # Negative cases
  it "Handling nil substitutions for replace_text" do
    template = DocxTemplate::Docx.new "spec/unit/templates/docx_template.docx"
    template.replace_text("##MULTIPLE_REPLACE_TEXT##", nil)
    template.save("/tmp/a.docx")
    expect(@docx_verifier.verify_text_exists?("/tmp/a.docx", "##MULTIPLE_REPLACE_TEXT##")).to be(false)
  end

  it "Handling non existing file for replace_image" do
    template = DocxTemplate::Docx.new "spec/unit/templates/docx_template.docx"
    template.replace_image("image1.jpeg", "a/non/existing/image.jpg")
    template.save("/tmp/a.docx")
    expect(@docx_verifier.verify_image_exists?("/tmp/a.docx", "image1.jpeg", "spec/unit/images/image5.jpg")).to be(false)
  end

  # Ref: http://yehudakatz.com/2010/05/05/ruby-1-9-encodings-a-primer-and-the-solution-for-rails/
  it "Handling special characters for replace_text" do
    Zip.unicode_names = true
    template = DocxTemplate::Docx.new "spec/unit/templates/docx_template.docx"
    dest_str = "1 Rummun päät tukossa: test\n"
    template.replace_text("##MULTIPLE_REPLACE_TEXT##", dest_str.force_encoding('ASCII-8BIT'), true)
    template.save("/tmp/a.docx")
    expect(@docx_verifier.verify_text_exists?("/tmp/a.docx", "##MULTIPLE_REPLACE_TEXT##")).to be(false)
    expect(@docx_verifier.verify_text_exists?("/tmp/a.docx", dest_str.force_encoding('ASCII-8BIT'))).to be(true)
  end

end