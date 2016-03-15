CF=node_modules/.bin/commonform
CFT=node_modules/.bin/cftemplate
TARGETS=Stock-Plan Stockholder-Consent Term-Sheet Option-Notice Option-Agreement Option-Country-Addendum Option-Exercise-Agreement Board-Consent

all: $(TARGETS:=.docx) $(TARGETS:=.pdf)

Stock-Plan.docx: Stock-Plan.cform $(CF)
	cat $< | sed 's/$$/ /' | $(CF) render -f docx -t "[Company Name] [Year] Stock Plan" -n pae > $@

Stockholder-Consent.docx: Stockholder-Consent.cform Stockholder-Consent.json $(CF)
	cat $< | sed 's/$$/ /' | $(CF) render -f docx -t "Action by Written Consent of the Stockholder of [Company Name]" -n rse -s Stockholder-Consent.json > $@

Term-Sheet.docx: Term-Sheet.cform $(CF)
	cat $< | sed 's/$$/ /' | $(CF) render -f docx -t "[Company Name] [Year] Stock Plan Summary of Key Provisions" -n outline > $@

Option-Notice.docx: Option-Notice.cform Option-Notice.json $(CF)
	$(CF) render -f docx -t "Notice of Stock Option Grant" -s Option-Notice.json -n outline $< > $@

Option-Agreement.docx: Option-Agreement.cform $(CF)
	$(CF) render -f docx -t "Stock Option Agreement" -n outline $< > $@

Option-Country-Addendum.docx: Option-Country-Addendum.cform $(CF)
	$(CF) render -f docx -t "Country-Specific Addendum" -n outline $< > $@

Option-Exercise-Agreement.docx: Option-Exercise-Agreement.cform Option-Exercise-Agreement.json $(CF)
	$(CF) render -f docx -t "Exercise Agreement" -n outline -s Option-Exercise-Agreement.json $< > $@

Board-Consent.docx: Board-Consent.cform Board-Consent.json $(CF)
	$(CF) render -f docx -t "Action by Unanimous Written Consent of the Board of Directors of [Company Name]" -n rse -s Board-Consent.json < $< > $@

%.cform: %.cftemplate $(CFT)
	$(CFT) $< > $@

%.pdf: %.docx
	doc2pdf $<

$(CF) $(CFT):
	npm i
