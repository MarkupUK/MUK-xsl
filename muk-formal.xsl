<?xml version='1.0'?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    version='1.0'>

<!-- ********************************************************************

     Markup UK Proceedings.

     This file is not part of the XSL DocBook Stylesheet distribution.

     ******************************************************************** -->

<xsl:template match="figure">
  <xsl:variable name="param.placement"
              select="substring-after(normalize-space($formal.title.placement),
                                      concat(local-name(.), ' '))"/>

  <xsl:variable name="placement">
    <xsl:choose>
      <xsl:when test="contains($param.placement, ' ')">
        <xsl:value-of select="substring-before($param.placement, ' ')"/>
      </xsl:when>
      <xsl:when test="$param.placement = ''">before</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$param.placement"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="figure">
    <xsl:choose>
      <xsl:when test="@pgwide = '1'">
      <xsl:call-template name="formal.object.heading">
        <xsl:with-param name="placement" select="$placement"/>
      </xsl:call-template>
        <fo:float float="inside"
                  axf:float-reference="page"
                  axf:float-x="inside"
                  axf:float-move="keep">
          <fo:block-container text-align="inside">
            <fo:block-container width="160mm">
              <fo:block xsl:use-attribute-sets="pgwide.properties">
                <xsl:apply-templates />
              </fo:block>
            </fo:block-container>
          </fo:block-container>
        </fo:float>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="formal.object">
          <xsl:with-param name="placement" select="$placement"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="floatstyle">
    <xsl:call-template name="floatstyle"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$floatstyle != ''">
      <xsl:call-template name="floater">
        <xsl:with-param name="position" select="$floatstyle"/>
        <xsl:with-param name="content" select="$figure"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$figure"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
