<?xml version="1.0" encoding="utf-8"?><xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:param name="label"/><xsl:param name="id"/><xsl:output method="html" encoding="UTF-8" />
<xsl:template match="/asy-codes">
<xsl:text>---
noindex: true
sitemap: false
canonical: false
title: Category </xsl:text><xsl:value-of select="$label"/><xsl:text> -- Asymptote Gallery
date: 2011-04-30 22:49:15
lang: en
---
</xsl:text>
<style>header.post-header h1 a.post-edit-link @-{-@display: none;@-}-@</style>
<xsl:text>
## Asymptote Gallery for Category “</xsl:text><xsl:value-of select="$label"/><xsl:text>” #</xsl:text><xsl:value-of select="$id"/>
<xsl:apply-templates select="asy-code[.//category[@id=$id]]/code" name="code"/>

<xsl:call-template name="footer">
  <xsl:with-param name="date" select="@date_current" />
</xsl:call-template>
</xsl:template>
<xsl:include href="templates.xsl"/>
</xsl:stylesheet>
