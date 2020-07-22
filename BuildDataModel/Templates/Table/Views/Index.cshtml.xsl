<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes" indent="no"/>
  <xsl:template match="ParentData">
    <xsl:text disable-output-escaping="yes"><![CDATA[@model ]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Code.]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[Pager

@{
    ViewData["Title"] = "List ]]></xsl:text>
    <xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[";
} 

<h4>@ViewData["Title"]</h4>
<form method="post" id="Pager">
    @{
        await Html.RenderPartialAsync("..//shared//Pager.cshtml", (]]></xsl:text>
    <xsl:value-of select="AppName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[.Code.ListPager)Model);
    }
</form>
<table class="table table-striped table-responsive" style="white-space:nowrap; padding: 0 0 0 0;">
    <thead>
        <tr>
            <th>
                <a asp-action="Create" class="btn btn-primary btn-sm"><i class="fas fa-plus"></i></a>
            </th>
            <th>
            </th>
            <th>
            </th>]]></xsl:text>
    <xsl:for-each select="ChildData[IsKey = 0]">
      <xsl:sort select="OrdinalPosition" data-type="number"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[
            <th>
                @Html.DisplayNameFor(model => model.ObjList.FirstOrDefault().]]></xsl:text>
      <xsl:value-of select="EntityPropertyName"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[)
            </th>]]></xsl:text>
    </xsl:for-each>
    <xsl:text disable-output-escaping="yes"><![CDATA[
        </tr>
    </thead>
    <tbody>
@foreach (var item in Model.ObjList) {
        <tr>]]></xsl:text>
    <xsl:for-each select="ChildData[IsKey = 1][1]">
      <xsl:text disable-output-escaping="yes"><![CDATA[           
                <td style="width:0;">
                    <a asp-action="Edit" asp-route-id="@item.]]></xsl:text>
      <xsl:value-of select="EntityPropertyName"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[" class="btn btn-primary btn-sm"><i class="fas fa-edit"></i></a>
                </td>
                <td style="width:0;">
                    <a asp-action="Details" asp-route-id="@item.]]></xsl:text>
      <xsl:value-of select="EntityPropertyName"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[" class="btn btn-secondary btn-sm"><i class="fas fa-binoculars"></i></a>
                </td>
                <td style="width:0;">
                    <a asp-action="Delete" asp-route-id="@item.]]></xsl:text>
      <xsl:value-of select="EntityPropertyName"/>
      <xsl:text disable-output-escaping="yes"><![CDATA[" class="btn btn-danger btn-sm"><i class="fas fa-remove"></i></a>
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
