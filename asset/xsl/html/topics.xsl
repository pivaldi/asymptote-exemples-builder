<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />

  <xsl:include href="templates.xsl"/>

  <xsl:template match="/asy-code">
    <html>
      <head>
        <link rel="shortcut icon" href="../favicon.png" type="image/x-icon" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="keywords" content="asymptote,latex,graphique,graphic,scientifique,scientific,logiciel,software" />
        <meta name="description" content="asymptote latex graphique graphic scientifique scientific logiciel software" />
        <meta name="author" content="Philippe Ivaldi" />
        <meta name="generator" content="Emacs" />
        <link href="../css/style-asy.css" rel="stylesheet" type="text/css" />
        <link href="../css/style-pygmentize-zenburn.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="../js/pi.js"></script>
        <script type="text/javascript" src="../js/jquery.js"></script>
        <script type="text/javascript" src="../js/jquery.fancybox/jquery.fancybox-1.2.1.pack.js"></script>
        <script type="text/javascript">
          $(document).ready(function(){
          // $("pre").slideUp();
          $("input.hsa").click(function () {
          if ($("pre:first").is(":hidden")) {
          $("pre").show("slow");
          $("input.hsa").attr({value:"Hide All Codes"});
          $("input.hst").attr({value:"Hide Code"});
          } else {
          $("pre").slideUp();
          $("input.hsa").attr({value:"Show All Codes"});
          $("input.hst").attr({value:"Show Code"});
          }
          });
          $("input.hst").click(function () {
          var tid=$(this).attr("name");
          if ($("pre#pre"+tid).is(":hidden")) {
          $("pre#pre"+tid).show("slow");
          $("input#btn"+tid).attr({value:"Hide Code"});
          } else {
          $("pre#pre"+tid).slideUp();
          $("input#btn"+tid).attr({value:"Show Code"});
          }
          });
          });
        </script>
        <link rel="stylesheet" href="../js/jquery.fancybox/jquery.fancybox.css" type="text/css" media="screen" />
        <title><xsl:value-of select="@title" /></title>
      </head>
      <body>
        <xsl:call-template name="menu"/>
        <center><div class="presentation"><xsl:apply-templates select="presentation" /></div></center>
        <xsl:call-template name="menu-img"/>
        <!-- <div class="content"> -->
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
