<xsl:stylesheet version='2.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:sb='http://github.com/jedahu/static-blog'
  xmlns:h='http://www.w3.org/1999/xhtml'
  xmlns='http://www.w3.org/1999/xhtml'
  xpath-default-namespace='http://www.w3.org/1999/xhtml'
  exclude-result-prefixes='h sb'>
  <xsl:include href='common.xsl'/>
  <xsl:template name='common-head'>
    <title>
      <xsl:value-of
        select='sb:content(
          if (//sb:title)
          then //sb:title[1]
          else $config/sb:title[1])'/>
    </title>
    <link rel='alternate' type='application/atom+xml'
      title='{sb:content($config/sb:title[1])}' href='{sb:content($config/sb:feed/sb:url[1])}'/>
    <xsl:apply-templates select='//sb:tag' mode='web'/>
    <meta name='MSSmartTagsPreventParsing' content='true'/>
    <meta name='generator' content='static-blog'/>
    <meta name='blog name'
      content='{sb:content($config/sb:title[1])}'/>
    <xsl:copy-of
      copy-namespaces='no'
      select='$config/sb:meta/h:*'/>
    <xsl:copy-of
      copy-namespaces='no'
      select='//sb:meta/h:*'/>
  </xsl:template>
  <xsl:template match='@*|node()' mode='web'>
    <xsl:copy>
      <xsl:apply-templates select='@*|node()' mode='web'/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match='sb:tag' mode='web'>
    <meta name='tag' content='{node()}'/>
  </xsl:template>
  <xsl:template name='title-block'>
    <div class='title-block' role='banner'>
      <div role='header'>
        <a href='/'>
          <xsl:copy-of
            copy-namespaces='no'
            select='$config/sb:title[1]/node()'/>
        </a>
      </div>
      <div class='vcard'>
        <xsl:if test='$config/sb:author[1]/sb:image'>
          <img class='photo' src='{$config/sb:author/sb:image[1]/text()}'/>
        </xsl:if>
        <div class='fn' role='header'>
          <xsl:copy-of
            copy-namespaces='no'
            select='$config/sb:author[1]/sb:name/text()'/>
        </div>
        <xsl:copy-of
          copy-namespaces='no'
          select='$config/sb:author[1]/sb:about/node()'/>
      </div>
    </div>
  </xsl:template>
</xsl:stylesheet>
