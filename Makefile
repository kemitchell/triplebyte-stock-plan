CF=node_modules/.bin/commonform
TARGETS=Stock-Plan Stockholder-Consent Term-Sheet

all: $(TARGETS:=.docx) $(TARGETS:=.pdf)

Stock-Plan.docx: Stock-Plan.cform $(CF)
	cat $< | sed 's/$$/ /' | $(CF) render -f docx -t "[Company Name] [Year] Stock Plan" -n pae > $@

Stockholder-Consent.docx: Stockholder-Consent.cform Stockholder-Consent.json $(CF)
	cat $< | sed 's/$$/ /' | $(CF) render -f docx -t "Action by Written Consent of the Stockholder of [Company Name]" -n rse -s Stockholder-Consent.json > $@

Term-Sheet.docx: Term-Sheet.cform $(CF)
	cat $< | sed 's/$$/ /' | $(CF) render -f docx -t "[Company Name] [Year] Stock Plan Summary of Key Provisions" -n outline > $@

%.pdf: %.docx
	doc2pdf $<

$(CF):
	npm i
