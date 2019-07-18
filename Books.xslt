<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes"/>

  <xsl:attribute-set name ="row">
    <xsl:attribute name="bgcolor">lightgreen</xsl:attribute>
    <xsl:attribute name="align">right</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template match="/">
    <html>
      <head>
        <title>Die besten XML Bücher</title>
      </head>
      <body>
        <H1>XML Bücher</H1>
        <h2>
          ∅ Seitenzahl:<xsl:value-of select="sum(/root/items/volumeInfo/pageCount) div count(/root/items)"/>
        </h2>

        <pre>
          <xsl:variable name="input">
Zeug:
Line1
  
Line2
       
Line3</xsl:variable>
          
          <hr/>
          Input:<xsl:value-of select="$input"/>
          <hr/>
          <xsl:variable name="inputSingelSpace">
            <xsl:call-template name="replace-string_recursive">
              <xsl:with-param name="text" select="$input"/>
              <xsl:with-param name="replace" select="'&#32;&#32;'" />
              <xsl:with-param name="with" select="'ö'"/>
            </xsl:call-template>
          </xsl:variable>

          Singel Space:<xsl:value-of select="$inputSingelSpace"/>
          Singel Space:<xsl:value-of select="$inputSingelSpace"/>
          <hr/>
          Replace $inputSingelSpace:
          <xsl:call-template name="replace-string_recursive">
            <xsl:with-param name="text" select="$inputSingelSpace"/>
            <xsl:with-param name="replace" select="'&#xD;&#xA;&#xD;&#xA;'" />
            <xsl:with-param name="with" select="'&#xD;&#xA;'"/>
          </xsl:call-template>

          <hr/>
          Replace INPUT:
          <xsl:call-template name="replace-string">
            <xsl:with-param name="text" select="$input"/>
            <xsl:with-param name="replace" select="'&#xD;&#xA;&#xD;&#xA;'" />
            <xsl:with-param name="with" select="'&#xD;&#xA;'"/>
          </xsl:call-template>

          <hr/>

          <xsl:call-template name="replace-string">
            <xsl:with-param name="text" select="'AAAAXXAAAXAAA'"/>
            <xsl:with-param name="replace" select="'XX'" />
            <xsl:with-param name="with" select="'X'"/>
          </xsl:call-template>
          <br/>
          <xsl:call-template name="replace-string_recursive">
            <xsl:with-param name="text" select="'AAAAXXAAAXAAA'"/>
            <xsl:with-param name="replace" select="'XX'" />
            <xsl:with-param name="with" select="'X'"/>
          </xsl:call-template>
        </pre>



        <table border="1">
          <tr>
            <th>#</th>
            <th></th>
            <th>Title</th>
            <th>Pub Date</th>
            <th>Pages</th>
          </tr>



          <xsl:for-each select="/root/items">
            <xsl:sort select="volumeInfo/pageCount" order="descending"/>
            <tr xsl:use-attribute-set="row">
              <xsl:if test="position() mod 2 = 0">
                <xsl:attribute name="bgcolor">lightblue</xsl:attribute>
              </xsl:if>
              <td>
                <xsl:value-of select="position()"/>
              </td>
              <td>
                <a>
                  <xsl:attribute name="href">
                    <xsl:value-of select="volumeInfo/infoLink"/>
                  </xsl:attribute>
                  <img height="50">
                    <xsl:attribute name="src">
                      <xsl:value-of select="volumeInfo/imageLinks/smallThumbnail"/>
                    </xsl:attribute>
                  </img>
                </a>
              </td>
              <td>
                <strong>

                  <xsl:value-of select="volumeInfo/title"/>
                </strong>
                <br/>
                <xsl:value-of select="substring(volumeInfo/description,0,600)"/>...
              </td>
              <td>
                <xsl:value-of select="volumeInfo/publishedDate"/>
              </td>
              <td>
                <!--<xsl:if test="volumeInfo/pageCount > 200">
          <xsl:attribute name="bgColor">
            lightblue
          </xsl:attribute>
        </xsl:if>-->

                <xsl:choose>
                  <xsl:when test="volumeInfo/pageCount >= 442">
                    <xsl:attribute name="bgColor">
                      lightgreen
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="volumeInfo/pageCount > 200">
                    <xsl:attribute name="bgColor">
                      lightyellow
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:attribute name="bgColor">
                      lightgray
                    </xsl:attribute>
                  </xsl:otherwise>
                </xsl:choose>

                <xsl:value-of select="volumeInfo/pageCount"/>
              </td>
            </tr>
          </xsl:for-each>

        </table>
      </body>
    </html>
  </xsl:template>



  <xsl:template match="@* | node()">

    <xsl:apply-templates />

    <!-- DEFAULT Template
 		        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
		-->
  </xsl:template>

  <xsl:template name="replace-string_recursive">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="with"/>
    <xsl:variable name="result">
      <xsl:call-template name="replace-string">
        <xsl:with-param name="text" select="$text"/>
        <xsl:with-param name="replace" select="$replace"/>
        <xsl:with-param name="with" select="$with"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="contains($result,$replace)">
        <xsl:call-template name="replace-string_recursive">
          <xsl:with-param name="text" select="$result"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="with" select="$with"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$result"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>
  <xsl:template name="replace-string">
    <xsl:param name="text"/>
    <xsl:param name="replace"/>
    <xsl:param name="with"/>
    <xsl:choose>
      <xsl:when test="contains($text,$replace)">
        <xsl:value-of select="substring-before($text,$replace)"/>
        <xsl:value-of select="$with"/>
        <xsl:call-template name="replace-string">
          <xsl:with-param name="text"
select="substring-after($text,$replace)"/>
          <xsl:with-param name="replace" select="$replace"/>
          <xsl:with-param name="with" select="$with"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$text"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
