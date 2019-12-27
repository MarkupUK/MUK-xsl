<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">

<!-- ********************************************************************

     This file is not part of the DocBook XSL Stylesheet distribution.

     ******************************************************************** -->

<!-- ==================================================================== -->

<!-- One continuous sequence of page number. -->
<xsl:template name="page.number.format">1</xsl:template>

<xsl:template name="initial.page.number">
  <xsl:param name="element" select="local-name(.)"/>
  <xsl:param name="master-reference" select="''"/>

    <xsl:choose>
      <xsl:when test="$master-reference = 'body'">auto-even</xsl:when>
      <xsl:otherwise>auto-odd</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template name="force.page.count">
  <xsl:param name="element" select="local-name(.)"/>
  <xsl:param name="master-reference" select="''"/>

  <xsl:choose>
    <xsl:when test="$master-reference = 'body'">end-on-odd</xsl:when>
    <!-- Everything else. -->
    <xsl:otherwise>no-force</xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
