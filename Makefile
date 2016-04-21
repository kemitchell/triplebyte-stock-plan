CF=node_modules/.bin/commonform
CFT=node_modules/.bin/cftemplate
TARGETS=Stock-Plan Stockholder-Consent Term-Sheet Option-Notice Option-Agreement Country-Addendum Option-Exercise-Agreement Early-Exercise-Option-Notice Early-Exercise-Option-Agreement Early-Exercise-Option-Exercise-Agreement Early-Exercise-Option-Notice-and-Purchase-Agreement Board-Consent Early-Exercise-Stock-Power 83b-Election 83b-Statement-Acknowledgment California-Addendum RSPA RSA California-Addendum RSA-Stock-Power RSPA-Stock-Power
DOCX=--format docx --indent-margins

all: $(TARGETS:=.docx) $(TARGETS:=.pdf)

.INTERMEDIATE: no-pages.json

no-pages.json:
	echo '[]' > $@

Stock-Plan.docx: Stock-Plan.cform no-pages.json $(CF)
	cat $< | sed 's/$$/ /' | $(CF) render $(DOCX) -s no-pages.json -t "[Company Name] [Stock Plan Name]" -n outline > $@

California-Addendum.docx: California-Addendum.cform no-pages.json $(CF)
	cat $< | sed 's/$$/ /' | $(CF) render $(DOCX) -s no-pages.json -t "California Addendum" -n outline > $@

Stockholder-Consent.docx: Stockholder-Consent.cform Stockholder-Consent.json $(CF)
	cat $< | sed 's/$$/ /' | $(CF) render $(DOCX) -t "Action by Written Consent of the Stockholders of [Company Name]" -n rse -s Stockholder-Consent.json > $@

Term-Sheet.docx: Term-Sheet.cform no-pages.json $(CF)
	cat $< | sed 's/$$/ /' | $(CF) render $(DOCX) -s no-pages.json -t "[Company Name] [Year] Stock Plan Summary of Key Provisions" -n outline > $@

Option-Notice.docx: Option-Notice.cform Option-Notice.json $(CF)
	$(CF) render $(DOCX) -t "Notice of Stock Option Grant" -s Option-Notice.json -n outline $< > $@

Option-Agreement.docx: Option-Agreement.cform no-pages.json $(CF)
	$(CF) render $(DOCX) -t "Stock Option Agreement" -s no-pages.json -n ase $< > $@

Country-Addendum.docx: Country-Addendum.cform no-pages.json $(CF)
	$(CF) render $(DOCX) -t "Country-Specific Addendum" -s no-pages.json -n outline $< > $@

Option-Exercise-Agreement.docx: Option-Exercise-Agreement.cform Option-Exercise-Agreement.json $(CF)
	$(CF) render $(DOCX) -t "Exercise Agreement" -n ase -s Option-Exercise-Agreement.json $< > $@

Option-Notice.cform: Option-Notice.cftemplate $(CFT)
	$(CFT) Option-Notice.cftemplate > $@

.INTERMEDIATE: Early-Exercise.options Early-Exercise-Option-Agreement.cform Early-Exercise-Option-Agreement.options Early-Exercise-Option-Exercise-Agreement.cform Early-Exercise-Option-Exercise-Agreement.json Early-Exercise-Option-Exercise-Agreement.options Early-Exercise-Option-Notice.cform Early-Exercise-Option-Notice.json Early-Exercise.options RSA.cform RSPA.cform Early-Exercise-Stock-Power.options Early-Exercise-Stock-Power.cform RSPA-Stock-Power.options RSPA-Stock-Power.cform RSA-Stock-Power.options RSA-Stock-Power.cform

Early-Exercise-Option-Notice.cform: Option-Notice.cftemplate Early-Exercise.options $(CFT)
	$(CFT) Option-Notice.cftemplate Early-Exercise.options > $@

Option-Exercise-Agreement.cform: Option-Exercise-Agreement.cftemplate $(CFT)
	$(CFT) Option-Exercise-Agreement.cftemplate > $@

Early-Exercise-Option-Exercise-Agreement.cform: Option-Exercise-Agreement.cftemplate Early-Exercise.options $(CFT)
	$(CFT) Option-Exercise-Agreement.cftemplate Early-Exercise.options > $@

Early-Exercise-Stock-Power.options:
	echo '{"EE":true}' > $@

Early-Exercise-Stock-Power.cform: Stock-Power.cftemplate Early-Exercise-Stock-Power.options $(CFT)
	$(CFT) Stock-Power.cftemplate Early-Exercise-Stock-Power.options > $@

Early-Exercise-%.json: %.json
	cp $< $@

Early-Exercise-%.cform: %.cform
	cp $< $@

Early-Exercise-Option-Notice.docx: Early-Exercise-Option-Notice.cform Early-Exercise-Option-Notice.json $(CF)
	$(CF) render $(DOCX) -t "Notice of Stock Option Grant" -s Early-Exercise-Option-Notice.json -n outline $< > $@

Early-Exercise-Option-Agreement.docx: Early-Exercise-Option-Agreement.cform no-pages.json $(CF)
	$(CF) render $(DOCX) -t "Stock Option Agreement" -n ase -s no-pages.json $< > $@

Early-Exercise-Option-Exercise-Agreement.docx: Early-Exercise-Option-Exercise-Agreement.cform Early-Exercise-Option-Exercise-Agreement.json $(CF)
	$(CF) render $(DOCX) -t "Exercise Agreement" -n outline -s Early-Exercise-Option-Exercise-Agreement.json $< > $@

Early-Exercise-Option-Notice-and-Purchase-Agreement.docx: Early-Exercise-Option-Notice-and-Purchase-Agreement.cform Early-Exercise-Option-Notice-and-Purchase-Agreement.json $(CF)
	$(CF) render $(DOCX) -t "Early Exercise Notice and Restricted Stock Purchase Agreement" -n ase -s Early-Exercise-Option-Notice-and-Purchase-Agreement.json $< > $@

Early-Exercise-Stock-Power.docx: Early-Exercise-Stock-Power.cform Stock-Power.json $(CFT)
	$(CF) render $(DOCX) -t "Stock Power" -n outline -s Stock-Power.json $< > $@

83b-Election.docx: 83b-Election.cform 83b-Election.json $(CF)
	$(CF) render $(DOCX) -t "Election Under Section 83(b) of the Internal Revenue Code of 1986" -n outline -s 83b-Election.json < $< > $@

83b-Statement-Acknowledgment.docx: 83b-Statement-Acknowledgment.cform 83b-Statement-Acknowledgment.json $(CF)
	$(CF) render $(DOCX) -t "Acknowledgment and Statement of Decision Regarding Section 83(b) Election" -n outline -s 83b-Statement-Acknowledgment.json < $< > $@

Board-Consent.docx: Board-Consent.cform Board-Consent.json $(CF)
	$(CF) render $(DOCX) -t "Action by Unanimous Written Consent of the Board of Directors of [Company Name]" -n rse -s Board-Consent.json < $< > $@

Early-Exercise.options:
	echo '{"Early Exercise": true }' > $@

RSPA.docx: RSPA.cform RSPA.json $(CF)
	$(CF) render $(DOCX) -t "Restricted Stock Purchase Agreement" -n ase -s RSPA.json < $< > $@

RSA.docx: RSA.cform RSA.json $(CF)
	$(CF) render $(DOCX) -t "Restricted Stock Agreement" -n ase -s RSA.json < $< > $@

RSA-Stock-Power.options:
	echo '{"RSA": true }' > $@

RSA-Stock-Power.cform: Stock-Power.cftemplate RSA-Stock-Power.options $(CFT)
	$(CFT) Stock-Power.cftemplate RSA-Stock-Power.options > $@

RSA-Stock-Power.docx: RSA-Stock-Power.cform Stock-Power.json $(CFT)
	$(CF) render $(DOCX) -t "Stock Power" -n outline -s Stock-Power.json $< > $@

RSPA-Stock-Power.options:
	echo '{"RSPA": true }' > $@

RSPA-Stock-Power.cform: Stock-Power.cftemplate RSPA-Stock-Power.options $(CFT)
	$(CFT) Stock-Power.cftemplate RSPA-Stock-Power.options > $@

RSPA-Stock-Power.docx: RSPA-Stock-Power.cform Stock-Power.json $(CFT)
	$(CF) render $(DOCX) -t "Stock Power" -n outline -s Stock-Power.json $< > $@

%.cform: %.cftemplate $(CFT)
	$(CFT) $< > $@

%.pdf: %.docx
	doc2pdf $<

$(CF) $(CFT):
	npm i

.PHONY: clean

clean:
	rm -rf $(TARGETS:=.docx)
	rm -rf $(TARGETS:=.pdf)
