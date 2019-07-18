<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes"/>

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
        <table border="1">
          <tr>
            <th></th>
            <th>Title</th>
            <th>Pub Date</th>
            <th>Pages</th>
          </tr>
          <xsl:apply-templates/>
        </table>
      </body>
    </html>
  </xsl:template>



  <xsl:template match="/root/items">
    <tr>
      <td>
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="volumeInfo/infoLink"/>
          </xsl:attribute>
          <img>
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
  </xsl:template>

  <xsl:template match="@* | node()">

    <xsl:apply-templates />

    <!-- DEFAULT Template
 		        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
		-->
  </xsl:template>


</xsl:stylesheet>
