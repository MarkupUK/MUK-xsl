<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>

<!-- ********************************************************************
     $Id: lists.xsl 9999 2015-10-15 17:55:56Z bobstayton $
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->
<xsl:template name="next.itemsymbol">
  <xsl:param name="itemsymbol" select="'default'"/>
  <xsl:choose>
    <!-- Change this list if you want to change the order of symbols -->
    <xsl:when test="$itemsymbol = 'whitediamond'">blackdiamond</xsl:when>
    <xsl:when test="$itemsymbol = 'blackdiamond'">whitediamondcontainingblack</xsl:when>
    <xsl:when test="$itemsymbol = 'whitediamondcontainingblack'">whitediamond</xsl:when>
    <xsl:otherwise>whitediamond</xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="itemizedlist.label.markup">
  <xsl:param name="itemsymbol" select="'disc'"/>

  <xsl:choose>
    <xsl:when test="@override">
      <xsl:value-of select="@override" />
    </xsl:when>
    <xsl:when test="$itemsymbol='none'"></xsl:when>
    <xsl:when test="$itemsymbol='disc'">&#x2022;</xsl:when>
    <xsl:when test="$itemsymbol='bullet'">&#x2022;</xsl:when>
    <xsl:when test="$itemsymbol='endash'">&#x2013;</xsl:when>
    <xsl:when test="$itemsymbol='emdash'">&#x2014;</xsl:when>
    <xsl:when test="$itemsymbol='blackdiamond'">&#x25C6;</xsl:when>
    <xsl:when test="$itemsymbol='whitediamond'">&#x25C7;</xsl:when>
    <xsl:when test="$itemsymbol='whitediamondcontainingblack'">&#x25C8;</xsl:when>
    <!-- Some of these may work in your XSL-FO processor and fonts -->
    <!--
    <xsl:when test="$itemsymbol='square'">&#x25A0;</xsl:when>
    <xsl:when test="$itemsymbol='box'">&#x25A0;</xsl:when>
    <xsl:when test="$itemsymbol='smallblacksquare'">&#x25AA;</xsl:when>
    <xsl:when test="$itemsymbol='circle'">&#x25CB;</xsl:when>
    <xsl:when test="$itemsymbol='opencircle'">&#x25CB;</xsl:when>
    <xsl:when test="$itemsymbol='whitesquare'">&#x25A1;</xsl:when>
    <xsl:when test="$itemsymbol='smallwhitesquare'">&#x25AB;</xsl:when>
    <xsl:when test="$itemsymbol='round'">&#x25CF;</xsl:when>
    <xsl:when test="$itemsymbol='blackcircle'">&#x25CF;</xsl:when>
    <xsl:when test="$itemsymbol='whitebullet'">&#x25E6;</xsl:when>
    <xsl:when test="$itemsymbol='triangle'">&#x2023;</xsl:when>
    <xsl:when test="$itemsymbol='point'">&#x203A;</xsl:when>
    <xsl:when test="$itemsymbol='hand'"><fo:inline 
                         font-family="Wingdings 2">A</fo:inline></xsl:when>
    -->
    <xsl:otherwise>&#x2022;</xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
