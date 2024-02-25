<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml" encoding="UTF-8" indent="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />
  <xsl:template match="/asy-code">
    <xsl:call-template name="bphp"/>
    global $_full_post;
    $dirname=get_bloginfo('url').'<xsl:value-of select="@dirname" />';
    <xsl:call-template name="ephp"/>
    <xsl:apply-templates select="code"/>
  </xsl:template>


  <!-- http://www.stylusstudio.com/xsllist/200010/post90750.html -->
  <xsl:template name="bphp">
    <xsl:text disable-output-escaping="yes">&lt;?php </xsl:text>
  </xsl:template>

  <xsl:template name="ephp">
    <xsl:text disable-output-escaping="yes"> ?&gt;</xsl:text>
  </xsl:template>

  <xsl:template name="lt">
    <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
  </xsl:template>
  <xsl:template name="gt">
    <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="code">
    <xsl:call-template name="bphp"/>if(!$_full_post):<xsl:call-template name="ephp"/>
    <div class="allcat">
      You may view <xsl:call-template name="lt"/><xsl:text>a href="</xsl:text><xsl:call-template name="bphp"/> echo get_category_link(<xsl:value-of select="@catnum" />).'&amp;posts_per_page=-1';<xsl:call-template name="ephp"/><xsl:text>" alt="Browse"</xsl:text><xsl:call-template name="gt"/>all the posts of the category <xsl:text>"</xsl:text><xsl:value-of select="@catname" />"<xsl:call-template name="lt"/>/a<xsl:call-template name="gt"/>
    </div>
    <xsl:call-template name="bphp"/>endif;<xsl:call-template name="ephp"/>
    <div class="code-contener">
      <table class="code-img">
        <caption align="bottom"></caption>
        <tr>
          <td>
            <xsl:choose>
              <xsl:when test="@animation='true'">
                <xsl:if test="@smallImg='true'">
                  <a id="fig{@id}"  target="_blank" href="###DIRNAME###{@filename}.gif"><img class="imgborder" src="###DIRNAME###{@filename}r.{@format_img}" alt="Figure {@number}" title="Click to animate" /></a>
                </xsl:if>
                <xsl:if test="@smallImg='false'">
                  <a id="fig{@id}"  target="_blank" href="###DIRNAME###{@filename}.gif"><img class="imgborder" src="###DIRNAME###{@filename}.{@format_img}" alt="Figure {@number}" title="Click to animate" /></a>
                </xsl:if>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="@smallImg='true'">
                  <a id="fig{@id}" target="_blank" href="###DIRNAME###{@filename}.{@format_img}"><img class="imgborder" src="###DIRNAME###{@filename}r.{@format_img}" alt="Figure {@number}" title="Click to enlarge" /></a>
                </xsl:if>
                <xsl:if test="@smallImg='false'">
                  <img class="imgborder" src="###DIRNAME###{@filename}.{@format_img}" alt="Figure {@number}" title="Click to enlarge" />
                </xsl:if>
                <br />
              </xsl:otherwise>
            </xsl:choose>
          </td>
          <td valign="top"><xsl:apply-templates select="text-html" /></td>
        </tr>
        <tr>
          <td align="center"><span class="legend">
            <!-- <xsl:text>Figure </xsl:text><xsl:value-of select="@number" /><xsl:text>: </xsl:text> -->
            <!-- <a href="###DIRNAME###{@filename}.asy"><xsl:value-of select="@filename" />.asy</a><br/> -->
            <xsl:text>(Compiled with </xsl:text><xsl:value-of select="@asyversion" /><xsl:text>)</xsl:text>
          </span>
        </td><td></td></tr>
      </table>
      <div>
        <xsl:choose>
	  <xsl:when test="@width != 'none' and @animation='true'">
            <a href="javascript:pop('###DIRNAME###{@filename}.swf.html','{@filename}-anim',{@width},{@height});">Movie flash (swf)</a><br/>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="link"/>
      </div>
      <div>
        <form class="inline" action="###DIRNAME###{@filename}.asy">
        <input type="button" class="hsa" name="hsa{@id}" value="Hide All Codes" />
        <input type="button" class="hst" id="btn{@id}" name="{@id}" value="Hide Code" />
        <input type="submit" class="abtn" value="Download" />
        </form>
      </div>
      <div class="code asy">
      <pre id="pre{@id}"><xsl:apply-templates select="pre"/></pre></div>
    </div>
    <xsl:if test="@smallImg='true'"><script type="text/javascript"><xsl:text>$(document).ready(function(){$("a#fig</xsl:text><xsl:value-of select="@id" /><xsl:text>").fancybox();});</xsl:text></script></xsl:if>
  </xsl:template>

  <xsl:template match="pre"><xsl:apply-templates /></xsl:template>

  <xsl:template match="span"><xsl:copy-of select="." /></xsl:template>

  <xsl:template match="a"><xsl:copy-of select="." /></xsl:template>

  <xsl:template match="text()|@*"><xsl:value-of select="." /></xsl:template>


  <xsl:template name="makelink">
    <xsl:param name="url" />
    <xsl:param name="text" />
    <a href="{$url}"><xsl:value-of select="$text" /></a>
  </xsl:template>

  <xsl:template match="text-html"><xsl:copy-of select="text()|*" /></xsl:template>

  <xsl:template match="view">
    <xsl:text> </xsl:text><span class="documentation">View the definition of</span><xsl:text> </xsl:text>
    <xsl:choose>
      <xsl:when test="@type = ''">
        <xsl:call-template name="makelink">
          <xsl:with-param name="text" select="@signature" />
          <xsl:with-param name="url" select="concat('###DIRNAME###',@file,'.php#',@signature)" />
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="makelink">
          <xsl:with-param name="text" select="concat(@type,' ',@signature)" />
          <xsl:with-param name="url" select="concat('###DIRNAME###',@file,'.php#',@signature)" />
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>


    <xsl:text> </xsl:text>
  </xsl:template>

</xsl:stylesheet>
