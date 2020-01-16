<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes" indent="no"/>
  <xsl:template match="ParentData">
    <xsl:text disable-output-escaping="yes"><![CDATA[@model ]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Models.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[
@{
    Layout = null;
    int rec = (int)ViewBag.detail]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Recnum;
}
<tr>
	<td>
		<input type="hidden" value="true" id="]]></xsl:text>
<xsl:value-of select="EntityClassName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[[@rec].shouldadd" name="]]></xsl:text>
<xsl:value-of select="EntityClassName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[[@rec].shouldadd" />
		<input type="button" id="delete" onclick="this.parentElement.parentElement.style.display = 'none'; document.getElementById(']]></xsl:text>
<xsl:value-of select="EntityClassName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[[@rec].shouldadd').value = 'false';" value="Delete" class="btn btn-danger">
	</td>]]></xsl:text>
    <xsl:apply-templates select="ChildData"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[
</tr>]]></xsl:text>
  </xsl:template>
  <xsl:template match="ChildData">
    <xsl:text disable-output-escaping="yes"><![CDATA[
	<td>
		<input id="]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[[@rec].]]></xsl:text>
    <xsl:value-of select="EntityPropertyName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[" name="]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[[@rec].]]></xsl:text>
    <xsl:value-of select="EntityPropertyName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[" value="@Model.]]></xsl:text>
    <xsl:value-of select="EntityPropertyName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[" class="form-control" />
        <span asp-validation-for="]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[[@rec].]]></xsl:text>
    <xsl:value-of select="EntityPropertyName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[" class="text-danger"></span>
	</td>]]></xsl:text>
  </xsl:template>
</xsl:stylesheet>
