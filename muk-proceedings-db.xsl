<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:exsl="http://exslt.org/common"
    xmlns:db="http://docbook.org/ns/docbook"
    xmlns:fox="http://xmlgraphics.apache.org/fop/extensions"
    xmlns:xi="http://www.w3.org/2001/XInclude"
    exclude-result-prefixes="db exsl fox xi xs"
    version="1.0">


    <xsl:import href="docbook-xsl-1.79.1/fo/docbook.xsl"/>
    <xsl:import href="docbook-xsl-1.79.1/fo/highlight.xsl"/>
    <xsl:import href="muk-headers-footers.xsl"/>
    <xsl:import href="muk-titlepages.xsl"/>
    <xsl:import href="muk-sponsors.xsl"/>
    <xsl:import href="muk-highlight.xsl"/>
    <xsl:import href="muk-lists.xsl"/>
    <xsl:import href="muk-verbatim.xsl"/>

    <xsl:param name="docbook-xsl.dir"
               select="'docbook-xsl-1.79.1'" />

    <xsl:param name="fo.processor" select="'fop'"/>

    <xsl:param name="axf.extensions">
        <xsl:choose>
            <xsl:when test="$fo.processor = 'ahf'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:param>

    <xsl:param name="fop1.extensions">
        <xsl:choose>
            <xsl:when test="$fo.processor = 'fop'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xsl:param name="fop.extensions">
        <xsl:choose>
            <xsl:when test="$fo.processor = 'fop'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
    </xsl:param>


    <!-- Markup UK colors -->
    <xsl:param name="muk.blue" select="'rgb(59, 64, 99)'" />
    <xsl:param name="muk.darkgrey" select="'rgb(33, 37, 41)'" />
    <xsl:param name="muk.grey" select="'rgb(125, 140, 163)'" />
    <xsl:param name="muk.red" select="'rgb(202, 77, 94)'" />
    <xsl:param name="muk.background" select="'rgb(233, 236, 239)'" />

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

    <xsl:attribute-set name="root.properties">
      <xsl:attribute name="font-size">10pt</xsl:attribute>
      <xsl:attribute name="text-align">start</xsl:attribute>
    </xsl:attribute-set>

    <!-- TOC -->
    <xsl:param name="generate.toc" select="'book toc,title'"/>
    <xsl:param name="toc.section.depth" select="0"/>

    <!-- Columns, title pages -->
    <xsl:param name="column.count.titlepage" select="1"/>
    <xsl:param name="column.count.body" select="1"/>
    <xsl:param name="column.gap.body" select="'24pt'"/>

    <!-- Body start indent (4pc default) -->
    <xsl:param name="body.start.indent" select="'4pc'"/>
    <xsl:param name="title.margin.left1" select="$body.start.indent" />
    <!-- Xref Handling -->
    <xsl:param name="insert.xref.page.number">1</xsl:param>
    <xsl:param name="xref.with.number.and.title">0</xsl:param>

    <!-- Hyphenate -->
    <xsl:param name="hyphenate" select="'false'"/>

    <!-- Lists -->
    <xsl:attribute-set name="itemizedlist.label.properties">
      <xsl:attribute name="color">
        <xsl:value-of select="$muk.red" />
      </xsl:attribute>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="orderedlist.label.properties">
      <xsl:attribute name="color">
        <xsl:value-of select="$muk.red" />
      </xsl:attribute>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <!-- Cover template for title page -->
    <!--<xsl:template match="cover" mode="titlepage.mode">
        <fo:block-container border-style="solid" border-width="0.5pt" margin-left="40mm" margin-right="40mm">
            <!-\-<xsl:apply-templates/>-\->
            <fo:block>
                <fo:external-graphic>
                    <xsl:attribute name="src">
                        <xsl:value-of select="db:mediaobject/db:imageobject/db:imagedata/@fileref"/>
                    </xsl:attribute>
                </fo:external-graphic>
            </fo:block>
        </fo:block-container>
    </xsl:template>-->


    <!-- Title Font Family -->
    <xsl:param name="title.font.family">League Gothic, sans-serif</xsl:param>

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
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="color">
          <xsl:value-of select="$muk.blue" />
        </xsl:attribute>
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="keep-with-next">
            <xsl:choose>
                <xsl:when test="parent::db:section[following-sibling::*[1][local-name(.)='section']]">auto</xsl:when>
                <xsl:otherwise>always</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="margin-left">
          <xsl:value-of select="$body.start.indent" />
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- Section Title Level Two Customization -->
    <xsl:attribute-set name="section.title.level2.properties">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$title.font.family"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="color">
          <xsl:value-of select="$muk.darkgrey" />
        </xsl:attribute>
        <xsl:attribute name="font-size">13pt</xsl:attribute>
        <!--<xsl:attribute name="keep-with-next.within-column">10</xsl:attribute>-->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <!--<xsl:attribute name="page-break-before">
            <xsl:call-template name="page-break-before"/>
        </xsl:attribute>-->
        <xsl:attribute name="keep-with-next">always</xsl:attribute>
        <xsl:attribute name="margin-left">
          <xsl:value-of select="$body.start.indent" />
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- Section Title Level Three Customization -->
    <xsl:attribute-set name="section.title.level3.properties">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$title.font.family"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <!--<xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>-->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="keep-with-next">always</xsl:attribute>
        <xsl:attribute name="margin-left">
          <xsl:value-of select="$body.start.indent" />
        </xsl:attribute>
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
        <xsl:attribute name="margin-left">
          <xsl:value-of select="$body.start.indent" />
        </xsl:attribute>
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
    <xsl:param name="body.font.family">Liberation Sans, sans-serif</xsl:param>
    <xsl:param name="body.font.master" select="9"/>

    <!-- Programlisting Font -->
    <xsl:param name="monospace.font.family">Liberation Mono, DejaVu Sans Mono, monospace</xsl:param>


    <!-- Tables -->
    <xsl:param name="default.table.column.widths" select="number(0)"/>


    <!-- Graphics -->
    <!--<xsl:param name="default.image.width" select="'160mm'"/>-->


    <!-- Program listing -->
    <xsl:param name="shade.verbatim" select="1" />

    <xsl:attribute-set name="shade.verbatim.style">
      <xsl:attribute name="background-color">
        <xsl:value-of select="$muk.background" />
      </xsl:attribute>
      <xsl:attribute name="axf:border-radius">3pt</xsl:attribute>
      <xsl:attribute name="padding">3pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="monospace.properties">
        <xsl:attribute name="color">
            <xsl:choose>
              <xsl:when test="self::code">
                <xsl:value-of
                    select="$muk.darkgrey"/>
              </xsl:when>
              <xsl:otherwise>inherit</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="monospace.verbatim.properties">
      <xsl:attribute name="start-indent">
        <xsl:choose>
          <xsl:when
              test="ancestor::table | ancestor::informaltable">0</xsl:when>
              <xsl:otherwise>4pc</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:choose>
              <xsl:when test="processing-instruction('db-font-size')">
                <xsl:value-of
                    select="processing-instruction('db-font-size')"/>
              </xsl:when>
              <xsl:otherwise>0.95em</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="line-height">inherit</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="pgwide.properties">
      <xsl:attribute name="start-indent">0</xsl:attribute>
      <xsl:attribute name="padding-top">1lh</xsl:attribute>
      <xsl:attribute name="padding-bottom">1lh</xsl:attribute>
    </xsl:attribute-set>

    <xsl:param name="callout.unicode" select="1" />
    <xsl:attribute-set name="callout.unicode.properties">
      <xsl:attribute name="color">
        <xsl:value-of select="$muk.red" />
      </xsl:attribute>
    </xsl:attribute-set>

    <xsl:param name="callout.graphics" select="0" />
    <xsl:param name="callout.graphics.path"
               select="concat($docbook-xsl.dir,
                              '/images/callouts/')" />

    <!-- Tables -->
    <xsl:attribute-set name="formal.title.properties">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$title.font.family"/>
        </xsl:attribute>
      <xsl:attribute name="font-weight">normal</xsl:attribute>
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

    <xsl:template name="user.declarations">
      <fo:declarations>
        <!-- https://github.com/theleagueof/league-gothic/archive/master.zip -->
        <axf:font-face
            src="url('league-gothic-master/LeagueGothic-Regular.otf')"
            font-family="League Gothic" />
        <!-- https://github.com/liberationfonts/liberation-fonts/releases -->
        <axf:font-face
            src="url('liberation-fonts-ttf-2.00.5/LiberationSans-Regular.ttf')"
            font-family="Liberation Sans" />
        <axf:font-face
            src="url('liberation-fonts-ttf-2.00.5/LiberationSans-Bold.ttf')"
            font-family="Liberation Sans"
            font-weight="bold" />
        <axf:font-face
            src="url('liberation-fonts-ttf-2.00.5/LiberationSans-Italic.ttf')"
            font-family="Liberation Sans"
            font-style="italic" />
        <axf:font-face
            src="url('liberation-fonts-ttf-2.00.5/LiberationSans-BoldItalic.ttf')"
            font-family="Liberation Sans"
            font-weight="bold"
            font-style="italic" />
        <axf:font-face
            src="url('liberation-fonts-ttf-2.00.5/LiberationMono-Regular.ttf')"
            font-family="Liberation Mono" />
        <axf:font-face
            src="url('liberation-fonts-ttf-2.00.5/LiberationMono-Bold.ttf')"
            font-family="Liberation Mono"
            font-weight="bold" />
        <axf:font-face
            src="url('liberation-fonts-ttf-2.00.5/LiberationMono-Italic.ttf')"
            font-family="Liberation Mono"
            font-style="italic" />
        <axf:font-face
            src="url('liberation-fonts-ttf-2.00.5/LiberationMono-BoldItalic.ttf')"
            font-family="Liberation Mono"
            font-weight="bold"
            font-style="italic" />
      </fo:declarations>
    </xsl:template>

    <xsl:template name="user-axf-page-master-properties">
        <xsl:param name="page.master" select="''"/>

        <xsl:choose>
            <xsl:when test="$page.master = 'titlepage-first'">
                <xsl:attribute name="background-image">url(img/background.jpg)</xsl:attribute>
                <xsl:attribute name="axf:background-size">cover</xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="muk-proceedings.title" mode="book.titlepage.recto.auto.mode">
      <fo:block-container position="fixed" top="30mm" left="-3mm" right="25mm">
        <fo:block padding-top="20mm" text-depth="0" line-stacking-strategy="font-height" line-height="1" font-family="{$title.font.family}" text-align="right" padding="10mm" color="{$muk.blue}" axf:border-radius="3mm" font-weight="normal" font-size="11mm" background-color="{$muk.background}">
          <xsl:variable name="text" select="normalize-space(.)" />

          <xsl:choose>
            <xsl:when test="starts-with($text, 'Markup UK ')">
              <fo:external-graphic
                  content-height="24mm" scaling="uniform"
                  content-width="scale-to-fit"
                  src="url(img/MarkupUK-2.svg)"
                  axf:alttext="Markup UK" />
              <fo:block axf:alttext=" " />
              <xsl:variable
                  name="rest"
                  select="substring-after($text, 'Markup UK ')" />
              <xsl:choose>
                <xsl:when
                    test="string-length($rest) >= 4 and
                          translate(substring($rest, 1, 4),
                                    '1234567890',
                                    '') = ''">
                  <fo:inline
                      color="{$muk.red}" text-depth="0">
                    <xsl:value-of
                        select="substring($rest, 1, 4)" />
                  </fo:inline>
                  <xsl:value-of
                      select="substring($rest, 5)" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$rest" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates />
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:block-container>
</xsl:template>

<xsl:template match="abstract" mode="titlepage.mode">
  <fo:block-container span="all" background-color="{$muk.background}" axf:border-radius="3mm" padding="3mm" xsl:use-attribute-sets="abstract.properties" margin-left="0" margin-right="0">
      <fo:block start-indent="0" end-indent="0">
    <xsl:apply-templates select="*[not(self::title)]" mode="titlepage.mode"/>
      </fo:block>
  </fo:block-container>
</xsl:template>

</xsl:stylesheet>
