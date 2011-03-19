<xsl:stylesheet version='2.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs='http://www.w3.org/2001/XMLSchema'
  xmlns:sb='http://github.com/jedahu/static-blog'
  xmlns:a='http://www.w3.org/2005/Atom'
  xmlns='http://www.w3.org/1999/xhtml'
  xpath-default-namespace='http://www.w3.org/1999/xhtml'
  exclude-result-prefixes='sb'>
  <xsl:output method='xml' indent='yes'/>
  <xsl:template match='/sb:post' mode='feed'>
    <a:entry>
      <a:title>
        <xsl:value-of select='sb:content(//sb:title[1])'/>
      </a:title>
      <a:id>
        <xsl:value-of select='sb:entry-id(/sb:post)'/>
      </a:id>
      <xsl:for-each select='//sb:tag'>
        <a:category scheme='http://{$domain}/tags/'
          tag='{normalize-space(text())}'/>
      </xsl:for-each>
      <a:updated>
        <xsl:value-of
          select='max(
            for $x in (//sb:ctime|//sb:mtime)/text()
            return normalize-space($x))'/>
      </a:updated>
      <xsl:apply-templates
        mode='feed'
        select='if (//sb:author) then //sb:author else $config/sb:author'/>
      <xsl:apply-templates
        mode='feed'
        select='//sb:contributor'/>
      <xsl:if test='//sb:summary'>
        <a:summary type='xhtml'>
          <xsl:copy-of
            copy-namespaces='no'
            select='//sb:summary[1]/node()'/>
        </a:summary>
      </xsl:if>
    </a:entry>
  </xsl:template>
  <xsl:template match='sb:attrib'>
    <ul class='attribution'>
      <xsl:apply-templates mode='feed'/>
    </ul>
  </xsl:template>
  <xsl:template match='sb:artifact'>
    <a href='{@href}'>
      <xsl:copy-of select='node()'/>
    </a>
  </xsl:template>
  <xsl:template match='sb:author' mode='feed'>
    <a:author>
      <xsl:apply-templates mode='feed'/>
    </a:author>
  </xsl:template>
  <xsl:template match='sb:contributor' mode='feed'>
    <a:contributor>
      <xsl:apply-templates mode='feed'/>
    </a:contributor>
  </xsl:template>
  <xsl:template match='sb:author/sb:name|sb:contributor/sb:name'
    mode='feed'>
    <a:name><xsl:value-of select='text()'/></a:name>
  </xsl:template>
  <xsl:template
    match='
      sb:author/node()[last()=1 and self::text()]
      |sb:contributor/node()[last()=1 and self::text()]'
    mode='feed'>
    <a:name><xsl:value-of select='.'/></a:name>
  </xsl:template>
  <xsl:template
    match='sb:author/sb:email|sb:contributor/sb:email'
    mode='feed'>
    <a:email><xsl:value-of select='text()'/></a:email>
  </xsl:template>
  <xsl:template
    match='sb:author/sb:uri|sb:contributor/sb:uri'
    mode='feed'>
    <a:uri><xsl:value-of select='text()'/></a:uri>
  </xsl:template>
  <xsl:template match='sb:author/sb:about' mode='feed'>
  </xsl:template>
</xsl:stylesheet>

