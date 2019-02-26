<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs h e"
    xmlns:h="http://www.w3.org/1999/xhtml" xmlns:t="http://www.tei-c.org/ns/1.0"
    xmlns:e="http://distantreading.net/eltec/ns" xmlns="http://www.tei-c.org/ns/1.0" version="2.0">
    <xsl:output exclude-result-prefixes="h t xs e"/>
    <xsl:variable name="today">
        <xsl:value-of select="substring(string(current-date()), 1, 10)"/>
    </xsl:variable>
    <xsl:param name="bassettBase">/home/lou/Public/bookLists/Bassett/bassettPlus.xml</xsl:param>
    <xsl:param name="bassettKey">B1984</xsl:param>
    <xsl:param name="gutenKey">7926</xsl:param>
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
        <TEI xmlns="http://www.tei-c.org/ns/1.0" xml:id="ENG18ddd" xml:lang="en">
            <xsl:apply-templates/>
        </TEI>
    </xsl:template>
    <xsl:template match="h:head">
        <xsl:message>Generating header for Bassett title <xsl:value-of select="$bassettKey"/>
            <xsl:text> (</xsl:text><xsl:value-of
                select="document($bassettBase)//t:bibl[@xml:id = $bassettKey]/t:title"
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
                            <xsl:value-of select="h:title"/>
                        </title>
                        <ref target="{concat('gut:',$gutenKey)}">Gutenberg</ref>
                        <relatedItem>
                            <bibl type="firstEdition" n="{$bassettKey}">
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
    <xsl:template
        match="h:pre | h:blockquote | h:p[@class = 'toc'] | h:br | h:a | h:eg | h:table | h:hr | h:div[h:br]"/>
    
    <xsl:template match="h:p[h:br]">
        <quote>
            <xsl:for-each-group select="*" group-ending-with="h:br">
                <l>
                    <xsl:for-each select="current-group()">
                        <xsl:apply-templates select="preceding-sibling::text()[1]"/>
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </l>
            </xsl:for-each-group>
        </quote>
    </xsl:template>
    
    <xsl:template match="h:h4/h:a">
        <xsl:value-of select="."/>
    </xsl:template>
    
    <xsl:template match="h:a[starts-with(@name,'Page_')]">
        <pb>
            <xsl:attribute name="n">
                <xsl:value-of select="substring-after(@name,'Page_')"/>
            </xsl:attribute>
        </pb>
    </xsl:template>
    
    
    <xsl:template match="h:pre[preceding-sibling::h:h2]">
        <quote>
            <l>
                <xsl:apply-templates/>
            </l>
        </quote>
    </xsl:template>
    <xsl:template match="h:blockquote[preceding-sibling::h:h2]">
        <quote>
            <xsl:apply-templates/>
        </quote>
    </xsl:template>
    <xsl:template match="h:blockquote/h:blockquote">
        <div type="liminal">
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    <xsl:template match="h:hr[@class = 'full'][2]">
        <div type="notes">
            <xsl:for-each select="//h:table[@class = 'fn']">
                <note>
                    <xsl:attribute name="xml:id">
                        <xsl:value-of select="h:tr/h:td/h:p/h:a/@id[1]"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="h:tr/h:td/h:p"/>
                </note>
            </xsl:for-each>
        </div>
    </xsl:template>
    <xsl:template match="h:p/h:a[@href][not(contains(., 'Return'))]">
        <ref target="{@href}">
            <xsl:value-of select="."/>
        </ref>
    </xsl:template>
    <xsl:template match="h:b"/>
    <xsl:template match="h:div[@class = 'poem']">
        <quote>
            <xsl:choose>
                <xsl:when test=".//h:div[not(@class)]">
                    <xsl:for-each select=".//h:div[not(@class)]">
                        <l>
                            <xsl:apply-templates/>
                        </l>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </quote>
    </xsl:template>
    <xsl:template match="h:div[@class = 'stanza']/h:p">
        <l>
            <xsl:apply-templates/>
        </l>
    </xsl:template>
    <xsl:template match="h:div[@class = 'stanza']">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="h:div[@class = 'block' or @class = 'block2']">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="h:span[@class = 'pagenum']">
        <pb>
            <xsl:attribute name="n">
                <xsl:choose>
                    <xsl:when test="h:a">
                        <xsl:value-of select="substring-after(h:a/@name, 'Page_')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after(normalize-space(.), 'p.')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </pb>
    </xsl:template>
    <xsl:template
        match="h:span[@class = 'smcap'] | h:span[@class = 'sc'] | h:span[@class = 'smallcaps']">
        <hi>
            <xsl:apply-templates/>
        </hi>
    </xsl:template>
    <xsl:template match="h:span[@class = 'nowrap']">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="h:div[@class='stanza']/h:span[h:br]">
        <l><xsl:value-of select="."/></l>
    </xsl:template>

    <xsl:template match="h:p[@class = 'title']">
        <milestone unit="subsection" n="{substring-after(.,' ')}"/>
    </xsl:template>
    <xsl:template match="h:p">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <xsl:template match="h:i">
        <hi>
            <xsl:apply-templates select="@xml:lang"/>
            <xsl:apply-templates/>
        </hi>
    </xsl:template>
    <xsl:template match="h:body">
        <text>
            <body>
                <xsl:choose>
               <xsl:when test="h:h2">
        
            <xsl:for-each-group select="*" group-starting-with="h:h2">
                <div type="chapter">
                    <xsl:for-each select="current-group()">
                        
                        <xsl:apply-templates select="."/>
                        
                    </xsl:for-each></div>
            </xsl:for-each-group>
                </xsl:when>
                    <xsl:when test="h:h3">
                        <xsl:for-each-group select="*" group-starting-with="h:h3">
                            <div type="chapter">
                                <xsl:for-each select="current-group()">
                                    <xsl:apply-templates select="."/>
                                </xsl:for-each>
                            </div>
                        </xsl:for-each-group>
                    </xsl:when>
                    <xsl:when test="h:hr[@class = 'chap']">
                        <xsl:for-each-group select="*" group-starting-with="h:hr[@class = 'chap']">
                            <div type="chapter">
                                <xsl:for-each select="current-group()">
                                    <xsl:apply-templates select="."/>
                                </xsl:for-each>
                            </div>
                        </xsl:for-each-group>
                    </xsl:when>
                </xsl:choose>
            </body>
        </text>
    </xsl:template>
    <xsl:template match="h:h2 | h:h1 | h:big | h:h4 ">
        <head>
            <xsl:apply-templates/>
        </head>
    </xsl:template>
    <xsl:template match="h:h3">
        <xsl:apply-templates select="h:span[@class = 'pagenum']"/>
        <head><xsl:value-of select="."/></head>
       <!-- <head>
            <xsl:value-of select="h:span[@class = 'GutSmall']"/>
        </head>-->
    </xsl:template>
    <xsl:template match="h:span[matches(@class, 'i\d')]">
        <xsl:text>
      </xsl:text>
        <l>
            <xsl:apply-templates/>
        </l>
    </xsl:template>
    <xsl:template match="h:span[@class = 'GutSmall']">
        <hi><xsl:apply-templates/></hi>
    </xsl:template>
    <xsl:template match="h:span[h:img]">
        <xsl:value-of select="h:img/@alt"/>
    </xsl:template>
    <xsl:template match="h:div[@class = 'center']">
        <quote>
            <xsl:for-each select=".//text()">
                <xsl:if test="string-length(.) gt 2">
                    <l>
                        <xsl:copy-of select="."/>
                    </l>
                </xsl:if>
            </xsl:for-each>
        </quote>
    </xsl:template>
    <xsl:template match="h:div[@class='gapspace']"/>
    
    <!-- <xsl:template match="h:small/h:font">       
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
    <xsl:template match="h:strong|h:em"><hi><xsl:apply-templates/></hi></xsl:template>-->
    <xsl:template match="* | @* | processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>
</xsl:stylesheet>
