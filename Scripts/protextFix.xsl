<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs h"
    xmlns:h="http://www.w3.org/1999/xhtml" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" xmlns="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:output exclude-result-prefixes="h t xs e"/>
    <xsl:variable name="today">
        <xsl:value-of select="substring(string(current-date()), 1, 10)"/>
    </xsl:variable>
    <xsl:param name="bassettBase">/home/lou/Public/bookLists/Bassett/bassettPlus.xml</xsl:param>
    <xsl:param name="bassettKey">B7559</xsl:param>
<xsl:variable name="pageCount">?</xsl:variable>
    <!--   <xsl:value-of select="count(//t:hi[@rend = 'small'])"/>
    </xsl:variable>
    -->
    <xsl:variable name="wordCount">?</xsl:variable>
       <!-- <xsl:value-of
            select="
                string-length(normalize-space(//t:body))
                -
                string-length(translate(normalize-space(//t:body), ' ', '')) + 1"
        />
    </xsl:variable>
    -->
    
    <xsl:template match="h:html">
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="ENG18ddd_xxx">
            <xsl:apply-templates/>
        </TEI>
    </xsl:template>  
    
    <xsl:template match="h:head">
        <xsl:message>Generating header for Bassett title <xsl:value-of select="$bassettKey"/> (
                <xsl:value-of select="document($bassettBase)//t:bibl[@xml:id = $bassettKey]/t:title"
            />)</xsl:message>
        <xsl:variable name="sex">
            <xsl:value-of
                select="substring(document($bassettBase)//t:bibl[@xml:id = $bassettKey]/t:author/@ref, 1, 1)"
            />
        </xsl:variable>
        <xsl:variable name="author">
            <xsl:value-of select="document($bassettBase)//t:bibl[@xml:id = $bassettKey]/t:author"/>
        </xsl:variable>
        <xsl:variable name="title">
            <xsl:value-of select="document($bassettBase)//t:bibl[@xml:id = $bassettKey]/t:title"/>
        </xsl:variable>
        <xsl:variable name="date">
            <xsl:value-of select="document($bassettBase)//t:bibl[@xml:id = $bassettKey]/t:date"/>
        </xsl:variable>
        <xsl:variable name="timeSlot">
            <xsl:choose>
                <xsl:when test="$date le '1859'">T1</xsl:when>
                <xsl:when test="$date le '1879'">T2</xsl:when>
                <xsl:when test="$date le '1899'">T3</xsl:when>
                <xsl:when test="$date le '1920'">T4</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="size">?</xsl:variable>
           <!-- <xsl:choose>
                <xsl:when test="xs:integer($wordCount) le 50000">short</xsl:when>
                <xsl:when test="xs:integer($wordCount) le 100000">medium</xsl:when>
                <xsl:when test="xs:integer($wordCount) gt 100000">long</xsl:when>
            </xsl:choose>
        </xsl:variable>-->
        <teiHeader>
            <fileDesc>
                <titleStmt>
                    <title>
                        <xsl:value-of select="concat($title, ' : ELTec edition')"/>
                    </title>
                    <author>
                        <xsl:value-of select="$author"/>
                    </author>
                    <respStmt>
                        <resp>ELTeC conversion</resp>
                        <name>Lou Burnard</name>
                    </respStmt>
                </titleStmt>
                <extent>
                    <measure unit="words">
                        <xsl:value-of select="$wordCount"/>
                    </measure>
                    <measure unit="pages">
                        <xsl:value-of select="$pageCount"/>
                    </measure>
                </extent>
                <publicationStmt>
                    <p>Published as part of ELTeC <date><xsl:value-of select="$today"/></date></p>
                </publicationStmt>
                <sourceDesc>
                    <bibl>
                        <title>
                            <xsl:value-of select="$title"/>
                        </title>
                        <title>Nineteenth-Century Fiction Full-Text Database</title>
                        <publisher>Chadwyck-Healey Ltd (A Bell &amp; Howell Information and Learning
                            company)</publisher>
                        <date>2000</date>
                        <relatedItem>
                            <bibl type="copyText">
                                <title>
                                    <xsl:value-of select="$title"/>
                                </title>
                                <author>
                                    <xsl:value-of select="$author"/>
                                </author>
                                <publisher>
                                    <xsl:value-of
                                        select="document($bassettBase)//t:bibl[@xml:id = $bassettKey]/t:publisher"
                                    />
                                </publisher>
                                <date>
                                    <xsl:value-of select="$date"/>
                                </date>
                            </bibl>
                        </relatedItem>
                    </bibl>
                </sourceDesc>
            </fileDesc>
            <encodingDesc>
                <xsl:attribute name="n">eltec-0</xsl:attribute>
                <p/>
            </encodingDesc>
            <profileDesc>
                <langUsage>
                    <language ident="eng">English</language>
                </langUsage>
                <textDesc>
                    <authorGender xmlns="http://distantreading.net/eltec/ns" key="{$sex}"/>
                    <size xmlns="http://distantreading.net/eltec/ns" key="{$size}"/>
                    <canonicity xmlns="http://distantreading.net/eltec/ns" key="medium"/>
                    <timeSlot xmlns="http://distantreading.net/eltec/ns" key="{$timeSlot}"/>
                </textDesc>
            </profileDesc>
            <revisionDesc>
                <change when="{$today}">LB convert to ELTeC-1</change>
            </revisionDesc>
        </teiHeader>
    </xsl:template>
    
    
   
    <xsl:template match="h:body">
        <text><body>
            <xsl:for-each-group select="*" group-starting-with="h:h4">
                <div type="chapter">
                    <xsl:for-each select="current-group()">
                        
                        <xsl:apply-templates select="."/>
                        
                    </xsl:for-each></div>
            </xsl:for-each-group>
        </body></text>
    </xsl:template>
    
    <xsl:template match="h:h3|h:h4">   
        <head><xsl:value-of select="."/></head>
    </xsl:template>
    
    <xsl:template match="h:small/h:font">       
        <pb>
            <xsl:if test="string-length(substring-before(substring-after(., 'age '), ' ]')) gt 1"
                >
                <xsl:attribute name="n">
                    <xsl:value-of select="substring-before(substring-after(., 'age '), ' ]')"/>
                </xsl:attribute></xsl:if>
        </pb>
    </xsl:template>
    
    <xsl:template match="h:sup/h:a">
        <ref target="{@href}">
            <xsl:value-of select="."/>
        </ref></xsl:template>
    
    <xsl:template match="h:div[@class='footnote']">
        <note xml:id='{@id}'>
            <xsl:value-of select="."/>
        </note>
    </xsl:template>
    <xsl:template match="h:div[@class='footnote']/h:a"/>
    <xsl:template match="h:div[@class='footnote']/h:lb"/>
    
    <xsl:template match="h:span[h:img]">
        <milestone unit="subsection" rend="stars"/>
    </xsl:template>
    
    <xsl:template match="h:p[h:img[@src='/images/inline/ast.gif']]">
        <milestone unit="subsection" rend="stars"/>
    </xsl:template>
    
    <xsl:template match="h:span[h:br]">
        <quote>               
            <xsl:for-each-group select="*" group-starting-with="h:br">
                <xsl:for-each select="current-group()">                
                    <l>                 
                        <xsl:apply-templates
                            select="normalize-space(following-sibling::text()[1])"/> 
                    </l>
                </xsl:for-each>
                
            </xsl:for-each-group></quote>
    </xsl:template>
    
    <xsl:template match="h:span[string-length(normalize-space(.)) gt 1 and not(h:br) and not(h:img)]">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="h:center[h:br]">
        <quote>               
            <xsl:for-each-group select="*" group-starting-with="h:br">
                <xsl:for-each select="current-group()">                
                    <l>                 
                        <xsl:apply-templates select="normalize-space(following-sibling::text()[1])"/> 
                    </l>
                </xsl:for-each>
            </xsl:for-each-group></quote>
    </xsl:template>
    
    <xsl:template match="h:small|h:sup|h:center|h:p[@align='center']"><xsl:apply-templates/></xsl:template>
    <xsl:template match="h:br"/>
    <xsl:template match="h:p"><p><xsl:apply-templates/></p></xsl:template>
    <xsl:template match="h:strong|h:em"><hi><xsl:apply-templates/></hi></xsl:template>
    
    <xsl:template match="* | @* | processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="."/>
        
    </xsl:template>
</xsl:stylesheet>