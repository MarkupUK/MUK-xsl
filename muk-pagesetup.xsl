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

<xsl:template name="footer.content">
  <xsl:param name="pageclass" select="''"/>
  <xsl:param name="sequence" select="''"/>
  <xsl:param name="position" select="''"/>
  <xsl:param name="gentext-key" select="''"/>

<!--
  <fo:block>
    <xsl:value-of select="$pageclass"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$sequence"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$position"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$gentext-key"/>
  </fo:block>
-->

  <fo:block>
    <!-- pageclass can be front, body, back -->
    <!-- sequence can be odd, even, first, blank -->
    <!-- position can be left, center, right -->
    <xsl:choose>
      <!-- MUK additions. -->
      <xsl:when test="$gentext-key = 'article' and
                      (($sequence = 'first' or $sequence = 'even')
                        and $position='left') or
                      ($sequence = 'odd' and $position='right')">
        <fo:page-number/>
      </xsl:when>

      <xsl:when test="$gentext-key = 'article'" />

      <!-- End of MUK additions. -->

      <xsl:when test="$pageclass = 'titlepage'">
        <!-- nop; no footer on title pages -->
      </xsl:when>

      <xsl:when test="$double.sided != 0 and $sequence = 'even'
                      and $position='left'">
        <fo:page-number/>
      </xsl:when>

      <xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first')
                      and $position='right'">
        <fo:page-number/>
      </xsl:when>

      <xsl:when test="$double.sided = 0 and $position='center'">
        <fo:page-number/>
      </xsl:when>

      <xsl:when test="$sequence='blank'">
        <xsl:choose>
          <xsl:when test="$double.sided != 0 and $position = 'left'">
            <fo:page-number/>
          </xsl:when>
          <xsl:when test="$double.sided = 0 and $position = 'center'">
            <fo:page-number/>
          </xsl:when>
          <xsl:otherwise>
            <!-- nop -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>


      <xsl:otherwise>
        <!-- nop -->
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

</xsl:stylesheet>
