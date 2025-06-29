<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:fo="http://www.w3.org/1999/XSL/Format">

  <xsl:attribute-set name="administrivia.title.properties">
    <xsl:attribute name="font-family">
      <xsl:value-of select="$title.font.family"/>
    </xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
      <xsl:attribute name="color">
        <xsl:value-of select="$muk.blue" />
      </xsl:attribute>
    <xsl:attribute name="font-size">14pt</xsl:attribute>
    <xsl:attribute name="space-before">14pt</xsl:attribute>
  </xsl:attribute-set>

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

      <fo:page-sequence
          master-reference="sponsors"
          initial-page-number="auto-even"
          hyphenate="{$hyphenate}">
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
                column-gap="{$column.gap.body}" column-count="2">
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
                <!--
                <fo:conditional-page-master-reference master-reference="sponsors-first"
                    page-position="first"/>
                -->
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

        <fo:simple-page-master
            master-name="back-cover" page-width="{$page.width}"
            page-height="{$page.height}"
            margin-top="{$page.margin.top}"
            margin-bottom="{$page.margin.bottom}"
            background-image="url({$muk-xsl.dir}/img/background.jpg)"
            axf:background-size="cover">
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
            <fo:region-body
                margin-bottom="{$body.margin.bottom}"
                margin-top="{$body.margin.top}"
                column-gap="{$column.gap.body}">
                <xsl:attribute name="margin-{$direction.align.start}">
                    <xsl:value-of select="$body.margin.inner"/>
                </xsl:attribute>
                <xsl:attribute name="margin-{$direction.align.end}">
                    <xsl:value-of select="$body.margin.outer"/>
                </xsl:attribute>
            </fo:region-body>
        </fo:simple-page-master>
    </xsl:template>


    <xsl:template name="sponsors-flow">
        <fo:flow flow-name="xsl-region-body">
            <!--<fo:block text-align="center" font-size="32pt" font-weight="bold">
                <xsl:text>Our Sponsors</xsl:text>
            </fo:block>-->
            <!-- Evolved Binary, Fusion DB -->
            <!--<fo:block text-align="center" margin-bottom="20mm" margin-top="25mm">
                <fo:external-graphic content-width="130mm" src="{$muk-xsl.dir}/img/evolved-binary-logo.png"/>
            </fo:block>-->
            
            <fo:table>
                <fo:table-body>
                    <fo:table-row >
                        <fo:table-cell>
                            <fo:block text-align="center" margin-bottom="25mm" margin-top="10mm" font-weight="bold" font-size="18">
                                Silver
                            </fo:block>                
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block text-align="center" margin-bottom="50mm" margin-top="10mm">
                                <fo:external-graphic content-width="150mm" src="{$muk-xsl.dir}/img/logo-antena-en.svg"/>
                            </fo:block>                
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell>
                            <!-- Saxonica -->
                            <fo:block text-align="center" vertical-align="center" margin-top="10mm">
                                <fo:external-graphic content-width="150mm"
                                    src="{$muk-xsl.dir}/img/logo_crop-mid-blue-background.gif"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
            
            
            
            <fo:table width="130mm" page-break-before="always">
                <fo:table-body>
                    <fo:table-row>
                        <fo:table-cell>                            
                            <fo:block text-align="center" margin-bottom="25mm" margin-top="10mm" font-weight="bold" font-size="18">
                                Bronze
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block text-align="center" margin-bottom="50mm" margin-top="10mm">
                                <fo:external-graphic content-width="110mm" margin-bottom="30mm"
                                    src="{$muk-xsl.dir}/img/elemental_logo.svg"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                    <fo:table-row>
                        <fo:table-cell>
                            <fo:block  text-align="center" vertical-align="center" margin-top="10mm">
                                <fo:external-graphic content-width="120mm"
                                    src="{$muk-xsl.dir}/img/letex-logo.png"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </fo:table-body>
            </fo:table>
            
            <!--<!-\- oXygen -\->
            <fo:block text-align="center" margin-top="40mm"  page-break-before="always">
                <fo:external-graphic content-width="75mm"
                    src="https://www.oxygenxml.com/resellers/resources/OxygenXMLEditorLogo.svg"/>
            </fo:block>
            
            <!-\- letex -\->
            <fo:block text-align="center" margin-top="40mm">
                <fo:external-graphic content-width="75mm"
                    src="{$muk-xsl.dir}/img/letex-logo.png"/>
            </fo:block>
            
            <!-\- Mercator -\->
            <fo:block text-align="center" margin-top="40mm">
                <fo:external-graphic content-width="75mm"
                    src="{$muk-xsl.dir}/img/mercator-logo.png"/>
            </fo:block>
            
            <!-\- exeter -\->
            <fo:block text-align="center" margin-top="40mm">
                <fo:external-graphic content-width="75mm"
                    src="{$muk-xsl.dir}/img/exeterLogo.png"/>
            </fo:block>
            
            <!-\- Mulberry -\->
            <fo:block text-align="center" margin-top="40mm">
                <fo:external-graphic content-width="75mm"
                    src="{$muk-xsl.dir}/img/mul-logo.png"/>
            </fo:block>-->

            <fo:block
                xsl:use-attribute-sets="administrivia.title.properties"
                page-break-before="always">
                <xsl:text>Markup UK</xsl:text>
            </fo:block>
            <fo:block>A Conference about XML and Other Markup Technologies<fo:block /><fo:basic-link external-destination="https://markupuk.org/">https://markupuk.org/</fo:basic-link></fo:block>
            <fo:block space-before="1lh">Markup UK Conferences Limited<fo:block /> is a limited company registered in England and Wales.<fo:block/>Company registration number: 11623628<fo:block/>Registered address: 24 Trimworth Road, Folkestone, CT19 4EL, UK<fo:block/>VAT Registration Number: 316 5241 25</fo:block>
            <fo:block
                xsl:use-attribute-sets="administrivia.title.properties">
                <xsl:text>Organisation Committee</xsl:text>
            </fo:block>
            <fo:block>
                <xsl:text>Geert Bormans</xsl:text>
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


            <fo:block
                xsl:use-attribute-sets="administrivia.title.properties">
                <xsl:text>Programme Committee</xsl:text>
            </fo:block>
            <fo:block start-indent="1em" text-indent="-1em">
                <xsl:text>Syd Bauman &#x2013; Northeastern University Digital Scholarship Group</xsl:text>
            </fo:block>
            <fo:block start-indent="1em" text-indent="-1em">
                <xsl:text>Tony Graham &#x2013; Antenna House</xsl:text>
            </fo:block>
            <fo:block start-indent="1em" text-indent="-1em">
                <xsl:text>Michael Kay &#x2013; Saxonica</xsl:text>
            </fo:block>
            <fo:block start-indent="1em" text-indent="-1em">
                <xsl:text>Jirka Kosek &#x2013; Prague University of Economics and Business</xsl:text>
            </fo:block>
            <fo:block start-indent="1em" text-indent="-1em">
                <xsl:text>Deborah A. Lapeyre &#x2013; Mulberry Technologies</xsl:text>
            </fo:block>
            <fo:block start-indent="1em" text-indent="-1em">
                <xsl:text>David Maus &#x2013; State and University Library Hamburg</xsl:text>
            </fo:block>
            <fo:block start-indent="1em" text-indent="-1em">
                <xsl:text>Adam Retter &#x2013; Evolved Binary</xsl:text>
            </fo:block>
            <fo:block start-indent="1em" text-indent="-1em">
                <xsl:text>B. Tommie Usdin &#x2013; Mulberry Technologies</xsl:text>
            </fo:block>
            <fo:block start-indent="1em" text-indent="-1em">
                <xsl:text>Norman Walsh &#x2013; MarkLogic</xsl:text>
            </fo:block>
            <fo:block start-indent="1em" text-indent="-1em">
                <xsl:text>Lauren Wood &#x2013; XML.com</xsl:text>
            </fo:block>

            <fo:block
                xsl:use-attribute-sets="administrivia.title.properties">
                <xsl:text>Thank You</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>Antenna House</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>Evolved Binary</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>Ilmari Koria</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>le-tex Publishing Services</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>OxygenXML</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>Saxonica</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>Wissam Asfahani</xsl:text>
            </fo:block>
            
            <fo:block>
                <xsl:text>...and our long-suffering partners</xsl:text>
            </fo:block>

            <fo:block
                xsl:use-attribute-sets="administrivia.title.properties"
                break-before="column">
                <xsl:text>Sister Conferences</xsl:text>
            </fo:block>

            <fo:block margin-top="8pt">
                <fo:external-graphic content-width="45mm" src="{$muk-xsl.dir}/img/BalisageLogotype.png"/>
            </fo:block>
            <fo:block margin-top="8pt">
                <fo:external-graphic content-width="45mm" src="{$muk-xsl.dir}/img/xmlprague-top-logo-13.png"/>
            </fo:block>
            <fo:block margin-top="8pt">
                <fo:external-graphic content-width="35mm" src="{$muk-xsl.dir}/img/xmlss.svg"/>
            </fo:block>
            <fo:block margin-top="8pt">
                <fo:external-graphic content-width="35mm" content-height="10mm" src="{$muk-xsl.dir}/img/da-logo-with-outlines.svg"/>
            </fo:block>


            <fo:block
                xsl:use-attribute-sets="administrivia.title.properties">
                <fo:block>Markup UK 2025 Proceedings</fo:block>
            </fo:block>
            <fo:block font-size="10pt">
                <fo:block>by Rebecca Bamford, Francis Cave, Charafeddine Cheraa, John Cummins, Francis Denton, Tony Graham, Gerrit Imsieke, Michael H Kay, Martin Kraetke, Astrea Kumaradas, Deborah A Lapeyre, David Maus, Ari Nordström, Steven Pemberton, Liam Quin, Adam Retter, Andrew Sales, Erik Siegel, Amber Smiley, Sheila Thomson, Norman Tovery-Walsh, B. Tommie Usdin and Christine Windeln.</fo:block>
                <fo:block margin-top="1lh">The organisers of Markup UK would like to thank Antenna House for their expert and unstinting help in preparing and formatting the conference proceedings, and their generosity in providing licences to do so.</fo:block>
                <fo:block margin-top="1lh">Antenna House Formatter is based on the W3C Recommendations for XSL-FO and CSS and has long been recognized as the most powerful and proven standards based formatting software available. It is used worldwide in demanding applications where the need is to format HTML and XML into PDF and print. Today, Antenna House Formatter is used to produce millions of pages daily of technical, financial, user, and a wide variety of other documentation for thousands of customers in over 45 countries.</fo:block>
            </fo:block>
            
        </fo:flow>
    </xsl:template>



</xsl:stylesheet>
