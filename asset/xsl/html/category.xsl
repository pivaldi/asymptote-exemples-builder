<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:param name="label"/>
  <xsl:param name="id"/>

  <xsl:output method="html" encoding="UTF-8" indent="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />

  <xsl:template match="/">
    <html>
      <head>
        <xsl:call-template name="head-base"/>
        <xsl:call-template name="head-js"/>
        <title><xsl:value-of select="$label"/> -- Asymptote Gallery</title>
      </head>
      <body>
        <xsl:call-template name="menu"/>
        <div class="content">
          <h1>Asymptote Gallery by Category</h1>
          <h2>Category <xsl:value-of select="$id"/>-<xsl:value-of select="$label"/></h2>
          <!-- <xsl:apply-templates select="/asy-codes/asy-code[.//category[@id=$id]]" name="menu-img"/> -->
          <xsl:apply-templates select="/asy-codes/asy-code[.//category[@id=$id]]/code" name="code"/>
        </div>
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

  <xsl:include href="templates.xsl"/>

</xsl:stylesheet>
