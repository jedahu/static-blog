<xsl:stylesheet version='2.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs='http://www.w3.org/2001/XMLSchema'
  xmlns:sb='http://github.com/jedahu/static-blog'
  xmlns:h='http://www.w3.org/1999/xhtml'
  xmlns='http://www.w3.org/1999/xhtml'
  xpath-default-namespace='http://www.w3.org/1999/xhtml'
  exclude-result-prefixes='sb'>
  <xsl:include href='comments.xsl'/>
  <xsl:template match='/sb:post' mode='web'>
    <xsl:if test='not(matches(/sb:post/@n, "[0-9]+|draft"))'>
      <xsl:message terminate='yes'>
        /sb:post/@n required and must be a positive integer or 'draft'..
      </xsl:message>
    </xsl:if>
    <html lang='EN' xml:lang='EN'>
      <xsl:call-template name='post-head'/>
      <xsl:call-template name='post-body'/>
    </html>
  </xsl:template>
  <xsl:template name='post-head'>
    <head>
      <xsl:call-template name='common-head'/>
      <link rel='canonical' href='{sb:canonical_url(/sb:post)}'/>
      <meta name='entry-id' content='sb:entry-id(/sb:post)'/>
      <script type='text/javascript' src='/lf/post.js'>
      </script>
    </head>
  </xsl:template>
  <xsl:template name='post-body'>
    <body>
      <xsl:call-template name='post-article'/>
      <xsl:call-template name='post-comments'/>
      <xsl:call-template name='post-other'/>
    </body>
  </xsl:template>
  <xsl:template name='post-article'>
    <article class='hentry' role='main'>
      <xsl:call-template name='post-article-header'/>
      <!--xsl:call-template name='post-article-summary'/-->
      <xsl:call-template name='post-article-content'/>
      <xsl:call-template name='post-article-footer'/>
    </article>
  </xsl:template>
  <xsl:template name='post-article-header'>
    <h1 class='entry-title' role='header'>
      <xsl:copy-of
        copy-namespaces='no'
        select='//sb:title[1]/node()'/>
      <xsl:if test='/sb:post/sb:summary'>
        <a class='note' href='#note-title'>*</a>
      </xsl:if>
    </h1>
  </xsl:template>
  <!--xsl:template name='post-article-summary'>
    <xsl:if test='/sb:post/sb:summary'>
      <div class='entry-summary'>
        <xsl:copy-of copy-namespaces='no'
          select='/sb:post/sb:summary[1]/node()'/>
      </div>
    </xsl:if>
  </xsl:template-->
  <xsl:template name='post-article-content'>
    <div class='entry-content'>
      <xsl:apply-templates select='/sb:post/sb:content/node()'
        mode='web'/>
      <aside>
        <xsl:if test='/sb:post/sb:content//sb:note|/sb:post/sb:summary'>
          <dl class='notes'>
            <xsl:if test='/sb:post/sb:summary'>
              <dt>*</dt>
              <dd id='note-title'>
                <xsl:copy-of copy-namespaces='no'
                  select='/sb:post/sb:summary[1]/node()'/>
              </dd>
            </xsl:if>
            <xsl:for-each select='/sb:post/sb:content//sb:note'>
              <dt>
                <xsl:value-of select='position()'/>
              </dt>
              <dd id='note{position()}'>
                <xsl:copy-of select='node()' copy-namespaces='no'/>
              </dd>
            </xsl:for-each>
          </dl>
        </xsl:if>
      </aside>
    </div>
  </xsl:template>
  <xsl:template name='post-suffix'/>
  <xsl:template name='post-article-footer'>
    <footer class='entry-meta'>
      <xsl:call-template name='post-authors'/>
      <xsl:call-template name='post-contributors'/>
      <xsl:call-template name='post-attrib'/>
      <xsl:call-template name='post-ctime'/>
      <xsl:call-template name='post-mtime'/>
      <xsl:call-template name='post-suffix'/>
    </footer>
  </xsl:template>
  <xsl:template name='post-authors'>
    <xsl:if test='/sb:post/sb:meta/sb:author'>
      <p class='authors'>
        <xsl:text>Written by: </xsl:text>
        <xsl:for-each select='/sb:post/sb:meta/sb:author'>
          <xsl:apply-templates/>
          <xsl:value-of
            select='if (position()=last()) then ", " else "."'/>
        </xsl:for-each>
      </p>
    </xsl:if>
  </xsl:template>
  <xsl:template name='post-contributors'>
    <xsl:if test='/sb:post/sb:meta/sb:contributor'>
      <p class='contributors'>
        <xsl:text>Contributors: </xsl:text>
        <xsl:for-each select='/sb:post/sb:meta/sb:contributor'>
          <xsl:apply-templates/>
          <xsl:value-of
            select='if (position()=last()) then ", " else "."'/>
        </xsl:for-each>
      </p>
    </xsl:if>
  </xsl:template>
  <xsl:template name='post-attrib'>
    <xsl:apply-templates select='//sb:attrib[1]' mode='web'/>
  </xsl:template>
  <xsl:template name='post-ctime'>
    <xsl:if test='/sb:post/sb:meta/sb:ctime'>
      <div class='ctime'>
        <xsl:text>Created: </xsl:text>
        <span class='time'>
          <xsl:value-of
            select='/sb:post/sb:meta/sb:ctime[1]/text()'/>
        </span>
        <xsl:text>.</xsl:text>
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template name='post-mtime'>
    <xsl:if test='/sb:post/sb:meta/sb:mtime'>
      <div class='mtime'>
        <xsl:text>Last modified: </xsl:text>
        <span class='time'>
          <xsl:value-of
            select='/sb:post/sb:meta/sb:mtime[last()]/text()'/>
        </span>
        <xsl:text>.</xsl:text>
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template name='post-other'>
    <div class='non-entry'>
      <xsl:call-template name='post-nextprev'/>
      <xsl:call-template name='title-block'/>
      <xsl:call-template name='recent-posts'/>
      <xsl:call-template name='subscribe'/>
    </div>
  </xsl:template>
  <xsl:template name='post-nextprev' xml:base='..'>
    <xsl:if test='matches(/sb:post/@n, "[0-9]+")'>
      <div class='nextprev'>
        <xsl:variable name='pp'
          select='concat($blog-path, "/", /sb:post/@n - 1)'/>
        <xsl:variable name='ppp'
          select='concat($pp, "/index", $suffix)'/>
        <xsl:variable name='np'
          select='concat($blog-path, "/", /sb:post/@n + 1)'/>
        <xsl:variable name='npp'
          select='concat($np, "/index", $suffix)'/>
        <xsl:if test='doc-available($ppp)'>
          <a class='prev' href='/{$pp}'>
            <xsl:value-of
              select='sb:content(doc($ppp)//sb:title[1])'/>
          </a>
        </xsl:if>
        <xsl:if test='doc-available($npp)'>
          <a class='next' href='/{$np}'>
            <xsl:value-of
              select='sb:content(doc($npp)//sb:title[1])'/>
          </a>
        </xsl:if>
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template name='subscribe'>
    <div class='subscribe'>
      <h4>Subscribe</h4>
      <a href='{sb:content($config/sb:feed/sb:url[1])}'>RSS Feed</a>
    </div>
  </xsl:template>
  <xsl:template name='recent-posts'>
    <div class='recent-posts' role='navigation'>
    </div>
  </xsl:template>
  <xsl:template match='sb:attrib' mode='web'>
    <ul class='attribution'>
      <xsl:apply-templates mode='web'/>
    </ul>
  </xsl:template>
  <xsl:template match='sb:attrib/sb:item' mode='web'>
    <li>
      <xsl:apply-templates mode='web'/>
    </li>
  </xsl:template>
  <xsl:template match='sb:artifact' mode='web'>
    <a href='{@href}' class='artifact'>
      <xsl:copy-of select='node()'/>
    </a>
  </xsl:template>
  <xsl:template match='sb:creator' mode='web'>
    <a href='{@href}' class='creator'>
      <xsl:copy-of select='node()'/>
    </a>
  </xsl:template>
  <xsl:template match='sb:license' mode='web'>
    <a href='{@href}' class='license'>
      <xsl:copy-of select='node()'/>
    </a>
  </xsl:template>
  <xsl:template match='sb:author' mode='web'>
    <span class='hcard'>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <xsl:template match='sb:contributor' mode='web'>
    <span class='hcard'>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <xsl:template
    match='
      sb:author/node()[last()=1 and self::text()]
      |sb:contributor/node()[last()=1 and self::text()]'
    mode='web'>
    <xsl:value-of select='.'/>
  </xsl:template>
  <xsl:template match='sb:author/sb:name|sb:contributor/sb:name'
    mode='web'>
    <xsl:choose>
      <xsl:when test='parent::sb:uri'>
        <a href='{normalize-space(parent::sb:uri/text())}'>
          <xsl:value-of select='normalize-space(text())'/>
        </a>
      </xsl:when>
      <xsl:when test='parent::sb:email'>
        <a href='mailto:{normalize-space(parent::sb:email/text())}'>
          <xsl:value-of select='normalize-space(text())'/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select='normalize-space(text())'/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match='sb:note' mode='web'>
    <xsl:variable name='n'>
      <xsl:number level='any'/>
    </xsl:variable>
    <a class='note' href='#note{$n}'>
      <sup>
        <xsl:value-of select='$n'/>
      </sup>
    </a>
  </xsl:template>
</xsl:stylesheet>
