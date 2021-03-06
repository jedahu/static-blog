<xsl:stylesheet version='2.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:sb='http://github.com/jedahu/static-blog'
  xmlns:xs='http://www.w3.org/2001/XMLSchema'
  xmlns:h='http://www.w3.org/1999/xhtml'
  xmlns:a='http://www.w3.org/2005/Atom'
  xmlns='http://www.w3.org/1999/xhtml'
  xpath-default-namespace='http://www.w3.org/1999/xhtml'
  exclude-result-prefixes='h sb a xs'>
  <xsl:param name='root'/>
  <xsl:output method='xml' indent='yes' name='xml'/>
  <xsl:output method='xhtml' indent='yes' name='xhtml'/>
  <xsl:output method='html' indent='yes' name='html'/>
  <xsl:output method='xhtml' indent='yes' name='xhtml-fragment'
    omit-xml-declaration='yes'/>
  <xsl:output method='html' indent='yes' name='html-fragment'/>
  <xsl:include href='common-html.xsl'/>
  <xsl:include href='post.xsl'/>
  <xsl:include href='blog-index.xsl'/>
  <xsl:include href='entry.xsl'/>
  <xsl:include href='redirect.xsl'/>
  <xsl:variable name='sbrc'>
    <xsl:choose>
      <xsl:when test='doc-available(concat($root, "/sbrc"))'>
        <xsl:value-of select='concat($root, "/sbrc")'/>
      </xsl:when>
      <xsl:when test='doc-available(concat($root, "/sbrc.xml"))'>
        <xsl:value-of select='concat($root, "/sbrc.xml")'/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate='yes'>Error: no sbrc or sbrc.xml found.</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name='config' select='doc($sbrc)/sb:config'/>
  <xsl:variable name='domain'
    select='$config/sb:domain/text()'/>
  <xsl:variable name='est'
    select='$config/sb:est/text()'/>
  <xsl:variable name='feed-length' as='xs:integer'
    select='$config/sb:feed/sb:length/text()'/>
  <xsl:variable name='blog-path'
    select='sb:content($config//sb:blog-path[1])'/>
  <xsl:variable name='suffix'
    select='concat(".", sb:content($config//sb:suffix[1]))'/>
  <xsl:variable name='html-suffix'
    select='concat(".", sb:content($config//sb:html-suffix[1]))'/>
  <xsl:variable name='feed-path' select='concat($blog-path, "/feed/index.xml")'/>
  <xsl:variable name='latest-fragment-path' select='concat($blog-path, "/latest/index", $html-suffix)'/>
  <xsl:variable name='files' select='tokenize(/sb:files/text(), "\s+")'/>
  <xsl:template name='find-latest-post'>
    <xsl:param name='n' select='1'/>
    <xsl:variable name='path' select='concat($root, "/", $blog-path, "/", $n, "/index.sb")'/>
    <xsl:message>Path: <xsl:value-of select='$path'/></xsl:message>
    <xsl:choose>
      <xsl:when test='doc-available($path) and not(doc($path)/sb:post/@draft)'>
        <xsl:call-template name='find-latest-post'>
          <xsl:with-param name='n' select='$n + 1'/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>Latest post is <xsl:value-of select='$n - 1'/></xsl:message>
        <xsl:value-of select='$n - 1'/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:variable name='latest-post' as='xs:integer'>
    <xsl:call-template name='find-latest-post'/>
  </xsl:variable>
  <xsl:template match='/sb:files'>
    <xsl:call-template name='process-files'/>
    <xsl:call-template name='generate-feed'/>
    <xsl:call-template name='generate-latest'/>
  </xsl:template>
  <xsl:template name='process-files'>
    <xsl:message>Processing files</xsl:message>
    <xsl:for-each select='sb:include-adjacent-posts($files)'>
      <xsl:if test='doc-available(.)'>
        <xsl:variable name='pdoc' select='doc(.)'/>
        <xsl:if test='not($pdoc/sb:post/@draft)'>
          <xsl:choose>
            <xsl:when test='ends-with(., $suffix)'>
              <xsl:variable name='out-suffix'>
                <xsl:choose>
                  <xsl:when test='ends-with(., concat(".html", $suffix))'>
                    <xsl:value-of select='""'/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select='$html-suffix'/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:variable name='path'
                select='concat(substring(., 1, string-length(.) - string-length($suffix)), $out-suffix)'/>
              <xsl:result-document href='{$path}' method='html' format='html'
                xml:base='..'>
                <xsl:apply-templates select='$pdoc' mode='web'/>
              </xsl:result-document>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>
  <xsl:template name='generate-feed'>
    <xsl:result-document href='{$root}/{$feed-path}' method='xml'
      xml:base='..'>
      <xsl:message>Generating feed at <xsl:value-of select='$feed-path'/></xsl:message>
      <xsl:variable name='entries'>
        <xsl:for-each
          select='reverse(max((1, $latest-post - $feed-length)) to $latest-post)'>
          <xsl:variable name='path'
            select='concat($root, "/", $blog-path, "/", ., "/index", $suffix)'/>
          <xsl:if test='doc-available($path)'>
            <xsl:variable name='pdoc' select='doc($path)'/>
            <xsl:if test='not($pdoc/sb:post/@draft)'>
              <xsl:apply-templates mode='feed' select='$pdoc'/>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </xsl:variable>
      <a:feed>
        <a:title>
          <xsl:value-of select='sb:content($config/sb:title[1])'/>
        </a:title>
        <a:link rel='self'
          href='http://{$domain}/feed/'/>
        <a:link href='http://{$domain}'/>
        <a:generator uri='http://github.com/jedahu/static-blog'>
          Static Blog
        </a:generator>
        <a:id>
          <xsl:value-of
            select='
              if ($config/sb:id)
              then $config/sb:id/text()
              else concat("http://", $domain)'/>
        </a:id>
        <a:updated>
          <xsl:value-of
            select='max(
              for $x in $entries//a:updated/text()
              return normalize-space($x))'/>
        </a:updated>
        <xsl:copy-of copy-namespaces='no' select='$entries'/>
      </a:feed>
    </xsl:result-document>
  </xsl:template>
  <xsl:template name='generate-latest'>
    <xsl:result-document href='{$root}/{$latest-fragment-path}' method='html' format='html'
      xml:base='..'>
      <xsl:message>Generating latest fragment at <xsl:value-of select='$latest-fragment-path'/></xsl:message>
      <ul>
        <xsl:for-each
          select='reverse(max((1, $latest-post - $feed-length)) to $latest-post)'>
          <xsl:variable name='path'
            select='concat($root, "/", $blog-path, "/", ., "/index", $suffix)'/>
          <xsl:if test='doc-available($path)'>
            <xsl:variable name='pdoc' select='doc($path)'/>
            <xsl:if test='not($pdoc/sb:post/@draft)'>
              <xsl:variable name='post' select='$pdoc/sb:post'/>
              <li>
                <a href='/{$blog-path}/{.}/'>
                  <span class='published'>
                    <xsl:value-of
                      select='sb:content($post/sb:meta/sb:ctime[1])'/>
                  </span>
                  <span class='title'>
                    <xsl:value-of
                      select='sb:content($post//sb:title[1])'/>
                  </span>
                </a>
              </li>
            </xsl:if>
          </xsl:if>
        </xsl:for-each>
      </ul>
      <a class='more' href='/{$blog-path}/'>More</a>
    </xsl:result-document>
  </xsl:template>
</xsl:stylesheet>
