<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:strip-space elements="*"/>
  <xsl:output omit-xml-declaration="yes" indent="no"/>
  <xsl:template match="ParentData">@model <xsl:value-of select="AppName"/>.Models.<xsl:value-of select="EntityClassName"/>
    <xsl:text disable-output-escaping="yes"><![CDATA[
@{
    ViewData["Title"] = "Edit";
} 

<h1>Edit</h1>

<h4>]]></xsl:text><xsl:value-of select="EntityClassName"/><xsl:text disable-output-escaping="yes"><![CDATA[</h4>
<hr />
<div class="row">
    <div class="col-md-4">
        <form asp-action="Edit">
            <div asp-validation-summary="ModelOnly" class="text-danger"></div>]]></xsl:text>
    <xsl:for-each select="ChildData">
      <xsl:sort select="OrdinalPosition" data-type="number"/>
      <xsl:choose>
        <xsl:when test="IsKey = 1">
          <xsl:text disable-output-escaping="yes"><![CDATA[
            <input type="hidden" asp-for="]]></xsl:text>
          <xsl:value-of select="EntityPropertyName"/>
          <xsl:text disable-output-escaping="yes"><![CDATA[" />
]]></xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text disable-output-escaping="yes"><![CDATA[            <div class="form-group">
                <label asp-for="]]></xsl:text>
          <xsl:value-of select="EntityPropertyName"/>
          <xsl:text disable-output-escaping="yes"><![CDATA[" class="control-label"></label>
                <input asp-for="]]></xsl:text>
          <xsl:value-of select="EntityPropertyName"/>
          <xsl:text disable-output-escaping="yes"><![CDATA[" class="form-control" />
                <span asp-validation-for="]]></xsl:text>
          <xsl:value-of select="EntityPropertyName"/>
          <xsl:text disable-output-escaping="yes"><![CDATA[" class="text-danger"></span>
            </div>
]]></xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:text disable-output-escaping="yes"><![CDATA[
          @*@{//UnRemark add line enties here
                await Html.RenderPartialAsync("..\\LineTable\\Lines", new List<LinesType>());
            }*@	            <div class="form-group">
                <input type="submit" value="Save" class="btn btn-primary" />
            </div>
        </form>
    </div>
</div>

<div>
    <a asp-action="Index">Back to List</a>
</div>

@section Scripts {
    @{await Html.RenderPartialAsync("_ValidationScriptsPartial");}
}
]]></xsl:text>
  </xsl:template>
</xsl:stylesheet>