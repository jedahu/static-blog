<xsl:stylesheet version='2.0'
  xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
  xmlns:sb='http://github.com/jedahu/static-blog'
  xmlns='http://www.w3.org/1999/xhtml'
  xpath-default-namespace='http://www.w3.org/1999/xhtml'
  exclude-result-prefixes='sb'>
  <xsl:output method='xhtml' indent='yes'/>
  <xsl:template match='/sb:redirect' mode='web'>
    <html>
      <head>
        <meta http-equiv='Refresh' content='0; url={@url}'/>
      </head>
      <body>
        <p>The page has <a href='{@url}'>moved here</a>.</p>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
