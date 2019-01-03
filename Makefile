ECHO=
LOCAL=/home/lou/Public
LANG=eng
REPO=ELTeC-$(LANG)
PREFIX=ENG
SCHEMA1=$(LOCAL)/WG1/distantreading.github.io/Schema/eltec-1.rng
CORPUS=$(LOCAL)/$(REPO)
CORPUS1=$(LOCAL)/$(REPO)/level1
SCHEMA0=$(LOCAL)/WG1/distantreading.github.io/Schema/eltec-0.rng
CORPUS0=$(LOCAL)/$(REPO)/level0
REPORTER=$(LOCAL)/Scripts/reporter.xsl
CURRENT=`pwd`

validate:
	cd $(CORPUS)
	find level1 | grep $(PREFIX) | sort | while read f; do \
		echo $$f; \
		jing  $(SCHEMA1) $$f ; done; cd $(CURRENT);
	find level0 | grep  $(PREFIX) | sort | while read f; do \
		echo $$f; \
		jing  $(SCHEMA0) $$f ; done; cd $(CURRENT);
driver:
	echo rebuild driver file
	echo '<teiCorpus xmlns="http://www.tei-c.org/ns/1.0" xmlns:xi="http://www.w3.org/2001/XInclude"><teiHeader><fileDesc> <titleStmt> <title>TEI Corpus testharness</title></titleStmt> <publicationStmt><p>Unpublished test file</p></publicationStmt><sourceDesc><p>No source driver file</p> </sourceDesc> </fileDesc> </teiHeader>' >  $(CORPUS)/driver.tei;\
	find level? | grep $(PREFIX) | sort | while read f; do \
	echo "<xi:include href='$$f'/>" >> $(CORPUS)/driver.tei; \
	done;\
	 echo "</teiCorpus>" >> $(CORPUS)/driver.tei

report:
	echo report on corpus balance
	saxon -xi $(CORPUS)/driver.tei $(REPORTER) corpus=$(LANG) >$(CORPUS)/balance_report.html
