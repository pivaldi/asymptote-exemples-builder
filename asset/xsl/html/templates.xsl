<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template name="head-base">
    <link rel="shortcut icon" href="./favicon.png" type="image/x-icon" />
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="keywords"
        content="asymptote,latex,graphique,graphic,scientifique,scientific,logiciel,software"/>
    <meta name="description" content="Examples of asymptote graphics codes and pictures" />
    <meta name="author" content="Philippe Ivaldi" />
    <link href="css/style-asy.css" rel="stylesheet" type="text/css" />
    <link href="css/style-pygmentize-zenburn.css" rel="stylesheet" type="text/css"/>
  </xsl:template>

  <xsl:template name="head-js">
    <script type="text/javascript" src="js/jquery.js"></script>
    <script type="text/javascript" src="js/jquery.fancybox/jquery.fancybox-1.2.1.pack.js"></script>
    <link rel="stylesheet" href="js/jquery.fancybox/jquery.fancybox.css" type="text/css" media="screen"/>
    <script type="text/javascript" src="js/pi.js"></script>
  </xsl:template>


  <xsl:template match="pre">
    <pre><xsl:apply-templates /></pre>
  </xsl:template>

  <xsl:template match="asy-code" name="menu-img">
    <div class="fixedr">
      <div class="dynamic">
        <a href="figure-index.html">List of pictures</a>
        <div class="overflow">
          <xsl:for-each select="code">
            <a href="#fig{@number}">
              <img class="menu" loading="lazy" src="{@topic}/{@md5}.{@img_ext}" alt="Figure {@number}" width="{@width}" height="{@height}"/>
              </a><br/>figure <xsl:value-of select="@number"/><br/>
          </xsl:for-each>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="code" name="code">
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
                <video id="fig{@id}" muted="true" controls="true" alt="Asymptote figure {@topic} {@number}" poster="{@topic}/{@md5}.{@img_ext}" width="{@width}" height="{@height}" >
                  <xsl:if test="@loop='true'">
                    <xsl:attribute name="loop">true</xsl:attribute>
                  </xsl:if>
                  <source src="{@topic}/{@md5}.mp4" type="video/mp4" />
                  Your browser does not support HTML5 video…
                  <a src="{@topic}/{@md5}.gif">See the video as animated gif</a>.
                </video>
              </xsl:when>
              <xsl:otherwise>
                <img class="imgborder" src="{@topic}/{@md5}.{@img_ext}" alt="Asymptote figure {@topic} {@number}" loading="lazy" width="{@width}" height="{@height}" />
                <br />
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td valign="top"><xsl:apply-templates select="text-html" /></td>
        </tr>
        <tr>
          <td><div class="legend">
            <xsl:text>Figure </xsl:text><xsl:value-of select="@number" /><xsl:text>: </xsl:text>
            <a href="https://github.com/pivaldi/asymptote-exemples/blob/master/{@topic}/{@filename}.asy">
              Show <xsl:value-of select="@topic" />/<xsl:value-of select="@filename" />.asy on Github</a><xsl:text>.</xsl:text>
              <br/>
              <xsl:text>Generated with Asymptote </xsl:text><xsl:value-of select="@asy_version" /><xsl:text>.</xsl:text>
              <br/>
              <xsl:for-each select="../categories/category">
                <xsl:if test="position() = 1"><xsl:text disable-output-escaing="yes">Categories : </xsl:text></xsl:if>
                <xsl:call-template name="category-link">
                  <xsl:with-param name="label" select="." />
                  <xsl:with-param name="id" select="@id" />
                  </xsl:call-template><xsl:if test="position() != last()"><xsl:text disable-output-escaing="yes"> | </xsl:text></xsl:if>
              </xsl:for-each>
            </div>
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
      <span><a href="index.html">Home</a></span>
      <span><a href="https://github.com/pivaldi/asymptote-exemples/tree/master/{@topic}">View Source Code</a></span>
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

  <xsl:template match="html">
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

  <xsl:template name="category-link">
    <xsl:param name="id" />
    <xsl:param name="label" />
    <xsl:call-template name="makelink">
      <xsl:with-param name="text" select="$label" />
      <xsl:with-param name="url" select="concat('category-', $id, '.html')" />
    </xsl:call-template>
  </xsl:template>
</xsl:stylesheet>
