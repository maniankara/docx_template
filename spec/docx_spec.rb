require 'spec_helper'

RSpec.describe DocxTemplate::Docx do

  before(:all) do
    @docx_verifier = SpecHelper::DocxVerifier.new
  end
  
  it "Replaces text once" do
    template = DocxTemplate::Docx.new "spec/unit/templates/docx_template.docx"
    template.replace_text("##SINGLE_REPLACE_TEXT##", "here")
    template.save("/tmp/a.docx")
    expect(@docx_verifier.verify_text_exists?("/tmp/a.docx", "##SINGLE_REPLACE_TEXT##")).to be(false)
  end

  it "Replaces text multiple occurances" do
    template = DocxTemplate::Docx.new "spec/unit/templates/docx_template.docx"
    template.replace_text("##MULTIPLE_REPLACE_TEXT##", "here")
    template.save("/tmp/a.docx")
    expect(@docx_verifier.verify_text_exists?("/tmp/a.docx", "##MULTIPLE_REPLACE_TEXT##")).to be(false)
  end

  it "Replaces an image" do
    template = DocxTemplate::Docx.new "spec/unit/templates/docx_template.docx"
    template.replace_image("image1.jpeg", "spec/unit/images/image5.jpg")
    template.save("/tmp/a.docx")
    expect(@docx_verifier.verify_image_exists?("/tmp/a.docx", "image1.jpeg", "spec/unit/images/image5.jpg")).to be(true)
  end

  it "Replaces text in header" do
    template = DocxTemplate::Docx.new "spec/unit/templates/docx_template.docx"
    template.replace_header("##HEADER_REPLACE_TEXT##", "here")
    template.save("/tmp/a.docx")
    expect(@docx_verifier.verify_text_exists?("/tmp/a.docx", "##HEADER_REPLACE_TEXT##")).to be(false)
  end

  # Negative cases
  it "Handling nil substitutions" do
    template = DocxTemplate::Docx.new "spec/unit/templates/docx_template.docx"
    template.replace_text("##MULTIPLE_REPLACE_TEXT##", nil)
    template.save("/tmp/a.docx")
    expect(@docx_verifier.verify_text_exists?("/tmp/a.docx", "##MULTIPLE_REPLACE_TEXT##")).to be(false)
  end

  
end