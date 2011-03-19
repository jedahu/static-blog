<xsl:stylesheet version='2.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:xs='http://www.w3.org/2001/XMLSchema'
  xmlns:sb='http://github.com/jedahu/static-blog'
  xmlns:sc='http://github.com/jedahu/static-blog#config'
  xmlns:h='http://www.w3.org/1999/xhtml'
  xmlns='http://www.w3.org/1999/xhtml'
  xpath-default-namespace='http://www.w3.org/1999/xhtml'
  exclude-result-prefixes='h sc sb'>
  <xsl:function name='sb:entry-id'>
    <xsl:param name='post'/>
    <xsl:value-of
      select='concat("tag:", $domain, ",", $est, ":", $post/@n)'/>
  </xsl:function>
  <xsl:function name='sb:content'>
    <xsl:param name='node' as='node()*'/>
    <xsl:value-of
      select='normalize-space(string-join($node//text(), ""))'/>
  </xsl:function>
  <xsl:function name='sb:adjacent-posts'>
    <xsl:param name='path' as='xs:string'/>
    <xsl:analyze-string select='$path' regex='^(.*?{$blog-path}/)([0-9]+)(/.*)$'>
      <xsl:matching-substring>
        <xsl:variable name='n' select='xs:integer(regex-group(2))' as='xs:integer'/>
        <xsl:variable name='prev-path'
          select='concat(regex-group(1), $n - 1, regex-group(3))'/>
        <xsl:variable name='next-path'
          select='concat(regex-group(1), $n + 1, regex-group(3))'/>
        <xsl:sequence
          select='(
            .,
            if ($n - 1 &gt; 0 and doc-available($prev-path))
              then $prev-path
              else (),
            if ($n + 1 &lt;= $latest-post and doc-available($next-path))
              then $next-path
              else ())'/>
      </xsl:matching-substring>
      <xsl:non-matching-substring>
        <xsl:value-of select='.'/>
      </xsl:non-matching-substring>
    </xsl:analyze-string>
  </xsl:function>
  <xsl:function name='sb:include-adjacent-posts'>
    <xsl:param name='paths-in' as='xs:string*'/>
    <xsl:sequence
      select='distinct-values(
        for $p in $paths-in
        return sb:adjacent-posts($p))'/>
  </xsl:function>
  <xsl:function name='sb:canonical_url'>
    <xsl:param name='post' as='node()'/>
    <xsl:value-of
      select='string-join(("http:/", $domain, $blog-path, $post/@n, ""), "/")'/>
  </xsl:function>
</xsl:stylesheet>
