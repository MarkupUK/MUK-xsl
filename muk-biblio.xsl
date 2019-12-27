<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>

<!-- ********************************************************************

     Markup UK Bibliography

     This file is not part of the XSL DocBook Stylesheet distribution.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="bibliography">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="not(parent::*) or parent::part or parent::book">
      <xsl:variable name="master-reference">
        <xsl:call-template name="select.pagemaster"/>
      </xsl:variable>

      <fo:page-sequence hyphenate="{$hyphenate}"
                        master-reference="{$master-reference}">
        <xsl:attribute name="language">
          <xsl:call-template name="l10n.language"/>
        </xsl:attribute>
        <xsl:attribute name="format">
          <xsl:call-template name="page.number.format">
            <xsl:with-param name="master-reference" select="$master-reference"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="initial-page-number">
          <xsl:call-template name="initial.page.number">
            <xsl:with-param name="master-reference" select="$master-reference"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="force-page-count">
          <xsl:call-template name="force.page.count">
            <xsl:with-param name="master-reference" select="$master-reference"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="hyphenation-character">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'hyphenation-character'"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="hyphenation-push-character-count">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'hyphenation-push-character-count'"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="hyphenation-remain-character-count">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'hyphenation-remain-character-count'"/>
          </xsl:call-template>
        </xsl:attribute>

        <xsl:apply-templates select="." mode="running.head.mode">
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="running.foot.mode">
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:apply-templates>

        <fo:flow flow-name="xsl-region-body">
          <xsl:call-template name="set.flow.properties">
            <xsl:with-param name="element" select="local-name(.)"/>
            <xsl:with-param name="master-reference" select="$master-reference"/>
          </xsl:call-template>

          <fo:block id="{$id}">
            <xsl:call-template name="bibliography.titlepage"/>
          </fo:block>
          <xsl:apply-templates/>
        </fo:flow>
      </fo:page-sequence>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}"
                space-before.minimum="1em"
                space-before.optimum="1.5em"
                space-before.maximum="2em"
                padding-left="4pc">
        <xsl:call-template name="bibliography.titlepage"/>
      </fo:block>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
