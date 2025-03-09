<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="label"/>
  <xsl:param name="id"/>

  <xsl:output method="html" encoding="UTF-8" indent="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />

  <xsl:template match="/asy-codes">
    <html>
      <head>
        <meta name="robots" content="noindex"/>
        <xsl:call-template name="head-base"/>
        <xsl:call-template name="head-js"/>
        <title><xsl:value-of select="$label"/> -- Asymptote Gallery</title>
      </head>
      <body>
        <xsl:call-template name="menu"/>
        <div class="content">
          <h1>Asymptote Gallery Tagged by <xsl:value-of select="$label"/> #<xsl:value-of select="$id"/></h1>
          <xsl:apply-templates select="asy-code/code[.//tag[@id=$id]]" name="code"/>
        </div>
        <xsl:call-template name="footer">
          <xsl:with-param name="date" select="@date" />
        </xsl:call-template>
      </body>
    </html>
  </xsl:template>

  <xsl:include href="templates.xsl"/>

</xsl:stylesheet>
