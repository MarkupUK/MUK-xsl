<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:db="http://docbook.org/ns/docbook" xmlns:ng="http://docbook.org/docbook-ng" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:date="http://exslt.org/dates-and-times" xmlns:exsl="http://exslt.org/common" extension-element-prefixes="date" exclude-result-prefixes="db ng exsl" version="1.0">

    <!-- Header and Footer Customizations for muk DocBook -->
    
    
    
    <!-- Header image -->
    <xsl:param name="header.image.filename" select="'img/MarkupUK.svg.png'"/>
    
    
    
    <!-- Header -->
    <xsl:template name="header.content">
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
            
            <!-- sequence can be odd, even, first, blank -->
            <!-- position can be left, center, right -->
            <xsl:choose>
                <xsl:when test="$sequence = 'blank' and $position = 'left'">
                    <xsl:call-template name="draft.text"/>
                    <xsl:call-template name="muk-logo"/>
                </xsl:when>
                
                <xsl:when test="$sequence = 'blank'">
                    <!-- Nothing -->
                </xsl:when>
                
                <xsl:when test="$position='left' and $sequence='even'">
                    <xsl:call-template name="draft.text"/>
                    <xsl:call-template name="muk-logo"/>
                </xsl:when>
                
                <xsl:when test="$position='right' and $sequence='even'">
                    <xsl:if test="$pageclass != 'titlepage'">
                        <xsl:choose>
                            <xsl:when test="ancestor::book and ($double.sided != 0)">
                                <fo:block margin-top="4mm">
                                    <fo:retrieve-marker retrieve-class-name="section.head.marker"
                                        retrieve-position="first-including-carryover"
                                        retrieve-boundary="page-sequence"/>
                                </fo:block>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="." mode="titleabbrev.markup"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:when>
                
                <xsl:when test="($sequence='odd' or $sequence='even') and $position='center'">
                    <!-- Nothing here -->
                </xsl:when>
                
                <xsl:when test="$position='center'">
                    <!-- nothing for empty and blank sequences -->
                </xsl:when>
                
                <xsl:when test="$position='right' and $sequence='odd'">
                    <!-- Same for odd, even, empty, and blank sequences -->
                    <xsl:call-template name="draft.text"/>
                    <xsl:call-template name="muk-logo"/>
                </xsl:when>
                
                <xsl:when test="$position='right' and $sequence='first'">
                    <xsl:call-template name="draft.text"/>
                    <xsl:call-template name="muk-logo"/>
                </xsl:when>
                
                <xsl:when test="$position='left' and $sequence='odd'">
                    <xsl:if test="$pageclass != 'titlepage'">
                        <xsl:choose>
                            <xsl:when test="ancestor::book and ($double.sided != 0)">
                                <fo:block margin-top="4mm">
                                    <fo:retrieve-marker retrieve-class-name="section.head.marker"
                                        retrieve-position="first-including-carryover"
                                        retrieve-boundary="page-sequence"/>
                                </fo:block>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="." mode="titleabbrev.markup"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:if>
                </xsl:when>
                
                <!--<xsl:when test="$sequence = 'first'">
                    <xsl:call-template name="muk-logo"/>
                </xsl:when>-->
                
                <xsl:when test="$sequence = 'blank'">
                    <xsl:call-template name="muk-logo"/>
                </xsl:when>
            </xsl:choose>
        </fo:block>
    </xsl:template>
    
    
    <xsl:template name="muk-logo">
        <fo:external-graphic content-height="8mm" scaling="uniform" width="100%" content-width="scale-to-fit">
            <xsl:attribute name="src">
                <xsl:call-template name="fo-external-image">
                    <xsl:with-param name="filename" select="$header.image.filename"/>
                </xsl:call-template>
            </xsl:attribute>
        </fo:external-graphic>
    </xsl:template>
    
    
    <!-- Footer content -->
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
                <xsl:when test="$pageclass = 'titlepage'">
                    <!-- nop; no footer on title pages -->
                </xsl:when>
                
                <xsl:when test="$pageclass = 'front'">
                    <!-- nop; no footer on front matter pages -->
                </xsl:when>
                
                <xsl:when test="$double.sided != 0 and $sequence = 'even'
                    and $position='left'">
                    <fo:page-number/>
                </xsl:when>
                
                <xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first')
                    and $position='right' and $pageclass != 'sponsors'">
                    <fo:page-number/>
                </xsl:when>
                
                <xsl:when test="$double.sided = 0 and $position='center'">
                    <fo:page-number/>
                </xsl:when>
                
                <xsl:when test="$sequence='blank'">
                    <xsl:choose>
                        <xsl:when test="$double.sided != 0 and $position = 'left'">
                            <!--<fo:page-number/>-->
                        </xsl:when>
                        <xsl:when test="$double.sided = 0 and $position = 'center'">
                            <!--<fo:page-number/>-->
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
    
    
    
    <!-- Page Footer -->
    <!--<xsl:template name="footer.content">
        <xsl:param name="pageclass" select="''"/>
        <xsl:param name="sequence" select="''"/>
        <xsl:param name="position" select="''"/>
        <xsl:param name="gentext-key" select="''"/>
        
        <!-\-
  <fo:block>
    <xsl:value-of select="$pageclass"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$sequence"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$position"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$gentext-key"/>
  </fo:block>
-\->
        <fo:block>
            <!-\- pageclass can be front, body, back -\->
            <!-\- sequence can be odd, even, first, blank -\->
            <!-\- position can be left, center, right -\->
            <xsl:choose>
                <xsl:when test="$pageclass = 'titlepage'">
                    <!-\- nop; no footer on title pages -\->
                </xsl:when>
                <xsl:when test="$double.sided != 0 and $sequence = 'even'                     and $position='left'">
                    <!-\- Standard footer texts go here -\->
                </xsl:when>
                <xsl:when test="$double.sided != 0 and ($sequence = 'odd' or $sequence = 'first')                     and $position='right'">
                    <fo:page-number/>
                </xsl:when>
                <xsl:when test="$double.sided = 0 and $position='left'">
                    <fo:block font-size="8pt" margin-top="9pt">
                        <xsl:call-template name="gentext">
                            <xsl:with-param name="key" select="'Generated'"/>
                        </xsl:call-template>
                        <xsl:value-of select="/db:article/db:info/db:date"/>
                    </fo:block>
                    <fo:block font-size="8pt">
                        <xsl:call-template name="gentext">
                            <xsl:with-param name="key" select="'footer-disclaimer'"/>
                        </xsl:call-template>
                    </fo:block>
                </xsl:when>
                <xsl:when test="$double.sided = 0 and $position='center'">
                    <!-\- No content -\->
                </xsl:when>
                
                <!-\- This doesn't happen for now -\->
                <xsl:when test="$sequence='blank'">
                    <xsl:choose>
                        <xsl:when test="$double.sided != 0 and $position = 'left'">
                            <!-\- No content -\->
                        </xsl:when>
                        <xsl:when test="$double.sided = 0 and $position = 'center'">
                            <!-\- No content -\->
                        </xsl:when>
                        <xsl:otherwise>
                            <!-\- No content -\->
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$double.sided = 0 and $position='right'">
                    <fo:block>
                        <fo:page-number/>
                    </fo:block>
                    <fo:block> </fo:block>
                </xsl:when>
                <xsl:otherwise>
                    <!-\- Position right -\->
                    <!-\-<fo:page-number/>-\->
                </xsl:otherwise>
            </xsl:choose>
        </fo:block>
    </xsl:template>-->
</xsl:stylesheet>