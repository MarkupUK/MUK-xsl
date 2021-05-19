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

<!-- ********************************************************************

     Markup UK Proceedings.

     This file is not part of the XSL DocBook Stylesheet distribution.

     ******************************************************************** -->

    <xsl:import href="docbook-xsl-1.79.1/fo/docbook.xsl"/>
    <xsl:import href="docbook-xsl-1.79.1/fo/highlight.xsl"/>
    <xsl:import href="muk-biblio.xsl"/>
    <xsl:import href="muk-formal.xsl"/>
    <xsl:import href="muk-headers-footers.xsl"/>
    <xsl:import href="muk-pagesetup.xsl"/>
    <xsl:import href="muk-toc.xsl"/>
    <xsl:import href="muk-highlight.xsl"/>
    <xsl:import href="muk-lists.xsl"/>
    <xsl:import href="muk-verbatim.xsl"/>
    <xsl:import href="muk-sponsors.xsl"/>
    <xsl:import href="muk-titlepages.xsl"/>

    <xsl:param name="muk-xsl.dir" />
    
    <xsl:param name="docbook-xsl.dir"
               select="'docbook-xsl-1.79.1'" />

    <xsl:param name="fo.processor" select="'ahf'"/>

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

    <!-- For consistent border-radius of backgrounds, etc. -->
    <xsl:param name="muk.border-radius" select="'3mm'" />

    <!-- Page Geometry -->
    <xsl:param name="paper.type" select="'A4'"/>
    <xsl:param name="page.margin.inner">25mm</xsl:param>
    <xsl:param name="page.margin.outer">25mm</xsl:param>
    <xsl:param name="page.margin.top">8mm</xsl:param>
    <xsl:param name="region.before.extent">20mm</xsl:param>
    <xsl:param name="body.margin.outer">4pc</xsl:param>
    <xsl:param name="body.margin.top">25mm</xsl:param>
    <xsl:param name="region.after.extent">11mm</xsl:param>
    <xsl:param name="page.margin.bottom">10mm</xsl:param>
    <xsl:param name="body.margin.bottom">15mm</xsl:param>
    <xsl:param name="double.sided">1</xsl:param>

    <!-- Header and footer column widths (left, centre, right) -->
    <xsl:param name="header.column.widths">5 0 2</xsl:param>
    <xsl:param name="footer.column.widths">5 1 1</xsl:param>

    <xsl:attribute-set name="root.properties">
      <xsl:attribute name="font-size">10pt</xsl:attribute>
      <xsl:attribute name="text-align">start</xsl:attribute>
    </xsl:attribute-set>

    <!-- TOC -->
    <xsl:param name="generate.toc" select="'book toc,title'"/>
    <xsl:param name="toc.section.depth" select="0"/>

    <xsl:attribute-set name="toc.line.properties">
      <xsl:attribute name="text-align-last">start</xsl:attribute>
      <xsl:attribute name="space-after">0.5lh</xsl:attribute>
      <xsl:attribute name="axf:hanging-punctuation">start allow-end</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="toc.margin.properties">
      <xsl:attribute name="space-before.optimum">10mm</xsl:attribute>
      <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
    </xsl:attribute-set>

    <!-- Author, in ToC and articles. -->
    <xsl:param name="author.font-size">12pt</xsl:param>

    <!-- Columns, title pages -->
    <xsl:param name="column.count.titlepage" select="1"/>
    <xsl:param name="column.count.body" select="1"/>
    <xsl:param name="column.gap.body" select="'24pt'"/>

    <!-- Body start indent (4pc default) -->
    <xsl:param name="body.start.indent" select="'0'"/>
    <xsl:param name="pgwide.start.indent" select="'0'"/>
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

    <xsl:param name="variablelist.as.blocks" select="1" />
    <xsl:attribute-set name="variablelist.term.properties">
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
    <xsl:param name="title.font.family">League Gothic, DejaVu Sans, sans-serif</xsl:param>
    <!-- Article titles are never centered. -->
    <xsl:attribute-set name="component.title.properties">
        <xsl:attribute name="text-align">
            <xsl:choose>
                <xsl:when test="((parent::articleinfo) and not(ancestor::book) and not(self::bibliography))
                    or (parent::slides | parent::slidesinfo)">center1</xsl:when>
                <xsl:otherwise>start</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- Section numbering -->
    <xsl:param name="section.autolabel" select="'1'"/>

    <xsl:attribute-set name="biblioentry.properties" use-attribute-sets="normal.para.spacing">
      <xsl:attribute name="start-indent">1.5em</xsl:attribute>
      <xsl:attribute name="text-indent">-1.5em</xsl:attribute>
    </xsl:attribute-set>


    <xsl:template name="bookmark.title.style">
      <xsl:param name="key" select="local-name()"/>

      <xsl:if test="$key = 'book'">
        <xsl:attribute name="color">
          <xsl:value-of select="$muk.blue" />
        </xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
      </xsl:if>
    </xsl:template>

    <!-- Show article subtitle, if it exists. -->
    <xsl:template match="subtitle" mode="titlepage.mode">
      <fo:block>
        <xsl:apply-templates />
      </fo:block>
    </xsl:template>

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
    <xsl:param name="body.font.family">Liberation Sans, DejaVu Sans, sans-serif</xsl:param>
    <xsl:param name="body.font.master" select="9"/>

    <!-- Programlisting Font -->
    <xsl:param name="monospace.font.family">Liberation Mono, DejaVu Sans Mono, monospace</xsl:param>


    <xsl:attribute-set name="footnote.properties">
      <xsl:attribute name="start-indent">
        <xsl:value-of select="$body.start.indent"/>
      </xsl:attribute>
    </xsl:attribute-set>


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
      <!--
      <xsl:attribute name="start-indent">0</xsl:attribute>
      <xsl:attribute name="start-indent">
        <xsl:choose>
          <xsl:when
              test="ancestor::table | ancestor::informaltable">0</xsl:when>
              <xsl:otherwise>4pc</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        -->
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
      <xsl:attribute name="start-indent"><xsl:value-of select="$pgwide.start.indent"/></xsl:attribute>
      <xsl:attribute name="padding-top">1lh - 3pt</xsl:attribute>
          <xsl:attribute name="padding-bottom">1lh - 3pt</xsl:attribute>
      <!-- Reduce the font size (but keep the line height) on
           <programlisting> that are still too wide. -->
      <xsl:attribute name="overflow">condense</xsl:attribute>
      <xsl:attribute name="axf:overflow-condense">font-size</xsl:attribute>
    </xsl:attribute-set>

    <xsl:param name="callout.unicode" select="1" />
<xsl:param name="callout.unicode.font">DejaVu Sans</xsl:param>
    <xsl:attribute-set name="callout.unicode.properties">
      <xsl:attribute name="color">
        <xsl:value-of select="$muk.red" />
      </xsl:attribute>
    </xsl:attribute-set>

    <xsl:param name="callout.graphics" select="0" />
    <xsl:param name="callout.graphics.path"
               select="concat($docbook-xsl.dir,
                              '/images/callouts/')" />

    <xsl:attribute-set name="article.appendix.title.properties">
      <xsl:attribute name="margin-left">0</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="bibliography.title.properties">
      <xsl:attribute name="margin-left">0</xsl:attribute>
    </xsl:attribute-set>

    <!-- Tables -->
    <xsl:attribute-set name="formal.title.properties">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$title.font.family"/>
        </xsl:attribute>
      <xsl:attribute name="font-weight">normal</xsl:attribute>
      <xsl:attribute name="text-align">start</xsl:attribute>
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

    <xsl:template match="tocentry|lotentry|tocdiv|tocfront|tocback">
        <fo:block end-indent="2pc"
            last-line-end-indent="-2pc">
            <xsl:if test="@linkend or @pagenum">
                <xsl:attribute name="text-align-last">justify</xsl:attribute>
            </xsl:if>
            <fo:inline keep-with-next.within-line="always">
                <xsl:choose>
                    <xsl:when test="@linkend">
                        <fo:basic-link internal-destination="{@linkend}">
                            <xsl:apply-templates/>
                        </fo:basic-link>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:inline>
            
            <xsl:choose>
                <xsl:when test="@linkend">
                    <fo:inline keep-together.within-line="always">
                        <fo:leader xsl:use-attribute-sets="toc.leader.properties"/>
                        <fo:basic-link internal-destination="{@linkend}">
                            <xsl:choose>
                                <xsl:when test="@pagenum">
                                    <xsl:value-of select="@pagenum"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <fo:page-number-citation ref-id="{@linkend}"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:basic-link>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@pagenum">
                    <fo:inline keep-together.within-line="always">
                        <fo:leader xsl:use-attribute-sets="toc.leader.properties"/>
                        <xsl:value-of select="@pagenum"/>
                    </fo:inline>
                </xsl:when>
            </xsl:choose>
        </fo:block>
    </xsl:template>

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
                <fo:basic-link internal-destination="{$id}" font-family="{$title.font.family}"
                    font-size="18pt" color="{$muk.blue}">
                    <xsl:if test="$label != ''">
                        <xsl:copy-of select="$label"/>
                        <xsl:value-of select="$autotoc.label.separator"/>
                    </xsl:if>
                    <xsl:apply-templates select="." mode="titleabbrev.markup"/>
                </fo:basic-link>
                <xsl:text>&#xA0;&#xA0;</xsl:text>
                <fo:basic-link internal-destination="{$id}">
                    <fo:page-number-citation ref-id="{$id}"/>
                </fo:basic-link>
                <fo:block />
                <fo:inline padding-start="2em" font-family="{$title.font.family}" font-size="{$author.font-size}">
                    <xsl:apply-templates select="(articleinfo/author|articleinfo/authorgroup/author)" mode="bibliography.mode"/>
                </fo:inline>
                <!-- fun ends here -->
            </fo:inline>
        </fo:block>
    </xsl:template>

    <xsl:template name="user.declarations">
      <fo:declarations>
        <!-- https://dejavu-fonts.github.io/ -->
        <axf:font-face
            src="url('{$muk-xsl.dir}/dejavu-fonts-ttf-2.37/ttf/DejaVuSans.ttf')"
            font-family="DejaVu Sans" />
        <axf:font-face
            src="url('{$muk-xsl.dir}/dejavu-fonts-ttf-2.37/ttf/DejaVuSans-Oblique.ttf')"
            font-family="DejaVu Sans"
            font-style="italic" />
        <axf:font-face
            src="url('{$muk-xsl.dir}/dejavu-fonts-ttf-2.37/ttf/DejaVuSans-Bold.ttf')"
            font-family="DejaVu Sans"
            font-weight="bold" />
        <axf:font-face
            src="url('{$muk-xsl.dir}/dejavu-fonts-ttf-2.37/ttf/DejaVuSans-BoldOblique.ttf')"
            font-family="DejaVu Sans"
            font-weight="bold"
            font-style="italic" />
        <!-- https://github.com/theleagueof/league-gothic/archive/master.zip -->
        <axf:font-face
            src="url('{$muk-xsl.dir}/league-gothic-master/LeagueGothic-Regular.otf')"
            font-family="League Gothic" />
        <!-- https://github.com/liberationfonts/liberation-fonts/releases -->
        <axf:font-face
            src="url('{$muk-xsl.dir}/liberation-fonts-ttf-2.00.5/LiberationSans-Regular.ttf')"
            font-family="Liberation Sans" />
        <axf:font-face
            src="url('{$muk-xsl.dir}/liberation-fonts-ttf-2.00.5/LiberationSans-Bold.ttf')"
            font-family="Liberation Sans"
            font-weight="bold" />
        <axf:font-face
            src="url('{$muk-xsl.dir}/liberation-fonts-ttf-2.00.5/LiberationSans-Italic.ttf')"
            font-family="Liberation Sans"
            font-style="italic" />
        <axf:font-face
            src="url('{$muk-xsl.dir}/liberation-fonts-ttf-2.00.5/LiberationSans-BoldItalic.ttf')"
            font-family="Liberation Sans"
            font-weight="bold"
            font-style="italic" />
        <axf:font-face
            src="url('{$muk-xsl.dir}/liberation-fonts-ttf-2.00.5/LiberationMono-Regular.ttf')"
            font-family="Liberation Mono" />
        <axf:font-face
            src="url('{$muk-xsl.dir}/liberation-fonts-ttf-2.00.5/LiberationMono-Bold.ttf')"
            font-family="Liberation Mono"
            font-weight="bold" />
        <axf:font-face
            src="url('{$muk-xsl.dir}/liberation-fonts-ttf-2.00.5/LiberationMono-Italic.ttf')"
            font-family="Liberation Mono"
            font-style="italic" />
        <axf:font-face
            src="url('{$muk-xsl.dir}/liberation-fonts-ttf-2.00.5/LiberationMono-BoldItalic.ttf')"
            font-family="Liberation Mono"
            font-weight="bold"
            font-style="italic" />
      </fo:declarations>
    </xsl:template>

    <xsl:template name="back.cover">
      <fo:page-sequence master-reference="back-cover">
        <fo:flow flow-name="xsl-region-body">
          <fo:block-container
              position="fixed" top="30mm" right="-{$muk.border-radius}" left="25mm"
              height="36mm">
            <fo:block
                line-stacking-strategy="line-height" line-height="18mm" padding-top="{$muk.border-radius}" padding-bottom="{$muk.border-radius}" text-depth="0"
                font-family="League Gothic, sans-serif"
                text-align="left" padding="10mm" color="rgb(59, 64, 99)"
                axf:border-radius="{$muk.border-radius}" font-weight="normal"
                font-size="11mm" background-color="rgb(233, 236, 239)">
              <fo:external-graphic
                  content-height="37mm" scaling="uniform"
                  content-width="scale-to-fit"
                  padding-left="-2.5mm"
                  src="url({$muk-xsl.dir}/img/MarkupUK-2.svg)"
                  axf:alttext="Markup UK"/>
        </fo:block>
          </fo:block-container>
        </fo:flow>
      </fo:page-sequence>
    </xsl:template>

    <xsl:template name="user-axf-page-master-properties">
        <xsl:param name="page.master" select="''"/>

        <xsl:choose>
            <xsl:when test="$page.master = 'titlepage-first'">
                <xsl:attribute name="background-image">
                  <xsl:value-of select="concat('url(', $muk-xsl.dir, '/img/background.jpg)')"/></xsl:attribute>
                <xsl:attribute name="axf:background-size">cover</xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="user-axf-document-information">
      <!-- The context node is the document element. -->
      <axf:document-info name="pagelayout">
        <xsl:attribute name="value">
          <xsl:choose>
            <!-- Articles start on a left-hand page. -->
            <xsl:when test="self::article">TwoPageLeft</xsl:when>
            <xsl:otherwise>TwoPageRight</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </axf:document-info>
    </xsl:template>

    <xsl:template name="muk-proceedings.title" mode="book.titlepage.recto.auto.mode">
      <fo:block-container position="fixed" top="30mm" left="-{$muk.border-radius}" right="25mm">
        <fo:block padding-top="19mm" padding-bottom="9mm" text-depth="0" line-stacking-strategy="font-height" line-height="1" font-family="{$title.font.family}" text-align="right" padding="10mm" color="{$muk.blue}" axf:border-radius="{$muk.border-radius}" font-weight="normal" font-size="11mm" background-color="{$muk.background}">
          <xsl:variable name="text" select="normalize-space(.)" />

          <xsl:choose>
            <xsl:when test="starts-with($text, 'Markup UK ')">
              <fo:external-graphic
                  content-height="24.4mm" scaling="uniform"
                  content-width="scale-to-fit"
                  src="url({$muk-xsl.dir}/img/MarkupUK-2.svg)"
                  axf:alttext="Markup UK " />
              <fo:block />
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
  <xsl:variable name="abstract.border.width" select="'6pt'" />
  <fo:block-container span="all" border="{$abstract.border.width} solid {$muk.background}" axf:border-radius="{$muk.border-radius}" padding="{$muk.border-radius}" padding-left="150pt - {$abstract.border.width}" xsl:use-attribute-sets="abstract.properties" margin-left="-150pt" margin-right="0">
      <fo:block start-indent="0" end-indent="0">
    <xsl:apply-templates select="*[not(self::title)]" mode="titlepage.mode"/>
      </fo:block>
  </fo:block-container>
</xsl:template>

<xsl:template name="bibliography.title">
  <xsl:param name="node" select="."/>
  <xsl:param name="pagewide" select="0"/>

  <xsl:variable name="id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$node"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="title">
    <xsl:apply-templates select="$node" mode="object.title.markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:variable name="titleabbrev">
    <xsl:apply-templates select="$node" mode="titleabbrev.markup"/>
  </xsl:variable>

  <xsl:variable name="level">
    <xsl:choose>
      <xsl:when test="ancestor::section">
        <xsl:value-of select="count(ancestor::section)+1"/>
      </xsl:when>
      <xsl:when test="ancestor::sect5">6</xsl:when>
      <xsl:when test="ancestor::sect4">5</xsl:when>
      <xsl:when test="ancestor::sect3">4</xsl:when>
      <xsl:when test="ancestor::sect2">3</xsl:when>
      <xsl:when test="ancestor::sect1">2</xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <fo:block xsl:use-attribute-sets="bibliography.title.properties
                                    component.title.properties">
    <xsl:if test="$pagewide != 0">
      <!-- Doesn't work to use 'all' here since not a child of fo:flow -->
      <xsl:attribute name="span">inherit</xsl:attribute>
    </xsl:if>
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
    <xsl:if test="$axf.extensions != 0 and 
                  $xsl1.1.bookmarks = 0 and 
                  $show.bookmarks != 0">
      <xsl:attribute name="axf:outline-level">
        <xsl:value-of select="count($node/ancestor::*)"/>
      </xsl:attribute>
      <xsl:attribute name="axf:outline-expand">false</xsl:attribute>
      <xsl:attribute name="axf:outline-title">
        <xsl:value-of select="normalize-space($title)"/>
      </xsl:attribute>
    </xsl:if>

    <!-- Let's handle the case where a component (bibliography, for example)
         occurs inside a section; will we need parameters for this?
         Danger Will Robinson: using section.title.level*.properties here
         runs the risk that someone will set something other than
         font-size there... -->
    <xsl:choose>
      <xsl:when test="$level=2">
        <fo:block xsl:use-attribute-sets="section.title.level2.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$level=3">
        <fo:block xsl:use-attribute-sets="section.title.level3.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$level=4">
        <fo:block xsl:use-attribute-sets="section.title.level4.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$level=5">
        <fo:block xsl:use-attribute-sets="section.title.level5.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:when test="$level=6">
        <fo:block xsl:use-attribute-sets="section.title.level6.properties">
          <xsl:copy-of select="$title"/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <!-- not in a section: do nothing special -->
        <xsl:copy-of select="$title"/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

</xsl:stylesheet>
