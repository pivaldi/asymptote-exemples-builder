<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />

  <xsl:include href="templates.xsl"/>

  <xsl:template match="/asy-code">
    <html>
      <head>
        <xsl:call-template name="head-base"/>
        <xsl:call-template name="head-js"/>
        <title><xsl:value-of select="@title" /></title>
      </head>
      <body>
        <xsl:call-template name="menu"/>
        <xsl:apply-templates select="presentation" />
        <!-- <xsl:call-template name="menu-img"/> -->
        <xsl:apply-templates select="code" name="code"/>
        <xsl:call-template name="footer">
          <xsl:with-param name="date" select="@date" />
        </xsl:call-template>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
