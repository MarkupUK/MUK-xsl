<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:exsl="http://exslt.org/common" xmlns:db="http://docbook.org/ns/docbook"
    exclude-result-prefixes="xs" version="1.0">

    <!-- Add sponsor pages -->

    <xsl:template match="book">
        <xsl:variable name="id">
            <xsl:call-template name="object.id"/>
        </xsl:variable>

        <xsl:variable name="preamble" select="title | subtitle | titleabbrev | bookinfo | info"/>

        <xsl:variable name="content"
            select="
                node()[not(self::title or self::subtitle
                or self::titleabbrev
                or self::info
                or self::bookinfo)]"/>

        <xsl:variable name="titlepage-master-reference">
            <xsl:call-template name="select.pagemaster">
                <xsl:with-param name="pageclass" select="'titlepage'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:call-template name="front.cover"/>

        <xsl:if test="$preamble">
            <xsl:call-template name="page.sequence">
                <xsl:with-param name="master-reference" select="$titlepage-master-reference"/>
                <xsl:with-param name="content">
                    <fo:block id="{$id}">
                        <xsl:call-template name="book.titlepage"/>
                    </fo:block>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:if>

        <xsl:apply-templates select="dedication" mode="dedication"/>
        <xsl:apply-templates select="acknowledgements" mode="acknowledgements"/>

        <xsl:call-template name="make.sponsors.pages"/>

        <xsl:call-template name="make.book.tocs"/>

        <xsl:apply-templates select="$content"/>

        <xsl:call-template name="back.cover"/>

    </xsl:template>


    <xsl:template name="make.sponsors.pages">

        <fo:page-sequence master-reference="sponsors" hyphenate="{$hyphenate}">
            <xsl:apply-templates select="." mode="running.head.mode">
                <xsl:with-param name="master-reference" select="'sponsors'"/>
            </xsl:apply-templates>

            <xsl:apply-templates select="." mode="running.foot.mode">
                <xsl:with-param name="master-reference" select="'sponsors'"/>
            </xsl:apply-templates>

            <xsl:call-template name="sponsors-flow"/>
        </fo:page-sequence>

    </xsl:template>


    <xsl:template name="user.pagemasters">
        <fo:simple-page-master master-name="sponsors-first" page-width="{$page.width}"
            page-height="{$page.height}" margin-top="{$page.margin.top}"
            margin-bottom="{$page.margin.bottom}">
            <xsl:attribute name="margin-{$direction.align.start}">
                <xsl:value-of select="$page.margin.inner"/>
                <xsl:if test="$fop.extensions != 0">
                    <xsl:value-of select="concat(' - (', $title.margin.left, ')')"/>
                </xsl:if>
                <xsl:if test="$fop.extensions != 0">
                    <xsl:value-of select="concat(' - (', $title.margin.left, ')')"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:attribute name="margin-{$direction.align.end}">
                <xsl:value-of select="$page.margin.outer"/>
            </xsl:attribute>
            <xsl:if test="$axf.extensions != 0">
                <xsl:call-template name="axf-page-master-properties">
                    <xsl:with-param name="page.master">sponsors-first</xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            <fo:region-body margin-bottom="{$body.margin.bottom}" margin-top="{$body.margin.top}"
                column-gap="{$column.gap.body}" column-count="{$column.count.body}">
                <xsl:attribute name="margin-{$direction.align.start}">
                    <xsl:value-of select="$body.margin.inner"/>
                </xsl:attribute>
                <xsl:attribute name="margin-{$direction.align.end}">
                    <xsl:value-of select="$body.margin.outer"/>
                </xsl:attribute>
            </fo:region-body>
            <fo:region-before region-name="xsl-region-before-first" extent="{$region.before.extent}"
                precedence="{$region.before.precedence}" display-align="before"/>
            <fo:region-after region-name="xsl-region-after-first" extent="{$region.after.extent}"
                precedence="{$region.after.precedence}" display-align="after"/>
            <xsl:call-template name="region.inner">
                <xsl:with-param name="sequence">first</xsl:with-param>
                <xsl:with-param name="pageclass">sponsors</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="region.outer">
                <xsl:with-param name="sequence">first</xsl:with-param>
                <xsl:with-param name="pageclass">sponsors</xsl:with-param>
            </xsl:call-template>
        </fo:simple-page-master>

        <fo:simple-page-master master-name="sponsors-odd" page-width="{$page.width}"
            page-height="{$page.height}" margin-top="{$page.margin.top}"
            margin-bottom="{$page.margin.bottom}">
            <xsl:attribute name="margin-{$direction.align.start}">
                <xsl:value-of select="$page.margin.inner"/>
                <xsl:if test="$fop.extensions != 0">
                    <xsl:value-of select="concat(' - (', $title.margin.left, ')')"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:attribute name="margin-{$direction.align.end}">
                <xsl:value-of select="$page.margin.outer"/>
            </xsl:attribute>
            <xsl:if test="$axf.extensions != 0">
                <xsl:call-template name="axf-page-master-properties">
                    <xsl:with-param name="page.master">sponsors-odd</xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            <fo:region-body margin-bottom="{$body.margin.bottom}" margin-top="{$body.margin.top}"
                column-gap="{$column.gap.body}" column-count="{$column.count.body}">
                <xsl:attribute name="margin-{$direction.align.start}">
                    <xsl:value-of select="$body.margin.inner"/>
                </xsl:attribute>
                <xsl:attribute name="margin-{$direction.align.end}">
                    <xsl:value-of select="$body.margin.outer"/>
                </xsl:attribute>
            </fo:region-body>
            <fo:region-before region-name="xsl-region-before-odd" extent="{$region.before.extent}"
                precedence="{$region.before.precedence}" display-align="before"/>
            <fo:region-after region-name="xsl-region-after-odd" extent="{$region.after.extent}"
                precedence="{$region.after.precedence}" display-align="after"/>
            <xsl:call-template name="region.inner">
                <xsl:with-param name="pageclass">sponsors</xsl:with-param>
                <xsl:with-param name="sequence">odd</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="region.outer">
                <xsl:with-param name="pageclass">sponsors</xsl:with-param>
                <xsl:with-param name="sequence">odd</xsl:with-param>
            </xsl:call-template>
        </fo:simple-page-master>

        <fo:simple-page-master master-name="sponsors-even" page-width="{$page.width}"
            page-height="{$page.height}" margin-top="{$page.margin.top}"
            margin-bottom="{$page.margin.bottom}">
            <xsl:attribute name="margin-{$direction.align.start}">
                <xsl:value-of select="$page.margin.outer"/>
                <xsl:if test="$fop.extensions != 0">
                    <xsl:value-of select="concat(' - (', $title.margin.left, ')')"/>
                </xsl:if>
            </xsl:attribute>
            <xsl:attribute name="margin-{$direction.align.end}">
                <xsl:value-of select="$page.margin.inner"/>
            </xsl:attribute>
            <xsl:if test="$axf.extensions != 0">
                <xsl:call-template name="axf-page-master-properties">
                    <xsl:with-param name="page.master">sponsors-even</xsl:with-param>
                </xsl:call-template>
            </xsl:if>
            <fo:region-body margin-bottom="{$body.margin.bottom}" margin-top="{$body.margin.top}"
                column-gap="{$column.gap.body}" column-count="2">
                <!-- {$column.count.body} -->
                <xsl:attribute name="margin-{$direction.align.start}">
                    <xsl:value-of select="$body.margin.outer"/>
                </xsl:attribute>
                <xsl:attribute name="margin-{$direction.align.end}">
                    <xsl:value-of select="$body.margin.inner"/>
                </xsl:attribute>
            </fo:region-body>
            <fo:region-before region-name="xsl-region-before-even" extent="{$region.before.extent}"
                precedence="{$region.before.precedence}" display-align="before"/>
            <fo:region-after region-name="xsl-region-after-even" extent="{$region.after.extent}"
                precedence="{$region.after.precedence}" display-align="after"/>
            <xsl:call-template name="region.outer">
                <xsl:with-param name="pageclass">sponsors</xsl:with-param>
                <xsl:with-param name="sequence">even</xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="region.inner">
                <xsl:with-param name="pageclass">sponsors</xsl:with-param>
                <xsl:with-param name="sequence">even</xsl:with-param>
            </xsl:call-template>
        </fo:simple-page-master>

        <fo:page-sequence-master master-name="sponsors">
            <fo:repeatable-page-master-alternatives>
                <fo:conditional-page-master-reference master-reference="blank"
                    blank-or-not-blank="blank"/>
                <fo:conditional-page-master-reference master-reference="sponsors-first"
                    page-position="first"/>
                <fo:conditional-page-master-reference master-reference="sponsors-odd"
                    odd-or-even="odd"/>
                <fo:conditional-page-master-reference odd-or-even="even">
                    <xsl:attribute name="master-reference">
                        <xsl:choose>
                            <xsl:when test="$double.sided != 0">sponsors-even</xsl:when>
                            <xsl:otherwise>sponsors-odd</xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </fo:conditional-page-master-reference>
            </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>
    </xsl:template>


    <xsl:template name="sponsors-flow">
        <fo:flow flow-name="xsl-region-body">
            <fo:block text-align="center" font-size="32pt" font-weight="bold">
                <xsl:text>Our Sponsors</xsl:text>
            </fo:block>
            <fo:block text-align="center" margin-bottom="20mm" margin-top="25mm">
                <fo:external-graphic content-width="130mm" src="img/evolved-binary-logo.png"/>
            </fo:block>
            <fo:block text-align="center">
                <fo:external-graphic content-width="130mm"
                    src="img/logo_crop-mid-blue-background.gif"/>
            </fo:block>

            <fo:block text-align="center" margin-top="40mm">
                <fo:external-graphic content-width="75mm"
                    src="https://www.oxygenxml.com/resellers/resources/OxygenXMLEditorLogo.svg"/>
            </fo:block>

            <fo:block font-size="14pt" font-weight="bold" page-break-before="always">
                <xsl:text>Organisation Committee</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Geert Bormans</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Tomos Hillman</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Ari Nordström</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Andrew Sales</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Rebecca Shoob</xsl:text>
            </fo:block>


            <fo:block font-size="14pt" font-weight="bold" margin-top="14pt">
                <xsl:text>Programme Committee</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Achim Berndzen - &lt;xml-project /&gt;</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Abel Braaksma - Abrasoft</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Peter Flynn - University College Cork</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Tony Graham - Antenna House</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Michael Kay - Saxonica</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Jirka Kosek - University of Economics, Prague</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Deborah A. Lapeyre - Mulberry Technologies</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Adam Retter - Evolved Binary</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>B. Tommie Usdin - Mulberry Technologies</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Norman Walsh - MarkLogic</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Lauren Wood - XML.com</xsl:text>
            </fo:block>

            <fo:block font-size="14pt" font-weight="bold" margin-top="14pt">
                <xsl:text>Thank You</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>Evolved Binary</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>Saxonica</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>oXygen XML Editor</xsl:text>
            </fo:block>

            <fo:block>
                <xsl:text>letex Publishing Services</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>Mercator</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>Exeter</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>Deborah A. Lapeyre</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>B. Tommie Usdin</xsl:text>
            </fo:block>

            <fo:block>
                <xsl:text>Bethan Tovey</xsl:text>
            </fo:block>

            <fo:block>
                <xsl:text>Adam Retter</xsl:text>
            </fo:block>

            <fo:block>
                <xsl:text>Jirka Kosek</xsl:text>
            </fo:block>

            <fo:block>
                <xsl:text>Norman Walsh</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>...and our long-suffering partners</xsl:text>
            </fo:block>

            <fo:block font-size="14pt" font-weight="bold" break-before="column">
                <xsl:text>Sister Conferences</xsl:text>
            </fo:block>

            <fo:block margin-top="8pt">
                <fo:external-graphic content-width="45mm" src="img/BalisageLogotype.png"/>
            </fo:block>
            <fo:block margin-top="8pt">
                <fo:external-graphic content-width="45mm" src="img/xmlprague-top-logo-13.png"/>
            </fo:block>
            <fo:block margin-top="8pt">
                <fo:external-graphic content-width="35mm" src="img/xmlss.svg"/>
            </fo:block>


            <fo:block font-size="14pt" font-weight="bold" margin-top="14pt">
                <fo:block>Markup UK 2019 Proceedings</fo:block>
            </fo:block>
            <fo:block font-size="10pt">
                <fo:block>by B. Tommie Usdin, Debbie Lapeyre, Karin Bredenberg, Jaime Kaminski, Peter Flynn, Marco Geue, Gerrit Imsieke, Andy Bunce, Alain Couthures, Andreas Tai, Michael Seiferle, Robin La Fontaine, Nigel A Whitaker, John Lumley, Octavian Nadolu, Tony Graham, Barnabas Davoti, Erik Siegel, Cristian Talau, Liam R E Quin, Syd Bauman, and Sandro Cirulli</fo:block>
            </fo:block>
            
        </fo:flow>
    </xsl:template>



</xsl:stylesheet>
