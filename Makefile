ECHO=
LOCAL=/home/lou/Public
LANG=eng
REPO=ELTeC-$(LANG)
PREFIX=ENG
SCHEMA=$(LOCAL)/WG1/dev/eltec-1.xml.rnc
SCHEMA1=$(LOCAL)/WG1/distantreading.github.io/Schema/eltec-1.rng
CORPUS=$(LOCAL)/$(REPO)
CORPUS1=$(LOCAL)/$(REPO)/level1
SCHEMA0=$(LOCAL)/WG1/distantreading.github.io/Schema/eltec-0.rng
CORPUS0=$(LOCAL)/$(REPO)/level0
HEADFIX=$(LOCAL)/Scripts/headChecker.xsl
REPORTER=$(LOCAL)/Scripts/reporter.xsl
AUTHORS=$(LOCAL)/Scripts/authorList.xsl
EXPOSE=$(LOCAL)/Scripts/expose.xsl
EXPOSEDIR=$(LOCAL)/WG1/distantreading.github.io/ELTeC/$(LANG)
CURRENT=`pwd`

revalidate:
	cd $(corpus)
	for f in level?/ENG*.xml; do echo $$f;\
	saxon $$f $(HEADFIX) | rnv  $(SCHEMA) ;\
	done; cd $(CURRENT);

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
	saxon -xi $(CORPUS)/driver.tei $(REPORTER) corpus=$(LANG) >$(CORPUS)/index.html
	Rscript /home/lou/Public/Scripts/mosaic.R --args .
expose:
	cd $(CORPUS);
	find level? | grep $(PREFIX) | sort | while read f; do \
	g=`echo $$f  | cut -d_ -f1`;\
	id=`echo $$g  | cut -d/ -f2`;\
	echo $$id; \
	saxon fileName=$$f $$f $(EXPOSE) > $(EXPOSEDIR)/$$id.html; \
	done
