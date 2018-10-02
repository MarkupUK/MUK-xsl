<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:exsl="http://exslt.org/common"
    xmlns:db="http://docbook.org/ns/docbook"
    xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
    exclude-result-prefixes="xs"
    version="1.0">
    
    
    <xsl:import href="docbook-xsl-1.79.1/fo/docbook.xsl"/>
    <xsl:import href="muk-headers-footers.xsl"/>
    <xsl:import href="muk-titlepages.xsl"/>
    <xsl:import href="muk-sponsors.xsl"/>
    <xsl:param name="fo.processor" select="'fop'"/>
    
    <xsl:param name="fop1.extensions" select="1"/>
    <xsl:param name="fop.extensions" select="1"/>
    
    
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
    <xsl:param name="generate.toc" select="'book toc,title'"/>
    <xsl:param name="toc.section.depth" select="0"/>
    
    <!-- Columns, title pages -->
    <xsl:param name="column.count.titlepage" select="1"/>

    <!-- Body start indent (4pc default) -->
    <xsl:param name="body.start.indent" select="'0pt'"/>
    
    <!-- Xref Handling -->
    <xsl:param name="insert.xref.page.number">1</xsl:param>
    <xsl:param name="xref.with.number.and.title">0</xsl:param>
    
    <!-- Hyphenate -->
    <xsl:param name="hyphenate" select="'false'"/>


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
    <xsl:param name="title.font.family">Garamond, EB Garamond, Palatino Linotype</xsl:param>

    <!-- Section numbering -->
    <xsl:param name="section.autolabel" select="'1'"/>
    
    
    <!-- Suppress email in author info -->
    <xsl:template match="author" mode="titlepage.mode">
        <fo:block>
            <xsl:call-template name="anchor"/>
            <xsl:choose>
                <xsl:when test="orgname">
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="person.name"/>
                    <xsl:if test="affiliation/orgname">
                        <xsl:text>, </xsl:text>
                        <xsl:apply-templates select="affiliation/orgname" mode="titlepage.mode"/>
                    </xsl:if>
                    <!--<xsl:if test="affiliation/address/email">
                        <xsl:text> </xsl:text>
                        <xsl:apply-templates select="(affiliation/address/email)[1]"/>
                    </xsl:if>-->
                </xsl:otherwise>
            </xsl:choose>
        </fo:block>
    </xsl:template>
    
    
    <!-- TOC Customisation for adding author -->
    
    

    <!-- Page Breaks: ALLOW SECTIONS TO RUN ON
    <xsl:attribute-set name="section.level1.properties">
        <xsl:attribute name="break-before">page</xsl:attribute>
    </xsl:attribute-set>-->

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
        <!--<xsl:attribute name="page-break-before">
            <xsl:call-template name="page-break-before"/>
        </xsl:attribute>-->
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
        <!--<xsl:attribute name="page-break-before">
            <xsl:call-template name="page-break-before"/>
        </xsl:attribute>-->
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
        <!--<xsl:attribute name="page-break-before">
            <xsl:call-template name="page-break-before"/>
        </xsl:attribute>-->
    </xsl:attribute-set>
    
    
    <!-- Page break before logic 
    <xsl:template name="page-break-before">
        <xsl:choose>
            <xsl:when test="parent::db:section[preceding-sibling::*]">always</xsl:when>
            <xsl:otherwise>auto</xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->
    
    

    <!-- Body Font -->
    <xsl:param name="body.font.family">Garamond, EB Garamond, Palatino Linotype</xsl:param>
    <xsl:param name="body.font.master" select="9"/>
    
    <!-- Programlisting Font -->
    <xsl:param name="monospace.font.family">DejaVu Sans Mono</xsl:param>


    <!-- Tables -->
    <xsl:param name="default.table.column.widths" select="number(0)"/>


    <!-- Graphics -->
    <xsl:param name="default.image.width" select="'160mm'"/>

    
    <!-- Program listing -->
    <xsl:attribute-set name="monospace.verbatim.properties">
        <xsl:attribute name="font-size">
            <xsl:choose>
                <xsl:when test="processing-instruction('db-font-size')"><xsl:value-of
                    select="processing-instruction('db-font-size')"/></xsl:when>
                <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>
    
    
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
    
    <!-- add author names to ToC: customising autotoc.xsl -->
    <xsl:template name="toc.line">
        <xsl:param name="toc-context" select="NOTANODE"/>
        
        <xsl:variable name="id">
            <xsl:call-template name="object.id"/>
        </xsl:variable>
        
        <xsl:variable name="label">
            <xsl:apply-templates select="." mode="label.markup"/>
        </xsl:variable>
        
        <fo:block xsl:use-attribute-sets="toc.line.properties">
            <fo:inline keep-with-next.within-line="always">
                <fo:basic-link internal-destination="{$id}">
                    <xsl:if test="$label != ''">
                        <xsl:copy-of select="$label"/>
                        <xsl:value-of select="$autotoc.label.separator"/>
                    </xsl:if>
                    <xsl:apply-templates select="." mode="titleabbrev.markup"/>
                </fo:basic-link>
                <!-- hackeroo -->
                <xsl:text> &#x2013; </xsl:text>
                <fo:inline font-style="italic">
                    <xsl:apply-templates select="(articleinfo/author|articleinfo/authorgroup/author)" mode="bibliography.mode"/>
                </fo:inline> 
                <!-- fun ends here -->
            </fo:inline>
            <fo:inline keep-together.within-line="always">
                <fo:leader xsl:use-attribute-sets="toc.leader.properties"/>
                <fo:basic-link internal-destination="{$id}">
                    <fo:page-number-citation ref-id="{$id}"/>
                </fo:basic-link>
            </fo:inline>
        </fo:block>
    </xsl:template>

    
</xsl:stylesheet>