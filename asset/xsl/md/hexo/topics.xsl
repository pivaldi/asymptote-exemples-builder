<?xml version="1.0" encoding="utf-8"?><xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"><xsl:output method="html" encoding="UTF-8" />
<xsl:include href="templates.xsl"/>
<xsl:template match="/asy-code">---
title: <xsl:value-of select="@title" />
date: <xsl:value-of select="@date" />
lang: en
description: An Asymptote tutorial by examples -- <xsl:value-of select="@topic" />
---
<style>
  header.post-header h1 a.post-edit-link @-{-@
    display: none;
  @-}-@
</style>

<xsl:apply-templates select="presentation" />
<xsl:text>
</xsl:text>
<xsl:apply-templates select="code" name="code"/>
<xsl:call-template name="footer">
<xsl:with-param name="date" select="@date_current" />
</xsl:call-template>
</xsl:template>
</xsl:stylesheet>
