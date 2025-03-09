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
    <a class="permalink" name="{@topic}-fig{@number}" id="{@topic}-fig{@number}" href="#{@topic}-fig{@number}"><span>🔗PERMALING🔗</span></a>
    <div class="code-contener">
      <table class="code-img">
        <caption align="bottom">
        </caption>
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="@is_anim='true'">
                <video id="{@topic}-video{@number}" muted="true" controls="true" alt="Asymptote figure {@topic} {@number}" poster="{@topic}/{@md5}.{@img_ext}" width="{@width}" height="{@height}" >
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
              Generated with <a href="http://asymptote.sourceforge.net/">Asymptote</a> <xsl:value-of select="@asy_version" />.
              <br/>
              <xsl:for-each select="../categories/category">
                <xsl:if test="position() = 1"><xsl:text disable-output-escaing="yes">Categories : </xsl:text></xsl:if>
                <xsl:call-template name="category-link">
                  <xsl:with-param name="label" select="." />
                  <xsl:with-param name="id" select="@id" />
                  </xsl:call-template><xsl:if test="position() != last()"><xsl:text disable-output-escaing="yes"> | </xsl:text></xsl:if>
              </xsl:for-each>
              <br/>
              <xsl:for-each select="tags/tag">
                <!-- <xsl:if test="position() = 1"><xsl:text disable-output-escaing="yes">Tags : </xsl:text></xsl:if> -->
                <xsl:call-template name="tag-link">
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
        <input type="button" class="hst" id="btn{@md5}" name="btn{@md5}" value="Hide Code" />
      </div>
      <div class="code asy">
      <pre id="prebtn{@md5}"><xsl:apply-templates select="pre"/></pre></div>
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
      <span><a href="https://github.com/pivaldi/asymptote-exemples/tree/master/{@topic}">Source Code</a></span>
      <span>☕ <a href="https://buymeacoffee.com/pivaldi">Buy Me a Coffee</a></span>
    </div>
  </xsl:template>

  <xsl:template name="footer">
    <xsl:param name="date" />
    <div class="footer">
      <p>
        Build with <a href="https://github.com/pivaldi/asymptote-exemples-builder">asymptote-exemples-builder</a> the <xsl:value-of select="$date" />
        <br/>©2011 <a href="https://www.piprime.fr">Philippe Ivaldi</a>
      </p>
    </div>
  </xsl:template>

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
    <a href="{concat('category-', $id, '.html')}" rel="nofollow"><xsl:value-of select="$label" /></a>
  </xsl:template>

  <xsl:template name="tag-link">
    <xsl:param name="id" />
    <xsl:param name="label" />
    <a href="{concat('tag-', $id, '.html')}" rel="nofollow">#<xsl:value-of select="$label" /></a>
  </xsl:template>
</xsl:stylesheet>
