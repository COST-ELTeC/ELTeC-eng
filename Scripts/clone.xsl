<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs h"
    xmlns:h="http://www.w3.org/1999/xhtml" 
    xmlns:t="http://www.tei-c.org/ns/1.0" 
    
    xmlns="http://www.tei-c.org/ns/1.0" 
    version="2.0">
   <!-- by default this stylesheet copies all existing tagging unchanged--> 
 <!--listPrefixDef>
   <prefixDef ident="bod" matchPattern="([a-z0-9]+)"
    replacementPattern="http://dbooks.bodleian.ox.ac.uk/books/PDFs/$1.pdf"/>
   <prefixDef ident="gut" matchPattern="([a-z0-9]+)" replacementPattern="http://www.gutenberg.org/files/$1/$1-h/$1-h.htm"/>
   <prefixDef ident="ia" matchPattern="([a-z0-9]+)"
    replacementPattern="http://archive.org/details/$1"/>
   <prefixDef ident="viaf" matchPattern="([a-z0-9]+)"
    replacementPattern="https://viaf.org/viaf/$1/"/>
    <prefixDef ident="vwwp" matchPattern="(VAB[0-9]+)"
    replacementPattern="http://purl.dlib.indiana.edu/iudl/vwwp/$1"/>
  </listPrefixDef>-->
   <!-- add templates for elements you want to change here -->
    
    <xsl:template match="t:ref/@target">
     <xsl:choose>
      <xsl:when test="starts-with(., 'gut:')">
       <xsl:variable name="id">
        <xsl:value-of select="substring-after(.,'gut:')"/>
       </xsl:variable>
       <xsl:value-of select="concat('http://www.gutenberg.org/ebooks/',$id)"/>
      </xsl:when>
      <xsl:when test="starts-with(., 'ia:')">
       <xsl:variable name="id">
        <xsl:value-of select="substring-after(.,'ia:')"/>
       </xsl:variable>
       
       <xsl:value-of select="concat('http://archive.org/details/',$id)"/>
      </xsl:when>
     </xsl:choose>
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