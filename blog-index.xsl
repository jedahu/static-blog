<?xml version='1.0'?>
<xsl:stylesheet version='2.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs='http://www.w3.org/2001/XMLSchema'
  xmlns:sb='http://github.com/jedahu/static-blog'
  xmlns:h='http://www.w3.org/1999/xhtml'
  xmlns='http://www.w3.org/1999/xhtml'
  xpath-default-namespace='http://www.w3.org/1999/xhtml'
  exclude-result-prefixes='sb'>
  <xsl:template match='/sb:index' mode='web'>
    <html lang='EN' xml:lang='EN'>
      <xsl:apply-templates mode='web'/>
    </html>
  </xsl:template>
  <xsl:template match='head' mode='web'>
    <head>
      <xsl:call-template name='common-head'/>
      <xsl:copy-of
        copy-namespaces='no'
        select='node()'/>
    </head>
  </xsl:template>
  <xsl:template match='sb:title-block' mode='web'>
    <div class='non-entry'>
      <xsl:call-template name='title-block'/>
    </div>
  </xsl:template>
  <xsl:template match='sb:entry-list' mode='web' xml:base='..'>
    <xsl:for-each
      select='reverse(1 to $latest-post)'>
      <xsl:variable name='path'
        select='concat($blog-path, "/", ., "/index", $suffix)'/>
      <xsl:if test='doc-available($path)'>
        <xsl:variable name='post'
          select='doc($path)'/>
        <xsl:if test='not($post/sb:post/@draft)'>
          <article class='hentry' role='main'>
            <hgroup>
              <div class='published'>
                <a href='/{$blog-path}/{.}/'>
                  <xsl:value-of
                    select='sb:content($post/sb:post/sb:meta/sb:ctime[1])'/>
                </a>
              </div>
              <h1 class='entry-title'>
                <a href='/{$blog-path}/{.}/'>
                  <xsl:copy-of
                    copy-namespaces='no'
                    select='$post//sb:title[1]/node()'/>
                </a>
              </h1>
            </hgroup>
            <xsl:if test='$post/sb:post/sb:summary'>
              <div class='entry-summary'>
                <xsl:copy-of
                  copy-namespaces='no'
                  select='$post/sb:post/sb:summary/node()'/>
              </div>
            </xsl:if>
          </article>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
