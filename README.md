docx_template - Templating library for docx files
=============

Docx templating library which could replace docx contents such as text, images etc. in one go.

### Installation
docx_template can be used from the command line or as part of a Ruby web framework. To install the gem using terminal, run the following command:
```
gem install docx_template
```
To use it in Rails, add this line to your Gemfile:
```
gem 'docx_template'
```

#### Sample usage
```
require 'docx_template'
template = DocxTemplate::Docx.new "/opt/docx_template.docx"
template.replace_text("##SINGLE_REPLACE_TEXT##", "ACTUAL TEXT HERE")
template.replace_text("##MULTI_REPLACE_TEXT##", "ACTUAL TEXT HERE", true)
template.replace_image("image1.jpeg", "/opt/image5.jpg")
template.replace_header("##HEADER_REPLACE_TEXT##", "ACTUAL TEXT HERE", true)
template.save('/opt/final.docx')
```
###### Line by line explanation is given here:

```
template = DocxTemplate::Docx.new "/opt/docx_template.docx"
```
The template document contains notations and other things which will be replaced
```
template.replace_text("##SINGLE_REPLACE_TEXT##", "ACTUAL TEXT HERE")
```
The replace text can be anything inside the document
```
template.replace_text("##MULTI_REPLACE_TEXT##", "ACTUAL TEXT HERE", true)
```
The given text can also be replaced across the whole document
```
template.replace_image("image1.jpeg", "/opt/image5.jpg")
```
The first param defines the name of the image to be replaced. Can be checked by opening the template as archive
```
template.replace_header("##HEADER_REPLACE_TEXT##", "ACTUAL TEXT HERE", true)
```
This does the same as before but in document headers
```
template.save('/opt/final.docx')
```
The actual file processing begins and ends here

### Contributing
Contributions are welcomed. You can fork a repository, add your code changes to the forked branch, ensure all existing unit tests pass, create new unit tests cover your new changes and finally create a pull request.

#### Testing
Once this is complete, you should be able to run the test suite:
```
rspec
```
### Release test setup
The following test setup was used when released:
* ruby2.1.2
* rails4
* Ubuntu14.1 Linux
* Microsoft word 2007+

### License
docx_template has been published under https://github.com/maniankara/docx_template/blob/master/LICENSE under Maniankara Inc.