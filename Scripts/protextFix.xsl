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
    <xsl:variable name="pageCount">
        <xsl:value-of select="count(//t:hi[@rend = 'small'])"/>
    </xsl:variable>
    <xsl:variable name="wordCount">
        <xsl:value-of
            select="
                string-length(normalize-space(//t:body))
                -
                string-length(translate(normalize-space(//t:body), ' ', '')) + 1"
        />
    </xsl:variable>
    <xsl:template match="//t:teiHeader">
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
        <xsl:variable name="size">
            <xsl:choose>
                <xsl:when test="xs:integer($wordCount) le 50000">short</xsl:when>
                <xsl:when test="xs:integer($wordCount) le 100000">medium</xsl:when>
                <xsl:when test="xs:integer($wordCount) gt 100000">long</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <teiHeader xmlns="http://www.tei-c.org/ns/1.0">
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
    <xsl:template match="t:hi[@rend = 'small']">
        <pb>
            <xsl:attribute name="n">
                <xsl:value-of select="substring-before(substring-after(., 'age '), ' ]')"/>
            </xsl:attribute>
        </pb>
    </xsl:template>
    <xsl:template match="t:lb"/>
    <xsl:template match="@rend"/>
    <xsl:template match="* | @* | processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="."/>
        <!-- could normalize() here -->
    </xsl:template>
    <xsl:function name="e:wcount"> </xsl:function>
</xsl:stylesheet>
