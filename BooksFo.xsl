<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="xml" indent="yes"/>
	<xsl:param name="dings"/>
	<xsl:template match="/">
		<fo:root>
			<fo:layout-master-set>
				<fo:simple-page-master master-name="A4-portrait" page-height="29.7cm" page-width="21.0cm" margin="2cm">
					<fo:region-body/>
				</fo:simple-page-master>
			</fo:layout-master-set>
			<fo:page-sequence master-reference="A4-portrait">
				<fo:flow flow-name="xsl-region-body">
					<fo:block font-size="16" color="blue">Bücher:<xsl:value-of select="$dings"/>
						<fo:table>
							<fo:table-column />
							<fo:table-column column-width="25mm"/>
							<fo:table-header>
								<fo:table-row>
									<fo:table-cell>
										<fo:block font-weight="bold">Titel</fo:block>
									</fo:table-cell>
									<fo:table-cell>
										<fo:block font-weight="bold">Pages</fo:block>
									</fo:table-cell>
								</fo:table-row>
							</fo:table-header>
							<fo:table-body>
								<xsl:for-each select="/root/items">
									<fo:table-row>
										<fo:table-cell>
											<fo:block>
												<xsl:value-of select="volumeInfo/title"/>
											</fo:block>
										</fo:table-cell>
										<fo:table-cell>
											<fo:block>
												<xsl:value-of select="volumeInfo/pageCount"/>
											</fo:block>
										</fo:table-cell>
									</fo:table-row>
								</xsl:for-each>
							</fo:table-body>
						</fo:table>
					</fo:block>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>
</xsl:stylesheet>