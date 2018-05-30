<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:exsl="http://exslt.org/common"
    xmlns:db="http://docbook.org/ns/docbook"
    exclude-result-prefixes="xs"
    version="1.0">
    
    
    <xsl:import href="docbook-xsl-1.79.1/fo/docbook.xsl"/>
    <xsl:import href="muk-headers-footers.xsl"/>
    <xsl:import href="muk-titlepages.xsl"/>
    <xsl:import href="muk-sponsors.xsl"/>
    <xsl:param name="fo.processor" select="'fop'"/>
    
    
        <!-- Page Geometry -->
    <xsl:param name="paper.type" select="'A4'"/>
    <xsl:param name="page.margin.inner">25mm</xsl:param>
    <xsl:param name="page.margin.outer">25mm</xsl:param>
    <xsl:param name="page.margin.top">8mm</xsl:param>
    <xsl:param name="region.before.extent">20mm</xsl:param>
    <xsl:param name="body.margin.top">25mm</xsl:param>
    <xsl:param name="region.after.extent">11mm</xsl:param>
    <xsl:param name="page.margin.bottom">10mm</xsl:param>
    <xsl:param name="body.margin.bottom">15mm</xsl:param>
    <xsl:param name="double.sided">1</xsl:param>

    <!-- Header and footer column widths (left, centre, right) -->
    <xsl:param name="header.column.widths">7 1 7</xsl:param>
    <xsl:param name="footer.column.widths">5 1 1</xsl:param>
    
    <!-- TOC -->
    <xsl:param name="generate.toc" select="'book toc'"/>

    <!-- Body start indent (4pc default) -->
    <xsl:param name="body.start.indent" select="'0pt'"/>
    
    <!-- Xref Handling -->
    <xsl:param name="insert.xref.page.number">1</xsl:param>
    <xsl:param name="xref.with.number.and.title">0</xsl:param>


    <!-- Article title page handling -->
    <xsl:template name="article.titlepage.separator">
        <fo:block break-after="page"/>
    </xsl:template>
    
    
    

    <!-- Cover template for title page -->
    <xsl:template match="db:cover" mode="titlepage.mode">
        <fo:block-container border-style="solid" border-width="0.5pt" margin-left="40mm" margin-right="40mm">
            <!--<xsl:apply-templates/>-->
            <fo:block>
                <fo:external-graphic>
                    <xsl:attribute name="src">
                        <xsl:value-of select="db:mediaobject/db:imageobject/db:imagedata/@fileref"/>
                    </xsl:attribute>
                </fo:external-graphic>
            </fo:block>
        </fo:block-container>
    </xsl:template>


    <!-- Title Font Family -->
    <xsl:param name="title.font.family">sans-serif</xsl:param>

    <!-- Section numbering -->
    <xsl:param name="section.autolabel" select="'1'"/>

    <!-- Page Breaks -->
    <xsl:attribute-set name="section.level1.properties">
        <xsl:attribute name="break-before">page</xsl:attribute>
    </xsl:attribute-set>

    <!-- Section Title Level One Customization -->
    <xsl:attribute-set name="section.title.level1.properties">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$title.font.family"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="keep-with-next">
            <xsl:choose>
                <xsl:when test="parent::db:section[following-sibling::*[1][local-name(.)='section']]">auto</xsl:when>
                <xsl:otherwise>always</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
    </xsl:attribute-set>

    <!-- Section Title Level Two Customization -->
    <xsl:attribute-set name="section.title.level2.properties">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$title.font.family"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-size">13pt</xsl:attribute>
        <!--<xsl:attribute name="keep-with-next.within-column">10</xsl:attribute>-->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="page-break-before">
            <xsl:call-template name="page-break-before"/>
        </xsl:attribute>
        <xsl:attribute name="keep-with-next">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- Section Title Level Three Customization -->
    <xsl:attribute-set name="section.title.level3.properties">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$title.font.family"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <!--<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>-->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="keep-with-next">always</xsl:attribute>
        <xsl:attribute name="page-break-before">
            <xsl:call-template name="page-break-before"/>
        </xsl:attribute>
        <!--<xsl:attribute name="keep-with-previous">
            <xsl:call-template name="keep-sections-2-4"/>
        </xsl:attribute>-->
    </xsl:attribute-set>

    <!-- Section Title Level Four Customization -->
    <xsl:attribute-set name="section.title.level4.properties">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$title.font.family"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <!--<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>-->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="keep-with-next">always</xsl:attribute>
        <xsl:attribute name="page-break-before">
            <xsl:call-template name="page-break-before"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    
    <!-- Page break before logic -->
    <xsl:template name="page-break-before">
        <xsl:choose>
            <xsl:when test="parent::db:section[preceding-sibling::*]">always</xsl:when>
            <xsl:otherwise>auto</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    

    <!-- Body Font -->
    <xsl:param name="body.font.family">sans-serif</xsl:param>
    <xsl:param name="body.font.master" select="9"/>


    <!-- Tables -->
    <xsl:param name="default.table.column.widths" select="number(0)"/>


    <!-- Graphics -->
    <xsl:param name="default.image.width" select="'160mm'"/>


    
    
    <xsl:attribute-set name="thead.attrs.common">
        <xsl:attribute name="padding-start">2pt</xsl:attribute>
        <xsl:attribute name="padding-end">2pt</xsl:attribute>
        <xsl:attribute name="padding-top">1.5pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">0pt</xsl:attribute>
        <xsl:attribute name="border-bottom-width">0.5pt</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-color">black</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="thead.attrs.not-last">
        <xsl:attribute name="border-end-width">0.5pt</xsl:attribute>
        <xsl:attribute name="border-end-style">solid</xsl:attribute>
        <xsl:attribute name="border-end-color">black</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="table.cell.padding">
        <xsl:attribute name="padding-start">2pt</xsl:attribute>
        <xsl:attribute name="padding-end">2pt</xsl:attribute>
        <xsl:attribute name="padding-top">1.5pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">0pt</xsl:attribute>
    </xsl:attribute-set>

    
</xsl:stylesheet>