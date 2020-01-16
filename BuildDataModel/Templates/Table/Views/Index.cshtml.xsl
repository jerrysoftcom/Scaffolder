<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes" indent="no"/>
  <xsl:template match="ParentData">
    <xsl:text disable-output-escaping="yes"><![CDATA[@model IEnumerable<]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Models.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[>

@{
    ViewData["Title"] = "Index";
} 

<h1>Index</h1>

<p>
    <a asp-action="Create" class="btn btn-primary btn-sm">Create New</a>
</p>
<partial name="Pager" />
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
    <tbody>
@foreach (var item in Model) {
        <tr>]]></xsl:text>
    <xsl:for-each select="ChildData[IsKey = 1][1]">
      <xsl:text disable-output-escaping="yes"><![CDATA[
            <td>
                <table class="table-borderless" style="margin-top:-15px;">
                    <tr>
                        <td>
                            <a asp-action="Edit" asp-route-id="@item.]]></xsl:text>
      <xsl:value-of select="EntityPropertyName"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[" class="btn btn-primary btn-sm">Edit</a>
                        </td>
                        <td>
                            <a asp-action="Details" asp-route-id="@item.]]></xsl:text>
      <xsl:value-of select="EntityPropertyName"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[" class="btn btn-secondary btn-sm">Details</a>
                        </td>
                        <td>
                            <a asp-action="Delete" asp-route-id="@item.]]></xsl:text>
      <xsl:value-of select="EntityPropertyName"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[" class="btn btn-danger btn-sm">Delete</a>
                        </td>
                    </tr>
                </table>
            </td>]]></xsl:text>
    </xsl:for-each>
    <xsl:for-each select="ChildData[IsKey = 0]">
      <xsl:sort select="OrdinalPosition" data-type="number"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[
            <td>
                @Html.DisplayFor(modelItem => item.]]></xsl:text>
      <xsl:value-of select="EntityPropertyName"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[)
            </td>]]></xsl:text>
    </xsl:for-each>
    <xsl:text disable-output-escaping="yes"><![CDATA[
        </tr>
}
    </tbody>
</table>
]]></xsl:text>
  </xsl:template>
</xsl:stylesheet>
