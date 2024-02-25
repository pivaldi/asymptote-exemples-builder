<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:param name="sortmethod" />
  <xsl:param name="sortby" />
  <xsl:output method="xml" encoding="UTF-8" indent="yes"
              doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" />
  <xsl:template match="/asy/asy-module">
    <html>
      <head>
        <link rel="shortcut icon" href="{/asy/@resource}favicon.png" type="image/x-icon" />
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="keywords" content="asymptote,latex,graphique,graphic,scientifique,scientific,logiciel,software" />
        <meta name="description" content="asymptote latex graphique graphic scientifique scientific logiciel software" />
        <meta name="author" content="Philippe Ivaldi" />
        <meta name="generator" content="Emacs" />
        <link href="{/asy/@resource}style-index-asy.css" rel="stylesheet" type="text/css" />
        <title><xsl:value-of select="/asy/@title" /></title>
      </head>
      <body>
        <xsl:call-template name="menu"/>
        <center><div class="presentation">
          Index of <xsl:value-of select="/asy/@filename" />
          <!-- <xsl:copy-of select="../presentation/."/> -->
        </div></center>
        <hr/>
        <h2>Contents</h2>
        <a class="title" href="#typedef">List of Anonymous functions</a><br/>
        <xsl:call-template name="typelist"/>
        <a class="title" href="#structure">List of structures</a><br/>
        <xsl:call-template name="strlist"/>
        <a class="title" href="#constant">List of constants</a><br/>
        <xsl:call-template name="signlist"><xsl:with-param name="type" select=".//constant" /></xsl:call-template>
        <a class="title" href="#variable">List of variables</a><br/>
        <xsl:call-template name="signlist"><xsl:with-param name="type" select=".//variable" /></xsl:call-template>
        <a class="title" href="#function">List of functions</a><br/>
        <xsl:call-template name="signlist"><xsl:with-param name="type" select=".//function" /></xsl:call-template>
        <a class="title" href="#operator">List of operators</a><br/>
        <xsl:call-template name="signlist"><xsl:with-param name="type" select=".//operator" /></xsl:call-template>
        <hr/>
        <a name="typedef"><h2>List of Anonymous functions</h2></a>
        <xsl:call-template name="typedoc"/>
        <a name="structure"><h2>List of structures</h2></a>
        <xsl:call-template name="strdoc"/>
        <a name="constant"><h2>List of constants</h2></a>
        <xsl:call-template name="signdoc"><xsl:with-param name="type" select=".//constant" /></xsl:call-template>
        <a name="variable"><h2>List of variables</h2></a>
        <xsl:call-template name="signdoc"><xsl:with-param name="type" select=".//variable" /></xsl:call-template>
        <a name="function"><h2>List of functions</h2></a>
        <xsl:call-template name="signdoc"><xsl:with-param name="type" select=".//function" /></xsl:call-template>
        <a name="operator"><h2>List of operators</h2></a>
        <xsl:call-template name="signdoc"><xsl:with-param name="type" select=".//operator" /></xsl:call-template>
        <div class="foot">
          <xsl:call-template name="menu"></xsl:call-template>
          <p class="last-modif">
            Dernière modification/Last modified: <xsl:value-of select="/asy/@date" />
            <br /><a href="http://sourceforge.net/users/pivaldi/">Philippe Ivaldi</a>
          </p>
          <p>
            <a href="http://validator.w3.org/check?uri=referer">Valide XHTML</a>
          </p>
        </div>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="example">
    <xsl:param name="match" />
    <xsl:for-each select="/asy/asy-example/view[@signature=$match]">
      <xsl:sort data-type="number" order="ascending" select="@number"/>
      <a href="../index.html#fig{..//@number}">Example <xsl:value-of select="..//@number"/></a><xsl:text> </xsl:text>
    </xsl:for-each>
  </xsl:template>

  <!-- Génère la doc des balises à "signature"  -->
  <xsl:template name="signdoc">
    <xsl:param name="type" />
    <xsl:for-each select="$type">
      <xsl:sort data-type="text" order="{$sortmethod}" select="@*[name() = $sortby]"/>
      <xsl:sort order="ascending" select="@signature"/>
      <xsl:variable name="fsign" select="@signature" />
      <a name="{@signature}"><h5><xsl:value-of select="@signature"/></h5></a>
      <div class="item">
        <xsl:apply-templates select=".//code"/>
        <xsl:apply-templates select=".//documentation"/>[<a href="{/asy/@filename}.asy.html#{@signature}">Browse code</a>]
        <xsl:call-template name="example"><xsl:with-param name="match" select="$fsign" /></xsl:call-template>
      </div>
    </xsl:for-each>
  </xsl:template>

  <!-- Génère la liste des balises à "signature"  -->
  <xsl:template name="signlist">
    <xsl:param name="type" />
    <xsl:for-each select="$type">
      <xsl:sort data-type="text" order="{$sortmethod}" select="@*[name() = $sortby]"/>
      <xsl:sort order="ascending" select="@signature"/>
      <div class="deptha"><a href="#{@signature}"><xsl:value-of select="@type"/><xsl:text> </xsl:text><xsl:value-of select="@signature"/></a></div>
    </xsl:for-each>
  </xsl:template>

  <!-- Génère la doc des balises à structure  -->
  <xsl:template name="strdoc">
    <xsl:for-each select=".//struct">
      <xsl:sort data-type="text" order="ascending" select="@signature"/>
      <xsl:variable name="fsign" select="@signature" />
      <a name="struct {@signature}"><h5><xsl:value-of select="@signature"/></h5></a>
      <div class="item">
        <xsl:apply-templates select="./code"/>
        <xsl:apply-templates select="./documentation"/>[<a href="{/asy/@filename}.asy.html#struct {@signature}">Browse code</a>]
        <xsl:apply-templates select=".//property"/>
        <xsl:apply-templates select=".//method"/>
        <xsl:call-template name="example"><xsl:with-param name="match" select="$fsign" /></xsl:call-template>
      </div>
    </xsl:for-each>
  </xsl:template>

  <!-- Génère la liste des structures  -->
  <xsl:template name="strlist">
    <xsl:for-each select=".//struct">
      <xsl:sort data-type="text" order="ascending" select="@signature"/>
      <div class="deptha"><a href="#struct {@signature}">struct <xsl:value-of select="@signature"/></a></div>
    </xsl:for-each>
  </xsl:template>

  <!-- Génère la doc des typedef  -->
  <xsl:template name="typedoc">
    <xsl:for-each select=".//typedef">
      <xsl:sort data-type="text" order="ascending" select="@type"/>
      <xsl:variable name="fsign" select="concat(concat(concat(concat(concat(concat('typedef ',@return),' '),@type),'('),@params),')')" />
      <a name="{$fsign}"><h5><xsl:value-of select="$fsign"/></h5></a>
      <div class="item">
        <xsl:apply-templates select="./code"/>
        <xsl:apply-templates select="./documentation"/>
        <xsl:call-template name="example"><xsl:with-param name="match" select="$fsign" /></xsl:call-template>
      </div>
    </xsl:for-each>
  </xsl:template>

  <!-- Génère la liste des typedef  -->
  <xsl:template name="typelist">
    <xsl:for-each select=".//typedef">
      <xsl:sort data-type="text" order="ascending" select="@type"/>
      <xsl:variable name="fsign" select="concat(concat(concat(concat(concat(concat('typedef ',@return),' '),@type),'('),@params),')')" />
      <div class="deptha"><a href="#{$fsign}"><xsl:value-of select="$fsign"/></a></div>
    </xsl:for-each>
  </xsl:template>


  <xsl:template name="bphp">
    <xsl:text disable-output-escaping="yes">&lt;?php </xsl:text>
  </xsl:template>

  <xsl:template name="ephp">
    <xsl:text disable-output-escaping="yes"> ?&gt;</xsl:text>
  </xsl:template>

  <xsl:template name="uri">
    <xsl:call-template name="bphp"/>
    get_bloginfo('url').'<xsl:value-of select="@dirname" />';
    <xsl:call-template name="ephp"/>
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
      <a href="../index.html">Up</a><xsl:text> </xsl:text>
      <a href="http://piprim.tuxfamily.org/index.html">Summary</a><xsl:text> </xsl:text>
      <a href="{/asy/@filename}.asy">Download this package</a><xsl:text> </xsl:text>
      <a href="{/asy/@filename}.asy.html">Browse this package</a><xsl:text> </xsl:text>
      <xsl:if test="$sortby='type'">
        <a href="{/asy/@filename}.asy.index.sign.html">Index ordered by function name</a><xsl:text> </xsl:text>
      </xsl:if>
      <xsl:if test="$sortby='signature'">
        <a href="{/asy/@filename}.asy.index.type.html">Index ordered by type name</a><xsl:text> </xsl:text>
      </xsl:if>
      <a href="../index.html">Gallery of examples</a><xsl:text> </xsl:text>
      <a href="http://asymptote.sourceforge.net/">Asymptote</a><xsl:text> </xsl:text>
    </div>
  </xsl:template>

  <!-- Règle pour mes tags: -->

  <xsl:template match="code">
    <pre><xsl:copy-of select="text()|*" /></pre>
  </xsl:template>

  <xsl:template match="/asy/asy-example|/asy/presentation">
  </xsl:template>

  <xsl:template match="documentation">
    <div class="documentation"><xsl:copy-of select="text()|*" /></div>
  </xsl:template>

  <xsl:template match="property|method">
    <xsl:apply-templates select=".//code"/>
    <xsl:apply-templates select=".//documentation"/><br/>
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
