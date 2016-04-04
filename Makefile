CF=node_modules/.bin/commonform
CFT=node_modules/.bin/cftemplate
TARGETS=Stock-Plan Stockholder-Consent Term-Sheet Option-Notice Option-Agreement Country-Addendum Option-Exercise-Agreement Early-Exercise-Option-Notice Early-Exercise-Option-Agreement Early-Exercise-Option-Exercise-Agreement Early-Exercise-Option-Notice-and-Purchase-Agreement Board-Consent Early-Exercise-Stock-Power 83b-Election 83b-Statement-Acknowledgment RSPA RSA

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

Country-Addendum.docx: Country-Addendum.cform $(CF)
	$(CF) render -f docx -t "Country-Specific Addendum" -n outline $< > $@

Option-Exercise-Agreement.docx: Option-Exercise-Agreement.cform Option-Exercise-Agreement.json $(CF)
	$(CF) render -f docx -t "Exercise Agreement" -n outline -s Option-Exercise-Agreement.json $< > $@

Option-Notice.cform: Option-Notice.cftemplate $(CFT)
	$(CFT) Option-Notice.cftemplate > $@

Early-Exercise-Option-Notice.cform: Option-Notice.cftemplate Early-Exercise.options $(CFT)
	$(CFT) Option-Notice.cftemplate Early-Exercise.options > $@

Option-Exercise-Agreement.cform: Option-Exercise-Agreement.cftemplate $(CFT)
	$(CFT) Option-Exercise-Agreement.cftemplate > $@

Early-Exercise-Option-Exercise-Agreement.cform: Option-Exercise-Agreement.cftemplate Early-Exercise.options $(CFT)
	$(CFT) Option-Exercise-Agreement.cftemplate Early-Exercise.options > $@

Early-Exercise-%.json: %.json
	cp $< $@

Early-Exercise-%.cform: %.cform
	cp $< $@

Early-Exercise-Option-Notice.docx: Early-Exercise-Option-Notice.cform Early-Exercise-Option-Notice.json $(CF)
	$(CF) render -f docx -t "Notice of Stock Option Grant" -s Early-Exercise-Option-Notice.json -n outline $< > $@

Early-Exercise-Option-Agreement.docx: Early-Exercise-Option-Agreement.cform $(CF)
	$(CF) render -f docx -t "Stock Option Agreement" -n outline $< > $@

Early-Exercise-Option-Exercise-Agreement.docx: Early-Exercise-Option-Exercise-Agreement.cform Early-Exercise-Option-Exercise-Agreement.json $(CF)
	$(CF) render -f docx -t "Exercise Agreement" -n outline -s Early-Exercise-Option-Exercise-Agreement.json $< > $@

Early-Exercise-Option-Notice-and-Purchase-Agreement.docx: Early-Exercise-Option-Notice-and-Purchase-Agreement.cform Early-Exercise-Option-Notice-and-Purchase-Agreement.json $(CF)
	$(CF) render -f docx -t "Early Exercise Notice and Restricted Stock Purchase Agreement" -n ase -s Early-Exercise-Option-Notice-and-Purchase-Agreement.json $< > $@

Early-Exercise-Stock-Power.docx: Early-Exercise-Stock-Power.cform Early-Exercise-Stock-Power.json $(CFT)
	$(CF) render -f docx -t "Stock Power" -n outline -s Early-Exercise-Stock-Power.json $< > $@

83b-Election.docx: 83b-Election.cform 83b-Election.json $(CF)
	$(CF) render -f docx -t "Election Under Section 83(b) of the Internal Revenue Code of 1986" -n outline -s 83b-Election.json < $< > $@

83b-Statement-Acknowledgment.docx: 83b-Statement-Acknowledgment.cform 83b-Statement-Acknowledgment.json $(CF)
	$(CF) render -f docx -t "Action by Unanimous Written Consent of the Board of Directors of [Company Name]" -n outline -s 83b-Statement-Acknowledgment.json < $< > $@

Board-Consent.docx: Board-Consent.cform Board-Consent.json $(CF)
	$(CF) render -f docx -t "Action by Unanimous Written Consent of the Board of Directors of [Company Name]" -n rse -s Board-Consent.json < $< > $@

Early-Exercise.options:
	echo '{"Early Exercise": true }' > $@

RSPA.docx: RSPA.cform RSPA.json $(CF)
	$(CF) render -f docx -t "Restricted Stock Purchase Agreement" -n outline -s RSPA.json < $< > $@

RSPA.json:
	echo "{}" > $@

RSA.docx: RSA.cform RSA.json $(CF)
	$(CF) render -f docx -t "Restricted Stock Agreement" -n outline -s RSA.json < $< > $@

RSA.json:
	echo "{}" > $@

%.cform: %.cftemplate $(CFT)
	$(CFT) $< > $@

%.pdf: %.docx
	doc2pdf $<

$(CF) $(CFT):
	npm i
