<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />
  <xsl:template match="/asy-code">
    <html>
      <head>
        <link rel="shortcut icon" href="{@resource}favicon.png" type="image/x-icon" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="keywords" content="asymptote,latex,graphique,graphic,scientifique,scientific,logiciel,software" />
        <meta name="description" content="asymptote latex graphique graphic scientifique scientific logiciel software" />
        <meta name="author" content="Philippe Ivaldi" />
        <meta name="generator" content="Emacs" />
        <link href="{@resource}css/style-asy.css" rel="stylesheet" type="text/css" />
        <script type="text/javascript" src="{@resource}/piprim.js"></script>
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
            <br /><a href="http://sourceforge.net/users/pivaldi/">Philippe Ivaldi</a>
          </p>
          <!-- </div> -->
          <!-- </div> -->
          <p>
            <a href="http://validator.w3.org/check?uri=referer">Valide XHTML</a>
          </p>
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
                <img class="menu" src="{@filename}.{@format_img}" alt="Figure {@number}"/>
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
          <span class="legend">
            <xsl:text>Figure </xsl:text><xsl:value-of select="@number" /><xsl:text>: </xsl:text>
            <a href="{@filename}.asy"><xsl:value-of select="@filename" />.asy</a><br/>
            <xsl:text>(Compiled with </xsl:text><xsl:value-of select="@asyversion" /><xsl:text>)</xsl:text>
          </span>
        </caption>
        <tr><td>
            <a href ="{@filename}.gif.html"><img class="imgborder" src="{@filename}.{@format_img}" alt="Figure {@number}" /></a><br/>
        </td></tr>
      </table>
      <div>
        <xsl:choose>
	  <xsl:when test="@width = 'syracuse'">
            <a href="http://www.melusine.eu.org/syracuse/asymptote/animations/">Movie SWF</a> from the Syracuse web site.<br/>
          </xsl:when>
	  <xsl:when test="@width != 'none'">
            <a href="javascript:pop('{@filename}.swf.html','{@filename}-anim',{@width},{@height});">Movie SWF</a><br/>
          </xsl:when>
        </xsl:choose>
      </div>
      <div class="code">
        <xsl:apply-templates select="pre"/></div>
    </div>
  </xsl:template>

  <xsl:template match="pre">
    <pre><xsl:apply-templates /></pre>
  </xsl:template>

  <xsl:template match="span">
    <xsl:copy-of select="." />
  </xsl:template>

  <xsl:template match="a">
    <xsl:copy-of select="." />
  </xsl:template>

  <xsl:template match="text()|@*"><xsl:value-of select="." /></xsl:template>


  <xsl:template name="makelink">
    <xsl:param name="url" />
    <xsl:param name="text" />
    <a href="{$url}"><xsl:value-of select="$text" /></a>
  </xsl:template>

  <xsl:template name="menu">
    <div class="menuhf">
      <a href="../index.html">Monter/Up</a><xsl:text> </xsl:text>
      <a href="http://piprim.tuxfamily.org/index.html">Sommaire/Summary</a><xsl:text> </xsl:text>
      <a href="http://asymptote.sourceforge.net/">Asymptote</a><xsl:text> </xsl:text>
    </div>
  </xsl:template>

  <!-- Règle pour mes tags: -->

  <xsl:template match="presentation">
    <xsl:copy-of select="text()|*" />
  </xsl:template>

  <xsl:template match="view">
    <xsl:text> </xsl:text><span class="documentation">View the definition of</span><xsl:text> </xsl:text>
    <xsl:call-template name="makelink">
      <xsl:with-param name="text" select="concat(@type,' ',@signature)" />
      <xsl:with-param name="url" select="concat(@file,'#',@signature)" />
    </xsl:call-template>
    <xsl:text> </xsl:text>
  </xsl:template>


  <xsl:template match="html">
    <xsl:copy-of select="text()|*" />
  </xsl:template>


</xsl:stylesheet>
