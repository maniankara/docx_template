# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'docx_template/version'

Gem::Specification.new do |spec|
  spec.name          = "docx_template"
  spec.version       = "0.6"
  spec.authors       = ["Maniankara"]
  spec.email         = ["Maniankara@gmail.com"]
  spec.summary       = %q{Docx templating library which could replace docx contents such as text, images etc. in one go.}
  spec.description   = %q{
    template = DocxTemplate::Docx.new "/opt/docx_template.docx"
    template.replace_text("##SINGLE_REPLACE_TEXT##", "ACTUAL TEXT HERE")
    template.replace_text("##MULTI_REPLACE_TEXT##", "ACTUAL TEXT HERE", true)
    template.replace_header("##HEADER_REPLACE_TEXT##", "ACTUAL TEXT HERE", true)
    template.replace_image("image1.jpeg", "/opt/image5.jpg")
    template.save('/opt/final.docx')
  }
  spec.homepage      = "https://www.facebook.com/maniankara"
  spec.license       = "Maniankara Inc."
  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
end