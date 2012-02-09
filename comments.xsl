<xsl:stylesheet version='2.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs='http://www.w3.org/2001/XMLSchema'
  xmlns:sb='http://github.com/jedahu/static-blog'
  xmlns:h='http://www.w3.org/1999/xhtml'
  xmlns='http://www.w3.org/1999/xhtml'
  xpath-default-namespace='http://www.w3.org/1999/xhtml'
  exclude-result-prefixes='sb'>

  <xsl:param name='comment-instructions'/>

  <xsl:template name='do-post-comments'>
    <section class='comments'>
      <xsl:if test='not(sb:comments-allowed(/sb:post))'>
        <div class='notice'>Comments are closed.</div>
      </xsl:if>
      <div role='header'>Comments</div>
      <div class='comment-content'>
        <xsl:if test='sb:comments-allowed(/sb:post)'>
          <xsl:copy-of copy-namespaces='no'
            select='$comment-instructions'/>
          <xsl:call-template name='comment-reply-form'/>
        </xsl:if>
        <xsl:apply-templates select='//sb:comments/sb:comment' mode='comment'/>
      </div>
      <div class='sentinel'/>
    </section>
  </xsl:template>

  <xsl:template name='post-comments'>
    <xsl:if test='sb:comments-allowed(/sb:post) or sb:comments-exist(/sb:post)'>
      <xsl:call-template name='do-post-comments'/>
    </xsl:if>
  </xsl:template>

  <xsl:template name='comment-reply-form'>
    <xsl:param name='placement' select='""'/>
    <xsl:param name='submit-text' select='"Post comment"'/>
    <form class='comment-form'
      action='{sb:content($config/sb:comments/sb:post-url[1])}'
      method='post'>
      <input type='hidden' name='permalink'
        value='{sb:canonical_url(/sb:post)}'/>
      <input type='hidden' name='moderator_email'
        value='{sb:content($config/sb:author/sb:email[1])}'/>
      <input type='hidden' name='comment_placement'
        value='{$placement}'/>
      <div>
        <label for='comment_author'>Name</label>
        <input type='text' name='comment_author'
          required='required'/> Required.
      </div>
      <div>
        <label for='comment_author_email'>Email</label>
        <input type='email' name='comment_author_email'
          required='required'/> Required but not displayed.
      </div>
      <div>
        <label for='comment_author_url'>URL</label>
        <input type='url' name='comment_author_url'
          placeholder='Your Website'/>
      </div>
      <div>
        <textarea name='comment_content'
          placeholder='Your Thoughts' required='required'/>
      </div>
      <div>
        <input type='submit' value='{$submit-text}'/>
      </div>
    </form>
  </xsl:template>

  <xsl:template match='sb:comment' mode='comment'>
    <div class='{
      if (sb:content(sb:author/sb:url) = concat("http://", $domain))
      then "comment blog-author"
      else "comment"}'>
      <xsl:apply-templates select='sb:author' mode='comment'/>
      <xsl:apply-templates select='sb:ctime' mode='comment'/>
      <xsl:apply-templates select='sb:content' mode='comment'/>
      <xsl:if test='sb:comments-allowed(/sb:post)'>
        <xsl:call-template name='comment-reply-form'>
          <xsl:with-param name='placement' select='sb:comment-placement(.)'/>
          <xsl:with-param name='submit-text' select='"Post reply"'/>
        </xsl:call-template>
      </xsl:if>
      <xsl:apply-templates select='sb:comment' mode='comment'/>
    </div>
  </xsl:template>

  <xsl:template match='sb:comment/sb:author' mode='comment'>
    <div class='author' role='header'>
      <xsl:choose>
        <xsl:when test='sb:url'>
          <a href='{sb:url/text()}'>
            <xsl:value-of select='sb:name/text()'/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <span>
            <xsl:value-of select='sb:name/text()'/>
          </span>
        </xsl:otherwise>
      </xsl:choose>
    </div>
  </xsl:template>

  <xsl:template match='sb:comment/sb:ctime' mode='comment'>
    <div class='ctime'>
      <xsl:value-of select='text()'/>
    </div>
  </xsl:template>

  <xsl:template match='sb:comment/sb:content' mode='comment'>
    <div class='content'>
      <xsl:copy-of copy-namespaces='no' select='h:*'/>
    </div>
  </xsl:template>

  <xsl:function name='sb:comment-placement'>
    <xsl:param name='comment' as='node()'/>
    <xsl:number select='$comment' count='sb:comment' level='multiple' format='1 1'/>
  </xsl:function>

  <xsl:function name='sb:comments-allowed' as='xs:boolean'>
    <xsl:param name='post' as='node()'/>
    <xsl:value-of select='not($post/sb:meta/sb:no-comment)'/>
  </xsl:function>

  <xsl:function name='sb:comments-exist' as='xs:boolean'>
    <xsl:param name='post' as='node()'/>
    <xsl:value-of select='exists($post/sb:comments/sb:comment)'/>
  </xsl:function>

</xsl:stylesheet>
