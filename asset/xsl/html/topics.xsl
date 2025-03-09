<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"
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
        <div class="presentation"><xsl:apply-templates select="presentation" /></div>
        <!-- <xsl:call-template name="menu-img"/> -->
        <xsl:apply-templates select="code" name="code"/>
        <div class="foot">
          <xsl:call-template name="menu"></xsl:call-template>
          <p class="last-modif">
            Dernière modification/Last modified: <xsl:value-of select="@date" />
            <br /><a href="https://www.piprime.fr">Philippe Ivaldi</a>
          </p>
        </div>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
