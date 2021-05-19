<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:xslthl="http://xslthl.sf.net"
                exclude-result-prefixes="xslthl"
                version='1.0'>

<!-- ********************************************************************

     Markup UK highlighting.

     This file is not part of the XSL DocBook Stylesheet distribution.

     ******************************************************************** -->

<!-- ============================================================= -->
<!-- ATTRIBUTE SETS                                                -->
<!-- ============================================================= -->

<xsl:attribute-set name="highlight.keyword.properties">
  <xsl:attribute name="color">
    <xsl:value-of select="$muk.blue" />
  </xsl:attribute>
  <xsl:attribute name="font-weight">inherit</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="highlight.string.properties">
  <xsl:attribute name="color">darkgreen</xsl:attribute>
  <xsl:attribute name="font-weight">inherit</xsl:attribute>
  <xsl:attribute name="font-style">inherit</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="highlight.comment.properties">
  <xsl:attribute name="color">
    <xsl:value-of select="'darkred'" />
  </xsl:attribute>
  <xsl:attribute name="font-style">inherit</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="highlight.tag.properties">
  <xsl:attribute name="color">
    <xsl:value-of select="$muk.blue" />
  </xsl:attribute>
  <xsl:attribute name="font-weight">bold</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="highlight.attribute.properties">
  <xsl:attribute name="color">indigo</xsl:attribute>
  <xsl:attribute name="font-weight">inherit</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="highlight.value.properties">
  <xsl:attribute name="color">teal</xsl:attribute>
  <xsl:attribute name="font-weight">inherit</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="highlight.number.properties">
  <xsl:attribute name="color">blue</xsl:attribute>
  <xsl:attribute name="font-weight">inherit</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="highlight.property.properties">
  <xsl:attribute name="color">forestgreen</xsl:attribute>
  <xsl:attribute name="font-weight">inherit</xsl:attribute>
</xsl:attribute-set>

</xsl:stylesheet>
