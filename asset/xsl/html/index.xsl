<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" encoding="UTF-8" indent="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />

  <xsl:include href="templates.xsl"/>

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
        <title>Asymptote Gallery</title>
      </head>
      <body>
        <xsl:call-template name="menu"/>
        <div class="content">
          <h1>Etensive Asymptote Gallery</h1>
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
</xsl:stylesheet>
