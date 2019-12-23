<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:sverb="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.Verbatim"
                xmlns:xverb="com.nwalsh.xalan.Verbatim"
                xmlns:lxslt="http://xml.apache.org/xslt"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="sverb xverb lxslt exsl"
                version='1.0'>

<!-- ********************************************************************

     This file is not part of the XSL DocBook Stylesheet distribution.

     ******************************************************************** -->

<xsl:template name="is-wide">
  <xsl:param name="string" select="''" />
  <xsl:param name="limit" select="66" />

  <xsl:choose>
    <xsl:when test="contains($string, '&#xA;')">
      <xsl:choose>
        <xsl:when
            test="string-length(substring-before($string, '&#xA;')) > $limit">
          <xsl:text>1</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="is-wide">
            <xsl:with-param name="string"
                            select="substring-after($string, '&#xA;')" />
            <xsl:with-param name="limit" select="$limit" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when
            test="string-length($string) > $limit">
          <xsl:text>1</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>0</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="programlisting|screen|synopsis">
  <xsl:param name="suppress-numbers" select="'0'"/>
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>

  <xsl:variable name="content">
    <xsl:choose>
      <xsl:when test="$suppress-numbers = '0'
                      and @linenumbering = 'numbered'
                      and $use.extensions != '0'
                      and $linenumbering.extension != '0'">
        <xsl:call-template name="number.rtf.lines">
          <xsl:with-param name="rtf">
            <xsl:choose>
              <xsl:when test="$highlight.source != 0">
                <xsl:call-template name="apply-highlighting"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="$highlight.source != 0">
            <xsl:call-template name="apply-highlighting"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="keep.together">
    <xsl:call-template name="pi.dbfo_keep-together"/>
  </xsl:variable>

  <xsl:variable name="font.size">
    <xsl:call-template name="pi.dbfo_font-size">
      <xsl:with-param name="node"
        select="(self::*[processing-instruction('dbfo')]|
                 parent::*[processing-instruction('dbfo')])[last()]"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="string-value" select="string(.)" />
  <xsl:variable name="is-wide">
    <xsl:call-template name="is-wide">
      <xsl:with-param name="string" select="$string-value" />
      <xsl:with-param name="limit" select="71" />
    </xsl:call-template>
  </xsl:variable>

<!--
  <xsl:message>is-wide: <xsl:value-of select="$is-wide" />
    <xsl:text>: </xsl:text>
    <xsl:value-of select="substring-before($string-value, '&#xA;')" />
  </xsl:message>
-->

  <xsl:variable name="block.content">
    <xsl:choose>
      <xsl:when test="$shade.verbatim != 0">
        <fo:block id="{$id}"
             xsl:use-attribute-sets="monospace.verbatim.properties shade.verbatim.style">
         <xsl:if test="$keep.together != ''">
           <xsl:attribute name="keep-together.within-column"><xsl:value-of
               select="$keep.together"/></xsl:attribute>
         </xsl:if>
         <xsl:if test="$font.size != ''">
           <xsl:attribute name="font-size"><xsl:value-of select="$font.size"/></xsl:attribute>
         </xsl:if>
          <xsl:if test="$is-wide = 1">
            <xsl:attribute name="start-indent">0</xsl:attribute>
         </xsl:if>
          <xsl:choose>
            <xsl:when test="$hyphenate.verbatim != 0 and
                            $exsl.node.set.available != 0">
              <xsl:apply-templates select="exsl:node-set($content)"
                                   mode="hyphenate.verbatim"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="$content"/>
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block id="{$id}"
                  xsl:use-attribute-sets="monospace.verbatim.properties">
	  <xsl:if test="$keep.together != ''">
	    <xsl:attribute name="keep-together.within-column"><xsl:value-of
	    select="$keep.together"/></xsl:attribute>
	  </xsl:if>
          <xsl:if test="$is-wide">
            <xsl:attribute name="start-indent">0</xsl:attribute>
          </xsl:if>
          <xsl:choose>
            <xsl:when test="$hyphenate.verbatim != 0 and
                            $exsl.node.set.available != 0">
              <xsl:apply-templates select="exsl:node-set($content)"
                                   mode="hyphenate.verbatim"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:copy-of select="$content"/>
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <!-- Need a block-container for these features -->
    <xsl:when test="@width != '' or
                    (self::programlisting and
                    starts-with($writing.mode, 'rl'))">
      <fo:block-container start-indent="0pt" end-indent="0pt">
        <xsl:if test="@width != ''">
          <xsl:attribute name="width">
            <xsl:value-of select="concat(@width, '*', $monospace.verbatim.font.width)"/>
          </xsl:attribute>
        </xsl:if>
        <!-- All known program code is left-to-right -->
        <xsl:if test="self::programlisting and
                      starts-with($writing.mode, 'rl')">
          <xsl:attribute name="writing-mode">lr-tb</xsl:attribute>
        </xsl:if>
      </fo:block-container>
    </xsl:when>
    <xsl:when test="$is-wide">
      <fo:block-container xsl:use-attribute-sets="pgwide.properties">
        <!-- All known program code is left-to-right -->
        <xsl:if test="self::programlisting and
                      starts-with($writing.mode, 'rl')">
          <xsl:attribute name="writing-mode">lr-tb</xsl:attribute>
        </xsl:if>
        <xsl:copy-of select="$block.content"/>
      </fo:block-container>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$block.content"/>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

</xsl:stylesheet>
