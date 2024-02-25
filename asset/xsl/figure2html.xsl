<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="gencode" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />
  <xsl:template match="/asy-figures">
    <html>
      <head>
        <link rel="shortcut icon" href="{@resource}favicon.png" type="image/x-icon" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="author" content="Philippe Ivaldi" />
        <meta name="generator" content="Emacs" />
        <link href="{@resource}css/style-asy.css" rel="stylesheet" type="text/css" />
        <title><xsl:value-of select="@title" /></title>
      </head>
      <body>
        <xsl:call-template name="menu"/>
        <center><div class="presentation"><xsl:apply-templates select="presentation" /></div></center>
        <table class="full" cellpadding="10px">
          <xsl:apply-templates select="figure"/>
        </table>
        <div class="foot">
          <xsl:call-template name="menu"></xsl:call-template>
          <p class="last-modif">
            Dernière modification/Last modified: <xsl:value-of select="@date" />
            <br /><a href="http://sourceforge.net/users/pivaldi/">Philippe Ivaldi</a>
          </p>
          <p>
            <a href="http://validator.w3.org/check?uri=referer">Valide XHTML</a>
          </p>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="figure">
    <tr><td class="deco">
        <xsl:choose>
	  <xsl:when test="$gencode = 'true'">
            <a href="index.html#fig{@number}">
              <img src="{@filename}.{@format_img}" alt="Figure {@number}"/>
            </a>
          </xsl:when>
          <xsl:otherwise>
            <a href="{@filename}.pdf" type="application/pdf">
              <img src="{@filename}.{@format_img}" alt="Figure {@number}"/>
            </a>
          </xsl:otherwise>
        </xsl:choose>
        <br/>
        <span class="legend">
          <xsl:text>Figure </xsl:text><xsl:value-of select="@number" /><xsl:text>: </xsl:text>
          <a href="{@filename}.asy"><xsl:value-of select="@filename" />.asy</a>
        </span>
        <br/>
    </td></tr>
  </xsl:template>

  <xsl:template name="menu">
    <div class="menuhf">
      <a href="index.html">Code</a><xsl:text> </xsl:text>
      <a href="../index.html">Monter/Up</a><xsl:text> </xsl:text>
      <a href="http://piprim.tuxfamily.org/index.html">Sommaire/Summary</a><xsl:text> </xsl:text>
      <a href="http://asymptote.sourceforge.net/">Asymptote</a><xsl:text> </xsl:text>
    </div>
  </xsl:template>

  <!-- Règle pour mes tags: -->

  <xsl:template match="presentation">
    <xsl:copy-of select="text()|*" />
  </xsl:template>

</xsl:stylesheet>
