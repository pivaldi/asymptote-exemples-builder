<?xml version="1.0" encoding="utf-8"?><xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"><xsl:output method="html" encoding="UTF-8" />
<xsl:include href="templates.xsl"/>
<xsl:template match="/asy-code">---
title: Figure Asymptote <xsl:value-of select="@topic" /> -- <xsl:value-of select="@number" />
date: <xsl:value-of select="@date" />
id: <xsl:value-of select="@id" />
lang: en
description: An Asymptote code and the generated picture <xsl:value-of select="@topic" />--<xsl:value-of select="@number" />.
sitemap: false
<xsl:for-each select="categories/category">
<xsl:if test="position() = 1"><xsl:text disable-output-escaing="yes">categories:
  - [Tech, Programming, Asymptote]</xsl:text></xsl:if>
<xsl:text disable-output-escaing="yes">
  - [Tech, Programming, Asymptote, </xsl:text><xsl:value-of select="." /><xsl:text> ]</xsl:text>
</xsl:for-each>
<xsl:text>
</xsl:text>
<xsl:for-each select="code/tags/tag">
<xsl:if test="position() = 1"><xsl:text disable-output-escaing="yes">tags:</xsl:text></xsl:if>
<xsl:text disable-output-escaing="yes">
  - asy-</xsl:text><xsl:value-of select="." />
</xsl:for-each>
<xsl:text>
toc:
  enable: false
---
</xsl:text>
<style>
  header.post-header h1 a.post-edit-link @-{-@
    display: none;
  @-}-@
</style>

## This picture comes from the <xsl:call-template name="makelink"><xsl:with-param name="text" select="concat('Asymptote gallery of topic ',@topic)" /><xsl:with-param name="url" select="concat('/asymptote/', @topic, '#', @topic, '-fig', @number)" /></xsl:call-template>
<xsl:text>
</xsl:text>
<xsl:apply-templates select="code" name="code">
  <xsl:with-param name="disable_subtitle" select="'true'" />
</xsl:apply-templates>
<xsl:call-template name="footer">
<xsl:with-param name="date" select="@date_current" />
</xsl:call-template>
</xsl:template>
<!-- more -->
</xsl:stylesheet>
