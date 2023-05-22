<?xml version='1.0'?>
<xsl:stylesheet
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  exclude-result-prefixes="doc xlink"
  version='1.0'>


<!-- ********************************************************************

     Markup UK Proceedings.

     This file is not part of the XSL DocBook Stylesheet distribution.

     ******************************************************************** -->

<!-- http://www.sagehill.net/docbookxsl/PageBreaking.html#HardPageBreaks -->
<xsl:template match="processing-instruction('hard-pagebreak')">
  <fo:block break-after='page'/>
</xsl:template>

</xsl:stylesheet>
