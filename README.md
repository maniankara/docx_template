docx_template
=============

Docx templating library which could replace docx contents such as text, images etc.

#### Sample usage
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
template.save('/opt/final.docx')
```
The actual process begins and ends here
