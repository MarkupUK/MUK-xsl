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

<xsl:template name="footnote-separator">
  <fo:static-content flow-name="xsl-footnote-separator">
    <fo:block start-indent="{$body.start.indent}">
      <fo:leader xsl:use-attribute-sets="footnote.sep.leader.properties"/>
    </fo:block>
  </fo:static-content>
</xsl:template>

<xsl:template name="width.set">
  <xsl:param name="location" select="'header'"/>
  <xsl:param name="position" select="1"/>
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

  <xsl:message>
    <xsl:value-of select="concat('location: ',$location,'; position: ',$position,'; pageclass: ',$pageclass,'; sequence: ',$sequence,'; gentext-key: ',$gentext-key, ';')" />
  </xsl:message>

  <xsl:choose>
    <xsl:when test="$location = 'header'">
      <xsl:value-of select="normalize-space($header.column.widths)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="normalize-space($footer.column.widths)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
