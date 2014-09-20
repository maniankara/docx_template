require 'spec_helper'

RSpec.describe DocxTemplate::Docx do
  it "Replaces text once" do
    template = DocxTemplate::Docx.new "/home/anovil/tmp/docx_template/spec/unit/templates/docx_template.docx"
    template.replace_text("##SINGLE_REPLACE_TEXT##", "here")
    template.save("/tmp/a.docx")
  end
end