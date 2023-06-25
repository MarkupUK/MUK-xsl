<?xml version='1.0'?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="doc xlink"
  version='1.0'>


<!-- ********************************************************************

     Markup UK Proceedings.

     This file is not part of the XSL DocBook Stylesheet distribution.

     ******************************************************************** -->

<xsl:attribute-set name="attribution.properties">
  <xsl:attribute name="text-align">right</xsl:attribute>
</xsl:attribute-set>

<xsl:template match="blockquote">
  <xsl:variable name="keep.together">
    <xsl:call-template name="pi.dbfo_keep-together"/>
  </xsl:variable>
  <fo:block xsl:use-attribute-sets="blockquote.properties">
    <xsl:if test="$keep.together != ''">
      <xsl:attribute name="keep-together.within-column"><xsl:value-of
                      select="$keep.together"/></xsl:attribute>
    </xsl:if>
    <xsl:call-template name="anchor"/>
    <fo:block>
      <xsl:if test="title|info/title">
        <fo:block xsl:use-attribute-sets="formal.title.properties">
          <xsl:apply-templates select="." mode="object.title.markup"/>
        </fo:block>
      </xsl:if>
      <xsl:apply-templates select="*[local-name(.) != 'title'
                                   and local-name(.) != 'attribution']"/>
    </fo:block>
    <xsl:if test="attribution">
      <fo:block xsl:use-attribute-sets="attribution.properties">
        <!-- mdash -->
        <xsl:text>&#x2014;</xsl:text>
        <xsl:apply-templates select="attribution"/>
      </fo:block>
    </xsl:if>
  </fo:block>
</xsl:template>

</xsl:stylesheet>
