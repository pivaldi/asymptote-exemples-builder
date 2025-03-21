<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="pre">
    <pre><xsl:apply-templates /></pre>
  </xsl:template>

<xsl:template match="code" name="code">
## <xsl:value-of select="@topic"/>-fig<xsl:value-of select="@number"/>
<xsl:text>
</xsl:text>
<xsl:text>
</xsl:text>
<xsl:choose>
<xsl:when test="@is_anim='true'">
<video id="{@topic}-video{@number}" muted="true" controls="true" alt="Asymptote figure {@topic} {@number}" poster="{@md5}.{@img_ext}" width="{@width}" height="{@height}" >
<xsl:if test="@loop='true'">
<xsl:attribute name="loop">true</xsl:attribute>
</xsl:if>

<source src="{@md5}.mp4" type="video/mp4" />
Your browser does not support HTML5 video…
<a src="{@md5}.gif">See the video as animated gif</a>.
</video>
<xsl:text>
</xsl:text>
</xsl:when>
<xsl:otherwise>
<img class="imgborder" src="{@md5}.{@img_ext}" alt="Figure {@topic} {@number} Generated with Asymptote" loading="lazy" width="{@width}" height="{@height}" />
</xsl:otherwise>
</xsl:choose>
<xsl:apply-templates select="text-html" />
<xsl:text>

</xsl:text>
<a href="https://github.com/pivaldi/asymptote-exemples/blob/master/{@topic}/{@filename}.asy">
Show <xsl:value-of select="@topic" />/<xsl:value-of select="@filename" />.asy on Github</a><xsl:text>.</xsl:text>  <xsl:text>
</xsl:text>
Generated with <a href="http://asymptote.sourceforge.net/">Asymptote</a> <xsl:value-of select="@asy_version" />.  <xsl:text>
</xsl:text>
<xsl:for-each select="../categories/category">
<xsl:if test="position() = 1"><xsl:text disable-output-escaing="yes">Categories : </xsl:text></xsl:if>
<xsl:call-template name="category-link">
<xsl:with-param name="label" select="." />
<xsl:with-param name="id" select="@id" />
</xsl:call-template><xsl:if test="position() != last()"><xsl:text disable-output-escaing="yes"> | </xsl:text></xsl:if>
</xsl:for-each><xsl:text>  </xsl:text>
<xsl:text>
</xsl:text>
<xsl:for-each select="tags/tag">
<xsl:if test="position() = 1"><xsl:text disable-output-escaing="yes">Tags : </xsl:text></xsl:if>
<xsl:call-template name="tag-link">
<xsl:with-param name="label" select="." />
<xsl:with-param name="id" select="@id" />
</xsl:call-template><xsl:if test="position() != last()"><xsl:text disable-output-escaing="yes"> | </xsl:text></xsl:if>
</xsl:for-each>
<xsl:text>

</xsl:text>
<pre id="prebtn{@md5}" class="asymptote"><xsl:apply-templates select="pre"/></pre>
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

<xsl:template name="footer">
<xsl:param name="date" />
<div class="footer">
<p>
Build with <a href="https://github.com/pivaldi/asymptote-exemples-builder">asymptote-exemples-builder</a> the <xsl:value-of select="$date" /><br/>
©2011 <a href="https://www.piprime.fr">Philippe Ivaldi</a>
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
