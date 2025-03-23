<?xml version="1.0" encoding="utf-8"?><xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" />
<xsl:include href="templates.xsl"/>
<xsl:template match="/asy-codes">
<xsl:text>---
title: An Extensive Asymptote Gallery
date: 2018-04-30 22:49:15
lang: en
---
</xsl:text>
<style>header.post-header h1 a.post-edit-link @-{-@display: none;@-}-@</style>
<xsl:text>
Asymptote is a powerful descriptive vector graphics language that
provides a natural coordinate-based framework for technical
drawing. Labels and equations are typeset with LaTeX, for high-quality
PostScript output.

A major advantage of Asymptote over other graphics packages is that it
is a programming language, as opposed to just a graphics program.
Read more from the [Official Web Site of Asymptote](http://asymptote.sourceforge.net/).

## Extensive Asymptote Gallery

Here is an unofficial extensive gallery of examples.

### Browse by Topics

</xsl:text>
<xsl:for-each select="asy-code">
- <xsl:call-template name="makelink">
      <xsl:with-param name="text" select="@topic" />
      <xsl:with-param name="url" select="@topic" />
    </xsl:call-template>
</xsl:for-each>

<xsl:text>
### Browse by Categories

Because some topics can be in several categories.
</xsl:text>

<xsl:for-each select="all-categories/category">
- <xsl:call-template name="category-link">
<xsl:with-param name="label" select="." />
<xsl:with-param name="id" select="@id" />
</xsl:call-template>
</xsl:for-each>

<xsl:text>

### Browse by Tags

Browse with the finest granularity using the tags.

</xsl:text>
<xsl:for-each select="all-tags/tag">
- <xsl:call-template name="tag-link">
<xsl:with-param name="label" select="." />
<xsl:with-param name="id" select="@id" />
</xsl:call-template>
</xsl:for-each>

<xsl:call-template name="footer">
<xsl:with-param name="date" select="@date" />
</xsl:call-template>
</xsl:template>
</xsl:stylesheet>
