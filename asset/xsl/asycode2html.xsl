<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />
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
          <!-- </div> -->
          <!-- </div> -->
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="pre">
    <pre><xsl:apply-templates /></pre>
  </xsl:template>

  <xsl:template name="menu-img">
    <!-- <xsl:variable name="codenumber" select="/asy-code/code" /> -->
    <!-- <xsl:if test="count($codenumber)>10"> -->
    <div class="fixedr">
      <div class="dynamic">
        <a href="figure-index.html">List of pictures</a>
        <div class="overflow">
          <xsl:for-each select="/asy-code/code">
            <a href="#fig{@number}">
              <img class="menu" src="{@md5}.{@img_ext}" alt="Figure {@number}"/>
              </a><br/>figure <xsl:value-of select="@number"/><br/>
          </xsl:for-each>
        </div>
      </div>
    </div>
    <!-- </xsl:if> -->
  </xsl:template>



  <xsl:template match="code">
    <h5 class="hidden"><a class="hidden" name="fig{@number}"></a>phantom</h5>
    <table class="hsep"><tr><td></td></tr></table>
    <div class="code-contener">
      <table class="code-img">
        <caption align="bottom">
        </caption>
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="@is_anim='true'">
                <video id="fig{@id}" loop="true" muted="true" controls="true">
                  <source src="{@md5}.mp4" type="video/mp4" />
                  Your browser does not support HTML5 video…
                  <a src="{@md5}.gif">See the video as animated gif</a>.
                </video>
              </xsl:when>
              <xsl:otherwise>
                <img class="imgborder" src="{@md5}.{@img_ext}" alt="Figure {@topic} {@number}"/>
                <br />
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td valign="top"><xsl:apply-templates select="text-html" /></td>
        </tr>
        <tr>
          <td align="center"><span class="legend">
            <xsl:text>Figure </xsl:text><xsl:value-of select="@number" /><xsl:text>: </xsl:text>
            <a href="https://github.com/pivaldi/asymptote-exemples/blob/master/{@topic}/{@filename}.asy">
              Show <xsl:value-of select="@topic" />/<xsl:value-of select="@filename" />.asy on Github</a><xsl:text>.</xsl:text>
              <br/>
              <xsl:text>(Compiled with Asymptote </xsl:text><xsl:value-of select="@asy_version" /><xsl:text>)</xsl:text>
            </span>
        </td><td></td></tr>
      </table>
      <div>
        <xsl:apply-templates select="link"/>
      </div>
      <div>
        <input type="button" class="hsa" name="hsa{@id}" value="Hide All Codes" />
        <input type="button" class="hst" id="btn{@id}" name="{@id}" value="Hide Code" />
      </div>
      <div class="code asy">
      <pre id="pre{@id}"><xsl:apply-templates select="pre"/></pre></div>
    </div>
  </xsl:template>

  <xsl:template match="pre"><xsl:apply-templates /></xsl:template>

  <xsl:template match="link"><xsl:copy-of select="text()|*" /></xsl:template>

  <xsl:template match="span"><xsl:copy-of select="." /></xsl:template>

  <xsl:template match="a"><xsl:copy-of select="." /></xsl:template>

  <xsl:template match="text()|@*"><xsl:value-of select="." /></xsl:template>


  <xsl:template name="makelink">
    <xsl:param name="url" />
    <xsl:param name="text" />
    <a href="{$url}"><xsl:value-of select="$text" /></a>
  </xsl:template>

  <xsl:template name="menu">
    <div class="menuhf">
      <span><a href="../index.html">Up</a></span>
      <span><a href="http://www.piprime.fr">Home</a></span>
      <span><a href="http://asymptote.sourceforge.net/">Official Asymptote WEB Site</a></span>
    </div>
  </xsl:template>

  <!-- Règle pour mes tags: -->

  <xsl:template match="presentation">
    <xsl:copy-of select="text()|*" />
  </xsl:template>

  <xsl:template match="text-html">
    <xsl:copy-of select="text()|*" />
  </xsl:template>

  <xsl:template match="view">
    <xsl:text> </xsl:text><span class="documentation">View the definition of</span><xsl:text> </xsl:text>
    <xsl:call-template name="makelink">
      <xsl:with-param name="text" select="concat(@type,' ',@signature)" />
      <xsl:with-param name="url" select="concat(@file,'.html#',@signature)" />
    </xsl:call-template>
    <xsl:text> </xsl:text>
  </xsl:template>


  <xsl:template match="html">
    <xsl:copy-of select="text()|*" />
  </xsl:template>
</xsl:stylesheet>
