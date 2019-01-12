<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs h"
    xmlns:h="http://www.w3.org/1999/xhtml" 
    xmlns:t="http://www.tei-c.org/ns/1.0" 
    
    xmlns="http://www.tei-c.org/ns/1.0" 
    version="2.0">
    <xsl:template match="/">
        <body>
        <xsl:apply-templates select="//h:td[@width='100%']"/>
      </body>
    </xsl:template>
    
    <xsl:template match="h:p[@align='center']"/>

    <xsl:template match="h:td[@width='100%']">
<xsl:apply-templates/>        
    </xsl:template>
    
    <xsl:template match="h:p[@align='justify']">
        <div type="chapter">
            <xsl:if test="preceding-sibling::h:p[@align='center'][1]">
                <head><xsl:value-of select="preceding-sibling::h:p[@align='center'][1]"/></head>
            </xsl:if>
            <p><xsl:apply-templates/></p>
        </div>
    </xsl:template>
    
    <xsl:template match="h:br"/>
    
    <xsl:template match="h:b|h:i">
        <hi><xsl:apply-templates/></hi>
    </xsl:template>
    
    <xsl:template match="h:font">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="* | @* | processing-instruction()">
        <xsl:copy>
            <xsl:apply-templates select="* | @* | processing-instruction() | comment() | text()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="text()">
        <xsl:value-of select="."/>
        <!-- could normalize() here -->
    </xsl:template>
</xsl:stylesheet>