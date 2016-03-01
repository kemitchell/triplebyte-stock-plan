CF=node_modules/.bin/commonform

Stock-Plan.docx: Stock-Plan.cform $(CF)
	$(CF) render -f docx -t "[Company Name] [Year] Stock Plan" -n pae < $< > $@

%.pdf: %.docx
	doc2pdf $<

$(CF):
	npm i
