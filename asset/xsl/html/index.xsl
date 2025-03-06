<?xml version="1.0" ?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" indent="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />
  <xsl:template match="/asy-codes">
    <html>
      <head>
        <link rel="shortcut icon" href="./favicon.png" type="image/x-icon" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="keywords" content="asymptote,latex,graphique,graphic,scientifique,scientific,logiciel,software" />
        <meta name="description" content="asymptote latex graphique graphic scientifique scientific logiciel software" />
        <meta name="author" content="Philippe Ivaldi" />
        <meta name="generator" content="Emacs" />
        <link href="./css/style-asy.css" rel="stylesheet" type="text/css" />
        <link href="./css/style-pygmentize-zenburn.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="./js/pi.js"></script>
        <script type="text/javascript" src="./js/jquery.js"></script>
        <script type="text/javascript" src="./js/jquery.fancybox/jquery.fancybox-1.2.1.pack.js"></script>
        <link rel="stylesheet" href="./js/jquery.fancybox/jquery.fancybox.css" type="text/css" media="screen" />
        <title>Unofficial Asymptote Gallery</title>
      </head>
      <body>
        <xsl:call-template name="menu"/>
        <div class="content">
          <h1>Unofficial Asymptote Gallery</h1>
          <h2>The Vector Graphics Language</h2>
          <p>Asymptote is a descriptive vector graphics language that provides a natural coordinate-based framework for technical drawing.</p>
          <p>Here is an unofficial extensive gallery of examples.</p>
          <ul>
            <xsl:for-each select="asy-code">
              <li>
                <!-- <xsl:apply-templates select="categories" /> -->
                <xsl:call-template name="topic-link">
                  <xsl:with-param name="topic" select = "@topic" />
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

  <xsl:template match="pre">
    <pre><xsl:apply-templates /></pre>
  </xsl:template>

  <xsl:template name="menu">
    <div class="menuhf">
      <span><a href="https://blog.piprime.fr/asynptote/">Modern Version on piprime.fr</a></span>
      <span><a href="https://github.com/pivaldi/asymptote-exemples/">View Source Code</a></span>
      <span><a href="http://asymptote.sourceforge.net/">Official Asymptote WEB Site</a></span>
    </div>
  </xsl:template>

  <xsl:template name="topic-link">
    <xsl:param name = "topic" />
    <a href="./{$topic}/index.html">Topic <xsl:value-of select="$topic"/> --
    <xsl:for-each select="categories/category">
      <xsl:value-of select="." /><xsl:if test="position() != last()"><xsl:text disable-output-escaping="yes"> &#65286; </xsl:text></xsl:if>
    </xsl:for-each>
    </a>
  </xsl:template>

  <xsl:template match="html">
    <xsl:copy-of select="text()|*" />
  </xsl:template>
</xsl:stylesheet>
