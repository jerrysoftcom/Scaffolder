<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes" indent="no"/>
  <xsl:template match="ParentData">
    <xsl:text disable-output-escaping="yes"><![CDATA[@model IEnumerable<]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Models.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[>

<button type="button" id="add]]></xsl:text>
<xsl:value-of select="EntityClassName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[" class="btn btn-primary" onclick="AjaxRunPlus('/]]></xsl:text>
<xsl:value-of select="EntityClassName"/>
<xsl:text disable-output-escaping="yes"><![CDATA[/Line','InvoiceitemsTbody', 'rec')">Add New</button>

<table class="table">
    <thead>
        <tr>
            <th></th>]]></xsl:text>
    <xsl:for-each select="ChildData[IsKey = 0]">
      <xsl:sort select="OrdinalPosition" data-type="number"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[
            <th>
                @Html.DisplayNameFor(model => model.]]></xsl:text>
      <xsl:value-of select="EntityPropertyName"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[)
            </th>]]></xsl:text>
    </xsl:for-each>
    <xsl:text disable-output-escaping="yes"><![CDATA[
        </tr>
    </thead>
    <tbody id="]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Tbody">
        @if (ViewBag.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Recnum == null)
        {
            ViewBag.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Recnum = -1;
        }
        @foreach (var item in Model)
        {
            ViewBag.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Recnum += 1;
            await Html.RenderPartialAsync("Line.cshtml", item);
        }
    </tbody>
</table>
<input type="hidden" id="rec" value="@ViewBag.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Recnum" />]]></xsl:text>
  </xsl:template>
</xsl:stylesheet>