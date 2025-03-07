<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />

  <xsl:include href="templates.xsl"/>

  <xsl:template match="/asy-code">
    <html>
      <head>
        <link rel="shortcut icon" href="favicon.png" type="image/x-icon" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="keywords" content="asymptote,latex,graphique,graphic,scientifique,scientific,logiciel,software" />
        <meta name="description" content="asymptote latex graphique graphic scientifique scientific logiciel software" />
        <meta name="author" content="Philippe Ivaldi" />
        <meta name="generator" content="Emacs" />
        <link href="css/style-asy.css" rel="stylesheet" type="text/css" />
        <link href="css/style-pygmentize-zenburn.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="js/jquery.js"></script>
        <script type="text/javascript" src="js/jquery.fancybox/jquery.fancybox-1.2.1.pack.js"></script>
        <link rel="stylesheet" href="js/jquery.fancybox/jquery.fancybox.css" type="text/css" media="screen" />
        <script type="text/javascript" src="js/pi.js"></script>
        <title><xsl:value-of select="@title" /></title>
      </head>
      <body>
        <xsl:call-template name="menu"/>
        <center><div class="presentation"><xsl:apply-templates select="presentation" /></div></center>
        <xsl:call-template name="menu-img"/>
        <xsl:apply-templates select="code"/>
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
