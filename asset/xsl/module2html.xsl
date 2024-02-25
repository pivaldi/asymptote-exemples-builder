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
        <link href="{@resource}style-module-asy.css" rel="stylesheet" type="text/css" />
        <title><xsl:value-of select="@title" /></title>
      </head>
      <body>
        <xsl:call-template name="menu"/>
        <xsl:apply-templates />
        <div class="foot">
          <xsl:call-template name="menu"></xsl:call-template>
          <p class="last-modif">
            Dernière modification/Last modified: <xsl:value-of select="@date" />
            <br /><a href="http://sourceforge.net/users/pivaldi/">Philippe Ivaldi</a>
          </p>
          <p>
            <a href="http://validator.w3.org/check?uri=referer">Valide XHTML</a>
          </p>
        </div>
      </body>
    </html>
  </xsl:template>

  <!-- ajoute en attribut le nom du fichier à chacune des balises ouvertes -->
  <!--   <xsl:template match="/asy-code/*|/"> -->
  <!--     <xsl:copy> -->
  <!--       <xsl:attribute name="filename"><xsl:value-of select="/asy-code@filename" /></xsl:attribute> -->
  <!--       <xsl:apply-templates /> -->
  <!--     </xsl:copy> -->
  <!--   </xsl:template> -->

  <xsl:template match="code">
    <xsl:copy-of select="text()|*" />
  </xsl:template>

  <xsl:template match="documentation">
    <div class="documentation"><xsl:copy-of select="text()|*" /></div>
  </xsl:template>

  <xsl:template match="function">
    <a name="{@signature}"><hr/></a>
    <xsl:apply-templates />
    <div class="docextra">View index ordered by [<a href="{/asy-code/@filename}.asy.index.sign.html">name</a>] - [<a href="{/asy-code/@filename}.asy.index.type.html">type</a>]</div>
  </xsl:template>

  <xsl:template match="typedef">
    <a name="typedef {@return} {@type}({@params})"><hr/></a>
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="operator">
    <a name="{@signature}"><hr/></a>
    <xsl:apply-templates />
    <div class="docextra">View index ordered by [<a href="{/asy-code/@filename}.asy.index.sign.html">name</a>] - [<a href="{/asy-code/@filename}.asy.index.type.html">type</a>]</div>
  </xsl:template>

  <xsl:template match="property">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="method">
    <xsl:apply-templates />
  </xsl:template>

  <xsl:template match="variable">
    <a name="{@signature}"><hr/></a>
    <xsl:apply-templates />
    <div class="docextra">View index ordered by [<a href="{/asy-code/@filename}.asy.index.sign.html">name</a>] - [<a href="{/asy-code/@filename}.asy.index.type.html">type</a>]</div>
  </xsl:template>

  <xsl:template match="constant">
    <a name="{@signature}"><hr/></a>
    <xsl:apply-templates />
    <div class="docextra">View index ordered by [<a href="{/asy-code/@filename}.asy.index.sign.html">name</a>] - [<a href="{/asy-code/@filename}.asy.index.type.html">type</a>]</div>
  </xsl:template>

  <xsl:template match="struct">
    <a name="struct {@signature}"><hr/></a>
    <xsl:apply-templates />
    <div class="docextra">View index ordered by [<a href="{/asy-code/@filename}.asy.index.sign.html">name</a>] - [<a href="{/asy-code/@filename}.asy.index.type.html">type</a>]</div>
  </xsl:template>

  <xsl:template match="pre">
    <pre><xsl:apply-templates /></pre>
  </xsl:template>

  <xsl:template match="span">
    <xsl:copy-of select="." />
  </xsl:template>

  <xsl:template match="text()|@*"><xsl:value-of select="." /></xsl:template>

  <xsl:template name="makelink">
    <xsl:param name="url" />
    <xsl:param name="text" />
    <a href="{$url}">
      <xsl:value-of select="$text" />
    </a>
  </xsl:template>

  <xsl:template name="menu">
    <div class="menuhf">
      <span><a href="javascript:history.back();">Back</a></span>
      <span><a href="http://piprime.fr/">Home</a></span>
      <span><a href="{/asy-code/@filename}.asy">Download this package</a></span>
      <span><a href="{/asy-code/@filename}.asy.index.sign.html">Index ordered by name</a></span>
      <span><a href="{/asy-code/@filename}.asy.index.type.html">Index ordered by type</a></span>
      <span><a href="{/asy-code/@filename}/index.html">Gallery of examples</a></span>
      <span><a href="http://asymptote.sourceforge.net/">Official Asymptote WEB Site</a></span>
    </div>
  </xsl:template>

  <!-- Règle pour mes tags: -->

  <xsl:template match="presentation">
    <xsl:copy-of select="text()|*" />
  </xsl:template>

  <xsl:template match="module">
    <xsl:text> View the definition of </xsl:text>
    <xsl:call-template name="makelink">
      <xsl:with-param name="text" select="@anchor" />
      <xsl:with-param name="url" select="concat(@file,'#',@anchor)" />
    </xsl:call-template>
  </xsl:template>


  <xsl:template match="html">
    <xsl:copy-of select="text()|*" />
  </xsl:template>


</xsl:stylesheet>
