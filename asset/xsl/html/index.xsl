<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />

  <xsl:include href="templates.xsl"/>

  <xsl:template match="/asy-codes">
    <html>
      <head>
        <xsl:call-template name="head-base"/>
        <title>Asymptote Gallery</title>
      </head>
      <body>
        <xsl:call-template name="menu"/>
        <div class="content">
          <h1>Etensive Asymptote Gallery</h1>
          <p>Asymptote is a descriptive vector graphics language that provides a natural coordinate-based framework for technical drawing.</p>
          <p>Here is an unofficial extensive gallery of examples.</p>
          <h2>Browse by Topic</h2>
          <ul>
            <xsl:for-each select="asy-code">
              <li>
                <xsl:call-template name="makelink">
                  <xsl:with-param name="text" select="@topic" />
                  <xsl:with-param name="url" select="concat(@topic, '.html')" />
                </xsl:call-template>
              </li>
            </xsl:for-each>
          </ul>
          <h2>Browse by Category</h2>
          Because some topic can be in several categories.
          <ul>
            <xsl:for-each select="all-categories/category">
              <li>
                <xsl:call-template name="category-link">
                  <xsl:with-param name="label" select="." />
                  <xsl:with-param name="id" select="@id" />
                </xsl:call-template>
              </li>
            </xsl:for-each>
          </ul>
          <h2>Browse by Tag</h2>
          <p>Browse with the finest granularity using the tags.</p>
          <ul>
            <xsl:for-each select="all-tags/tag">
              <li>
                <xsl:call-template name="tag-link">
                  <xsl:with-param name="label" select="." />
                  <xsl:with-param name="id" select="@id" />
                </xsl:call-template>
              </li>
            </xsl:for-each>
          </ul>
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
</xsl:stylesheet>
