<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="pre">
    <pre><xsl:apply-templates /></pre>
  </xsl:template>

  <xsl:template name="menu-img">
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
                <video id="fig{@id}" muted="true" controls="true" poster="{@md5}.{@img_ext}">
                  <xsl:if test="@loop='true'">
                    <xsl:attribute name="loop">true</xsl:attribute>
                  </xsl:if>
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
          <td><span class="legend">
            <xsl:text>Figure </xsl:text><xsl:value-of select="@number" /><xsl:text>: </xsl:text>
            <a href="https://github.com/pivaldi/asymptote-exemples/blob/master/{@topic}/{@filename}.asy">
              Show <xsl:value-of select="@topic" />/<xsl:value-of select="@filename" />.asy on Github</a><xsl:text>.</xsl:text>
              <br/>
              <xsl:text>Generated with Asymptote </xsl:text><xsl:value-of select="@asy_version" /><xsl:text>.</xsl:text>
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
      <span><a href="../index.html">Home</a></span>
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


  <xsl:template name="topic-link">
    <xsl:param name = "topic" />
    <a href="./{$topic}/index.html">Topic <xsl:value-of select="$topic"/> --
    <xsl:for-each select="categories/category">
      <xsl:value-of select="." /><xsl:if test="position() != last()"><xsl:text disable-output-escaping="yes"> &#65286; </xsl:text></xsl:if>
    </xsl:for-each>
    </a>
  </xsl:template>

</xsl:stylesheet>
